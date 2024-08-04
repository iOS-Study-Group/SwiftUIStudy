//
//  SumchiveSignUpModel.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 8/2/24.
//

import Foundation
import Firebase

// 회원가입 모델
class SignUpModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordCheck: String = ""
    @Published var name: String = ""
    
    @Published var emailMessage: String = "email@xxx.com"
    @Published var passwordMessage: String = "8글자 이상"
    @Published var nameMessage: String = "ex) 홍길동"
    
    @Published var signUpMessage: String = ""
    @Published var isSignUp: Bool = false
    
    // 회원가입하는 함수
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("!ERROR! : \(error.localizedDescription)")
                self.signUpMessage = error.localizedDescription
                self.isSignUp = false
            } else {
                // 회원가입 성공
                self.isSignUp = true
                self.signUpMessage = "회원가입이 성공적으로 완료되었습니다."
            }
        }
    }
    
    // 이메일과 비번 창이 비어있는지, 형식이 맞는지 확인하는 함수
    func emptyFormatCheck(email: String, password: String, passwordCheck: String, name: String) {
        emailMessage = ""
        passwordMessage = ""
        nameMessage = ""
        
        // 이메일 입력 안함
        if email.isEmpty {
            emailMessage = "이메일을 입력해주세요"
        }
        
        // 이메일 형식 안 맞음
        else if !emailFormat(email) {
            emailMessage = "올바른 형식의 이메일을 입력해주세요"
        }
        
        // 비밀번호 입력 안함
        if password.isEmpty || passwordCheck.isEmpty {
            passwordMessage = "비밀번호를 입력해주세요"
        }
        
        // 비밀번호와 비밀번호 확인이 일치하지 않음
        if password != passwordCheck {
            passwordMessage = "비밀번호가 일치하지 않습니다."
        }
        
        // 이름 입력 안함
        if name.isEmpty {
            nameMessage = "이름을 입력해주세요"
        }
        
        // 비어있지 않고, 형식이 모두 맞는 경우 회원가입 시도
        if emailMessage.isEmpty && passwordMessage.isEmpty && nameMessage.isEmpty {
            self.email = email
            self.password = password
            self.name = name
            signUp()
        }
    }
    
    func emailFormat(_ email: String) -> Bool {
        // ~~~ @ ~~~ . ~~~ (중간에 골뱅이와 온점이 있어야함)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
