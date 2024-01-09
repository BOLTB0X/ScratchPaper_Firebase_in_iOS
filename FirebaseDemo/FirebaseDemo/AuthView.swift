//
//  AuthView.swift
//  FirebaseDemo
//
//  Created by lkh on 1/9/24.
//

import SwiftUI
import FirebaseAuth

// MARK: - AuthView
struct AuthView: View {
    // MARK: Object
    @ObservedObject var authManager = AuthManager.shared
    
    // MARK: State
    @State var email = ""
    @State var password = ""
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack {
                if authManager.state == .signedOut {
                    
                    AuthSignInView()
                    
                } else {
                    HStack {
                        Button("Sign out") {
                            authManager.signOut()
                        }
                        Button("탈퇴") {
                            authManager.deleteUser()
                        }
                    }
                    
                    StorageView()
                }
            } // VStack
            .padding()
            .onAppear {
                authManager.checkSignIn()
            }
        }
    }
}
#Preview {
    AuthView()
}
