//
//  Restaurant.swift
//  FirebaseDemo
//
//  Created by lkh on 1/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - Restaurant
struct Restaurant : Codable, Hashable {
    var name: String
    var address: String
    var dateAdded: Timestamp
    
    // dateAdded 입력 생략시 기본 데이터로 초기화
    init(name: String, address: String, dateAdded: Timestamp = Timestamp(date: Date())) {
        self.name = name
        self.address = address
        self.dateAdded = dateAdded
    }
}

// MARK: - RestaurantStore
class RestaurantStore: ObservableObject {
    static let shared = RestaurantStore() // 싱글톤
    
    init() {}
    
    // MARK: - 프로퍼티s
    @Published var restaurants = [Restaurant]()
    
    let db = Firestore.firestore()
    let collectionName = "Restaurants"
    var listener: ListenerRegistration?
    // ..
    
    // MARK: - Methods
    // ...
    // MARK: - fetchAllRestaurant
    // 컬렉션 전체 문서 데이터 불러오기
    func fetchAllRestaurant() {
        db.collection("Restaurants").getDocuments() { (snapshot, error) in
            guard error == nil else { return }
            
            // 기존 목록 비우기
            self.restaurants.removeAll()
            
            // 새로운 목록으로 채우기
            for document in snapshot!.documents {
                //                let data = document.data()
                //                print("data", data)
                //                self.restaurants.append(Restaurant(id: "", name: data["name"] as? String ?? "", address: data["address"] as? String ?? "", dateAdded: data["dateAdded"] as? Timestamp ?? Timestamp())
                //                )
                
                if let rest = try? document.data(as: Restaurant.self) {
                    self.restaurants.append(rest)
                    print("data", rest)
                }
            } // for
        } // db.collection("Restaurants")
        
    }
    
    // MARK: - addRestaurant
    // ..
    // 컬렉션에 문서 데이터 추가하기 1
    func addRestaurant(docName: String, docData: [String : Any]) {
        let docRef = db.collection("Restaurants").document(docName)
        docRef.setData(docData) { error in
            if let error = error {
                print(error)
            } else {
                print("Success:", docName)
            }
        }
    }
    
    // 컬렉션에 문서 데이터 추가하기 2
    func addRestaurant(restaurant: Restaurant) {
        //        let docData: [String: Any] = [
        //            "name": restaurant.name,
        //            "address": restaurant.address,
        //            "dateAdded": restaurant.dateAdded
        //        ]
        //        addRestaurant(docName: restaurant.name, docData: docData)
        try? db.collection("Restaurants").document(restaurant.name).setData(from: restaurant)
    }
    
    // MARK: - updateRestaurant
    // 문서 데이터 부분 변경(갱신)
    func updateRestaurant(restaurantName: String, restaurantAddress: String) {
        let docRef = db.collection("Restaurants").document(restaurantName)
        //        docRef.setData( ["address": restaurantAddress], merge: true) { error in
        //            if let error = error {
        //                print("Error writing document:", error)
        //            } else {
        //                print("Success merged:", restaurantName)
        //            }
        //        }
        docRef.updateData(["address": restaurantAddress]) { error in
            if let error = error {
                print("Error writing document:", error)
            } else {
                print("Success merged:", restaurantName)
            }
        }
    }
    
    // MARK: - deleteRestaurant
    // 문서 데이터 삭제
    func deleteRestaurant(restaurantName: String) {
        let docRef = db.collection("Restaurants").document(restaurantName)
        docRef.delete() { error in
            if let error = error {
                print("Error deleting document:", error)
            } else {
                print("Success deleted:", restaurantName)
            }
        }
    }
    
    // MARK: - startListening
    // Cloud Firestore로 실시간 업데이트 가져오기
    // 데이터베이스를 실시간으로 관찰하여 데이터 변경 여부를 확인
    func startListening() {
        listener =
        db.collection(collectionName).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    if let storeRest = try? diff.document.data(as: Restaurant.self) {
                        self.restaurants.append(storeRest)
                        print("add data", storeRest)
                    }
                }
                
                if (diff.type == .modified) {
                    print("Modified city: \(diff.document.data())")
                }
                
                if (diff.type == .removed) {
                    if let storeRest = try? diff.document.data(as: Restaurant.self) {
                        for (index, item) in self.restaurants.enumerated() where storeRest.name == item.name {
                            self.restaurants.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - stopListening
    // 데이터베이스를 실시간으로 관찰하는 것을 중지
    func stopListening() {
        listener?.remove()
        print("stopListening")
        // 기존 목록 비우기
        self.restaurants.removeAll()
    }
    
}
