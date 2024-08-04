//
//  LoginOnFirebaseManager.swift
//  SwiftUIStudy
//
//  Created by 이소영 on 7/30/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth

// 로그인 page
// Signup page

class LoginOnFirebaseManager: ObservableObject {
    init() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Fail to sign out \(error.localizedDescription)")
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        var isValid = false
        let emailForm = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        isValid  = NSPredicate(format: "SELF MATCHES %@", emailForm).evaluate(with: email)

        return isValid
    }
    
    func signUpOnFirebase(_ email: String, _ password: String) async -> Bool {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        } catch {
            print("fail to create user \(error.localizedDescription)")
            return false
        }
    }
    
    func signInOnFirebase(_ email: String, _ password: String) async -> Bool {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            return true
        } catch {
            print("fail to sign in \(error.localizedDescription)")
            return false
        }
    }
    
    func isSignInOnFirebase() -> Bool {
        return Auth.auth().currentUser != nil ? true : false
    }
}
