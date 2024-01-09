//
//  AuthSignUpView.swift
//  FirebaseDemo
//
//  Created by lkh on 1/9/24.
//

import SwiftUI

struct AuthSignUpView: View {
    // MARK: Object
    @ObservedObject var authManager = AuthManager.shared

    // MARK: State
    @State private var nameText = ""
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var passwordConfirmText = ""

    @State private var isNameCountError = false
    @State private var isEmailError = false
    @State private var isPasswordCountError = false
    @State private var isPasswordConfirmError = false

    // MARK: - View
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("이름")
                    .font(.headline)
                TextField("2자리 이상 이름을 입력하세요.", text: $nameText)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .onChange(of: nameText) {
                        isNameCountError = nameText.count < 2 ? true : false
                    }

                Text("이름은 2자 이상 입력해주세요.")
                    .font(.system(size: 16))
                    .foregroundStyle(isNameCountError ? .red : .clear)
            } // VStack

            VStack(alignment: .leading) {
                Text("이메일")
                    .font(.headline)
                TextField("이메일 입력하세요.", text: $emailText)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .onChange(of: emailText) {
                        isEmailError = !isValidEmail(emailText) ? true : false
                    }

                Text("이메일 입력하세요.")
                    .font(.system(size: 16))
                    .foregroundStyle(isEmailError ? .red : .clear)
            } // VStack

            VStack(alignment: .leading) {
                Text("비밀번호")
                    .font(.headline)
                SecureField("비밀번호 6자리 이상 입력하세요.", text: $passwordText)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .onChange(of: passwordText) {
                        isPasswordCountError = passwordText.count < 6 ? true : false
                    }

                Text("비밀번호를 6자리 이상 입력하세요.")
                    .font(.system(size: 16))
                    .foregroundStyle(isPasswordCountError ? .red : .clear)
            } // VStack

            VStack(alignment: .leading) {
                Text("비밀번호")
                    .font(.headline)
                SecureField("비밀번호를 다시 입력하세요.", text: $passwordConfirmText)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .onChange(of: passwordConfirmText) {
                        isPasswordConfirmError = passwordConfirmText != passwordText ? true : false
                    }

                Text("비밀번호가 서로 다릅니다.")
                    .font(.system(size: 16))
                    .foregroundStyle(isPasswordConfirmError ? .red : .clear)
            } // VStack

            Button("가입") {
                authManager.emailAuthSignUp(userName: nameText, email: emailText, password: passwordText)
            }
            .disabled(!checkSingUpCond())
        }
        .padding()
    }
    
    // MARK: - checkSingUpCond
    // 가입 버튼 체크 함수
    func checkSingUpCond() -> Bool {
        if isNameCountError || isEmailError || isPasswordCountError || isPasswordConfirmError {
            return false
        }
        return true
    }

}

// 이메일 형식 검사
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailConfirm = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailConfirm.evaluate(with: email)

}

#Preview {
    AuthSignUpView()
}
