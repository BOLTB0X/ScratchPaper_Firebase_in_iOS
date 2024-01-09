//
//  AuthSignInView.swift
//  FirebaseDemo
//
//  Created by lkh on 1/9/24.
//

import SwiftUI

// MARK: - AuthSignInView
struct AuthSignInView: View {
    // MARK: Object
    @ObservedObject var authManager = AuthManager.shared
    
    // MARK: State
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var isProcessing = false
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $emailText)
                SecureField("Password", text: $passwordText)

                if isProcessing {
                    ProgressView()
                }

                Button("Sign in") {
                    isProcessing = true
                    authManager.emailAuthSignIn(email: emailText, password: passwordText)
                }
                .disabled(emailText.isEmpty || passwordText.isEmpty)


                NavigationLink {
                    AuthSignUpView()
                } label: {
                    Text("가입")
                }
            } // VStack
            .padding()
        } // NavigationStack
    } // body
}

#Preview {
    AuthSignInView()
}
