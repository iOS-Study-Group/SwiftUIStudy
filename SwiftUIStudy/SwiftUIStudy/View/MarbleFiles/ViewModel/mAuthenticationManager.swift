//
//  mAuthenticationManager.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/31.
//

import Foundation
import FirebaseAuth

class mAuthenticationManager : ObservableObject{
    func createAccount(_ email : String, _ password : String) throws {
        if email.split(separator: "@").count < 2 || email.split(separator: ".").count < 2 {
            print("wrong ID")
            throw mAuthError.shortID
        }
        
        if password.count < 8 {
            print("short password")
            throw mAuthError.shortPassword
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                print(error)
                return
            }
            print("\(user.email!) created")
        }
    }
    
    func signIn(_ email : String, _ password : String) async -> Bool {
        var isError : Bool = false
        do {
            try await withCheckedThrowingContinuation { continuation in
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    } else if let authResult = authResult {
                        continuation.resume(returning: authResult)
                    } else {
                        // 만약 error도 없고 authResult도 없는 경우를 대비하여 예외를 던짐
                        continuation.resume(throwing: NSError(domain: "UnexpectedError", code: -1, userInfo: nil))
                    }
                }
            } as AuthDataResult
        } catch {
            isError = true
        }
        return isError
    }
}

