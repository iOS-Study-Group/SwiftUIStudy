
//
//  SumchiveSignInModel.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 8/2/24.
//

import Foundation
import Firebase

//로그인 모델

class SignInModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var emailMessage: String = "email@xxx.com"
    @Published var passwordMessage: String = "8글자 이상"
    
    @Published var signInMessage: String = ""

    
    @Published var isSignIn: Bool = false

    //로그인하는 함수
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            // 입력한 이메일, 비번이 파이어스토에 없는 경우
            if let error = error {
                print("!ERROR! : \(error.localizedDescription)")
                self.signInMessage = "이메일 또는 비밀번호가 일치하지 않습니다."
                self.isSignIn = false
            }
            
            // 로그인 성공
            else {
                self.isSignIn = true
                self.signInMessage = ""
            }
        }
    }
    
    //이메일과 비번 창이 비어있는지, 형식이 맞는지 확인하는 함수
    func emptyFormatCheck(email: String, password: String) {
        emailMessage = ""
        passwordMessage = ""
        
        // 이메일 입력 안함
        if email.isEmpty {
            emailMessage = "이메일을 입력해주세요"
        }
        
        //이메일 형식 안맞음
        else if !emailFormat(email) {
            emailMessage = "올바른 형식의 이메일을 입력해주세요"
        }
        
        //비번 입력 안함
        if password.isEmpty {
            passwordMessage = "비밀번호를 입력해주세요"
        }
        
        //비어있지않고,형식이 모두 맞는 경우 로그인 시도
        if emailMessage.isEmpty && passwordMessage.isEmpty  {
            self.email = email
            self.password = password
            signIn()
        }
    }
    
    //이메일 포맷 확인하는 함수
    func emailFormat(_ email: String) -> Bool {
        //~~~ @ ~~~ . ~~~ (중간에 골뱅이와 온점이 있어야함)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

