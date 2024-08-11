//
//  LipsCreateAccountViewModel.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 8/4/24.
//

import Foundation
import FirebaseAuth

class LipsCreateAccountViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    func signUp(email: String, userName:String, password: String) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            _ = result.user
            DispatchQueue.main.async {
                
                self.errorMessage = nil
                self.successMessage = "\(userName)님 환영합니다. 회원가입에 성공하셨습니다"
                print("회원가입 성공")
            }
           
        }
        catch {
            DispatchQueue.main.async {
                
                self.successMessage = nil
                self.errorMessage = error.localizedDescription
                print("회원가입 실패: \(error.localizedDescription)")
            }
            
        }
    }
    
    func login(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            _ = result.user
            DispatchQueue.main.async {
                
                
                self .errorMessage = nil
                self.successMessage = "로그인에 성공하였습니다"
                
                print("로그인성공")
            }
        }
        catch {
            print("로그인 실패 \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.successMessage = nil
                self.errorMessage = "로그인에 실패하셨습니다. 아이디 비밀번호를 확인해 주세요"
                print("로그인 실패 : \(error.localizedDescription)")
            }
        }
    }
    
}
