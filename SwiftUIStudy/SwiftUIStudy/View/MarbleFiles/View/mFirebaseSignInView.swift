//
//  mFirebaseLoginView.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/30.
//

import SwiftUI

struct mFirebaseSignInView: View {
    @EnvironmentObject var authManager : mAuthenticationManager
    @Binding var isSignIn: Bool
    @State var email: String = ""
    @State var password: String = ""
    @State var isError : Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(spacing : 5) {
                        TextField("ID", text: $email)
                            .modifier(textFieldModifier(width: UIScreen.main.bounds.width * 0.51, height: UIScreen.main.bounds.height * 0.04))
                        SecureField("Password", text: $password)
                            .modifier(textFieldModifier(width: UIScreen.main.bounds.width * 0.51, height: UIScreen.main.bounds.height * 0.04))
                    }
                    .background(backColor)
                    Button {
                        Task {
                            await clickLoginButton(email, password)
                        }
                    } label : {
                        RoundedRectangle(cornerRadius: 7)
                            .foregroundColor(.white)
                            .opacity(0.5)
                            .frame(height: UIScreen.main.bounds.height * 0.085)
                            .overlay {
                                Text("Login")
                                    .foregroundStyle(.black)
                                    .opacity(0.5)
                            }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.14)
            }
        }
        if isError {
            ZStack {
                backView()
                alertView("Error", "Email 또는 password를 확인해주세요.", checkButton)
            }
        }
    }
}

extension mFirebaseSignInView {
    func clickLoginButton(_ email : String, _ password : String) async {
        let error = await authManager.signIn(email, password)
        if error {
            isError.toggle()
        } else {
            isSignIn.toggle()
        }
    }
    
    func checkButton() -> some View {
        Button {
            isError.toggle()
        } label : {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(alertBackColor)
                .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05)
                .overlay {
                    Text("확인")
                        .foregroundStyle(.blue)
                }
        }
    }
}

//
//#Preview {
//    mFirebaseLoginView()
//}
