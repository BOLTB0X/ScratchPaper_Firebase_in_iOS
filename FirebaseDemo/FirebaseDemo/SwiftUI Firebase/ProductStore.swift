//
//  ProductStore.swift
//  FirebaseDemo
//
//  Created by lkh on 1/8/24.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

// MARK: - Product
// 모델
struct Product : Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var description: String
    var isOrder: Bool
}

// MARK: - ProductStore
class ProductStore: ObservableObject {
    static let shared = ProductStore() // 싱글톤
    
    init() {}
    
    // MARK: - 프로퍼티
    @Published var products = [Product]()
    
    // Realtime Database의 기본 경로를 저장하는 변수
    let ref: DatabaseReference? = Database.database().reference()
    
    // Realtime Database의 데이터 구조는 기본적으로 JSON 형태
    // 저장소와 데이터를 주고받을 때 JSON 형식의 데이터로 주고받기 때문에 Encoder, Decoder의 인스턴스가 필요
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    // ...
    
    // MARK: - Methods
    // ...
    // MARK: - startListening
    // 데이터베이스를 실시간으로 관찰하여 데이터 변경 여부를 확인
    // 실시간 데이터 read, write를 가능
    func startListening() {
        guard let dbPath = ref?.child("products") else { return }
        
        // MARK: 생성 관련
        // 데이터 생성이 감지 되었을 때
        dbPath.observe(DataEventType.childAdded) { [weak self] snapshot in
            guard let self = self, let json = snapshot.value as? [String: Any] else {
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: json)
                let product = try self.decoder.decode(Product.self, from: data)
                self.products.append(product)
            } catch {
                print(error)
            }
        }
        
        // MARK: 삭제 관련
        // 데이터 삭제가 감지 되었을 때
        dbPath.observe(DataEventType.childRemoved) { [weak self] snapshot in
            guard let self = self, let json = snapshot.value as? [String: Any] else {
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: json)
                let product = try self.decoder.decode(Product.self, from: data)
                for (index, item) in self.products.enumerated() where product.id == item.id {
                    self.products.remove(at: index)
                }
            } catch {
                print(error)
            }
        }
        
        // MARK: update, read 관련
        // 데이터 변경이 감지 되었을 때
        dbPath.observe(.childChanged) {[weak self] snapshot in
            guard let self = self, let json = snapshot.value as? [String: Any] else {
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: json)
                let product = try self.decoder.decode(Product.self, from: data)
                for (index, item) in self.products.enumerated() where product.id == item.id {
                    self.products[index] = product
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    // MARK: - stopListening
    // 데이터베이스를 실시간으로 관찰하는 것을 중지
    func stopListening() {
        ref?.removeAllObservers()
    }
    
    // MARK: - addProduct
    // 데이터베이스에 Product 인스턴스를 추가
    func addProduct(item: Product) {
        self.ref?.child("products").child("\(item.id)").setValue([
            "id": item.id,
            "name": item.name,
            "description": item.description,
            "isOrder": item.isOrder
        ])
    }
    
    // MARK: - deleteProduct
    // 데이터베이스에서 특정 경로의 데이터를 삭제
    func deleteProduct(key: String) {
        ref?.child("products/\(key)").removeValue()
    }
    
    // MARK: - editProduct
    // 데이터베이스에서 특정 경로의 데이터를 수정
    func editProduct(item: Product) {
        let update: [String : Any] = [
            "id": item.id,
            "name": item.name,
            "description": item.description,
            "isOrder": item.isOrder
        ]
        
        let childItem = ["products/\(item.id)": update]
        for (index, product) in products.enumerated() where product.id == item.id {
            products[index] = item
        }
        self.ref?.updateChildValues(childItem)
    }

}
