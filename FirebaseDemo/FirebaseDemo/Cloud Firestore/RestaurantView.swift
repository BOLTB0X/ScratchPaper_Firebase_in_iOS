//
//  RestaurantView.swift
//  FirebaseDemo
//
//  Created by lkh on 1/9/24.
//

import SwiftUI

// MARK: - RestaurantView
struct RestaurantView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // MARK: Object
    @ObservedObject var restaurantStore = RestaurantStore.shared
    
    // MARK: State
    @State var name: String = ""
    @State var address: String = ""
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            TextField("name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Button("Add") {
                    // dateAdded 매개변수 생략
                    restaurantStore.addRestaurant(restaurant:
                                                    Restaurant(name: name, address: address)
                    )
                }
                Button("Update") {
                    restaurantStore.updateRestaurant(restaurantName: name, restaurantAddress: address)
                }
                Button("Delete") {
                    restaurantStore.deleteRestaurant(restaurantName: name)
                }
            }
            
            Button("Load") { restaurantStore.fetchAllRestaurant() }
            
            Spacer()
            
            List {
                ForEach(restaurantStore.restaurants, id: \.self) { rest in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(rest.name)
                            .font(.title)
                        
                        Text(rest.address)
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        restaurantStore.deleteRestaurant(restaurantName: restaurantStore.restaurants[index].name)
                    }
                    self.mode.wrappedValue.dismiss()
                })
            } // List
        } // VStack
        .padding()
        
        .onAppear {
            self.restaurantStore.startListening()
        }
        
        .onDisappear {
            self.restaurantStore.stopListening()
        }
    } // body
}

#Preview {
    RestaurantView()
}
