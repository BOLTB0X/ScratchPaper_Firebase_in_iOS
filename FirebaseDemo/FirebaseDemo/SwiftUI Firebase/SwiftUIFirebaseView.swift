//
//  SwiftUIFirebaseView.swift
//  FirebaseDemo
//
//  Created by lkh on 1/9/24.
//

import SwiftUI

// MARK: - ProductStoreView
struct ProductStoreView: View {
    // MARK: Environment
    // 현재 뷰가 표시되는 방식을 제어
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // MARK: Object
    @ObservedObject var productStore = ProductStore.shared
    
    // MARK: State
    @State var name: String = ""
    @State var description: String = ""
    @State var isOrder: Bool = false
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: 입력 부분
                TextField("name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("description", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack(alignment: .center, spacing: 5) {
                    Button {
                        productStore.addProduct(item: Product(
                            id: UUID().uuidString,
                            name: name, description: description, isOrder: isOrder))
                    } label: {
                        Text("Add Product")
                    }
                    
                    Spacer()
                    
                    Button("Update Product") {
                        if let productToUpdate = productStore.products.first(where: { $0.name == name || $0.description == description }) {

                            if name != productToUpdate.name || description != productToUpdate.description {
                                let updatedProduct = Product(
                                    id: productToUpdate.id,
                                    name: name,
                                    description: description,
                                    isOrder: productToUpdate.isOrder
                                )

                                // 데이터베이스에 업데이트
                                productStore.editProduct(item: updatedProduct)
                            }
                        }
                    }
                } // HStack
                
                // 입력 부분
                Spacer()
                
                // MARK: data List
                List {
                    ForEach(productStore.products, id: \.self) { product in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(product.name)
                                .font(.title)
                            Text(product.description)
                                .font(.subheadline)
                        }
                    } // list 내장 함수
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            productStore.deleteProduct(key: productStore.products[index].id )
                        }
                        self.mode.wrappedValue.dismiss()
                    })
                } // ata List
                
            } // VStack
            .padding()
            
            // 뷰가 나타나면 불러 옴(실시간 db)
            .onAppear {
                self.productStore.startListening()
            }
            
            // 뷰가 사라지면 중지
            .onDisappear {
                self.productStore.stopListening()
            }
        } // NavigationStack
    }
}

#Preview {
    ProductStoreView()
}
