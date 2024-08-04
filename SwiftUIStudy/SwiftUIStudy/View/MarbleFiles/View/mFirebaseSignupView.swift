//
//  mFirebaseSignupView.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/30.
//

import SwiftUI

struct mFirebaseSignupView: View {
    @EnvironmentObject var authManager : mAuthenticationManager
    @Binding var isSignUp: Bool
    @State var email: String = ""
    @State var password: String = ""
    @State var errorText: String = ""
    @State var isSuccessSignUp: Bool = false
    
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
                        clickSignUpButton(email, password)
                    } label : {
                        RoundedRectangle(cornerRadius: 7)
                            .foregroundColor(.white)
                            .opacity(0.5)
                            .frame(height: UIScreen.main.bounds.height * 0.085)
                            .overlay {
                                Text("Registry")
                                    .foregroundStyle(.black)
                                    .opacity(0.5)
                            }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.14)
            }
            if errorText != "" {
                ZStack {
                    backView()
                    alertView("Error", errorText, errorButton)
                }
            }
            if isSuccessSignUp {
                ZStack {
                    backView()
                    alertView("알림", "회원가입이 완료되었습니다.", checkButton)
                }
            }
        }
    }
}


extension mFirebaseSignupView {
    func clickSignUpButton(_ email : String, _ password : String) {
        do {
            try authManager.createAccount(email, password)
            
            isSuccessSignUp.toggle()
        } catch {
            errorText = error.localizedDescription
        }
    }
    
    func errorButton() -> some View {
        Button {
            errorText = ""
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
    
    func checkButton() -> some View {
        Button {
            isSuccessSignUp.toggle()
            email = ""
            password = ""
            isSignUp.toggle()
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
//    mFirebaseSignupView(isSignUp : $isSignUp)
//}
