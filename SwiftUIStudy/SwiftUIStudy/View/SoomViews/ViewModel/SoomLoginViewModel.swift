//
//  SoomLoginViewModel.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/31/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class SoomSignUpViewModel: ObservableObject{
    @Published var isLogin: Bool = false
    @Published var isCreate: Bool = false
    let auth = Auth.auth()
   
    func signIn(email: String, password: String) async {
        do{
            try await auth.signIn(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.isLogin = true
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func registerCheck(email: String, password: String)async{
        do{
            try await auth.createUser(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.isCreate = true
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}
