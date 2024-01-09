//
//  AuthManager.swift
//  FirebaseDemo
//
//  Created by lkh on 1/9/24.
//

import Foundation
import FirebaseAuth

enum SignInState {
    case signedIn, signedOut
}

// MARK: - AuthManager
class AuthManager: ObservableObject {
    static let shared = AuthManager()

    private init() {}

    @Published var state: SignInState = .signedOut
    
    // MARK: - emailAuthSignUp
    func emailAuthSignUp(userName: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                print(error!)
                return
            }

            if let user = result?.user {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = userName
                print("user email: \(String(describing: user.email))")
                print("user 이름: \(String(describing: user.displayName))")
            }
        }
    }

    // MARK: - emailAuthSignIn
    func emailAuthSignIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                print(error!)
                return
            }

            if let user = result?.user {
                self.state = .signedIn
                print("user email: \(String(describing: user.email))")
                print("user 이름: \(String(describing: user.displayName))")
            }
        }
    }

    // MARK: - signOut
    func signOut() {
        try? Auth.auth().signOut()
        self.state = .signedOut
    }

    // MARK: - checkSignIn
    func checkSignIn() {
        if Auth.auth().currentUser != nil {
            self.state = .signedIn
        }
    }

    // MARK: - deleteUser
    func deleteUser() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("Error deleting user", error)
                } else {
                    self.state = .signedOut
                }
            }
        }
    }

}
