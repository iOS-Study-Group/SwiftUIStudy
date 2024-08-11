//
//  SLogInOnFirebase.swift
//  SwiftUIStudy
//
//  Created by 이소영 on 7/30/24.
//

import SwiftUI

struct SLogInOnFirebase: View {
    @ObservedObject var loginOnFirebaseManager: LoginOnFirebaseManager = LoginOnFirebaseManager()
    @State var email: String = ""
    @State var password: String = ""
    @State var repeatPassword: String = ""
    @State var signUpOnFirebase: Bool = false
    @State var isBeginning: Bool = true
    @State var isSignup: Bool = false
    @State var isSignin: Bool = false
    @State var isCompleteSignup: Bool = false
    @State var isCompleteSignin: Bool = false
    @State var resultSignup: String = ""
    @State var resultSignin: String = ""
    @State var xOffsetEmail: CGFloat = 0
    @State var xOffsetPassword: CGFloat = 0
    @State var xOffsetRepeat: CGFloat = 0
    
    var body: some View {
        VStack {
            if !loginOnFirebaseManager.isSignInOnFirebase() {
            ZStack {
                Circle()
                    .fill(.gray.opacity(0.3))
                    .scaleEffect(2.2)
                    .offset(y:150)
            
                VStack {
                    Image("FirebaseAuth")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                        if !isBeginning {
                            VStack(alignment: .leading) {
                                TextField("Enter your email", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .onChange(of: email) {
                                        xOffsetEmail = loginOnFirebaseManager.isValidEmail(email) ? 0 : 1
                                    }
                                    .offset(x: xOffsetEmail)
                                    .animation(!loginOnFirebaseManager.isValidEmail(email) ? .easeInOut(duration: 0.4) .repeatForever(autoreverses: true) : .default, value: xOffsetEmail)
                                    
                                Divider()
                                
                                Text(xOffsetEmail == 1 ? "Enter the correct email format" : "")
                                    .foregroundStyle(.red)
                                    .font(.system(size: 12))
                                
                                SecureField("Enter your password", text: $password)
                                    .disabled(!loginOnFirebaseManager.isValidEmail(email))
                                    .onChange(of: password) {
                                        xOffsetPassword = password.count < 6 ? 1 : 0
                                    }
                                    .offset(x: xOffsetPassword)
                                    .animation(password.count < 6 ? .easeInOut(duration: 0.4) .repeatForever(autoreverses: true) : .default, value: xOffsetPassword)
                                
                                Divider()
                                
                                Text(xOffsetPassword == 1 ? "Please enter at least six digits." : "")
                                    .foregroundStyle(.red)
                                    .font(.system(size: 12))
                                
                                if isSignup {
                                    SecureField("Enter your password again", text: $repeatPassword)
                                        .disabled(password.count < 6)
                                        .onChange(of: repeatPassword) {
                                            xOffsetRepeat = password != repeatPassword ? 1 : 0
                                        }
                                        .offset(x: xOffsetRepeat)
                                        .animation(password != repeatPassword ? .easeInOut(duration: 0.4) .repeatForever(autoreverses: true) : .default, value: xOffsetRepeat)
                                    
                                    Divider()
                                    
                                    Text(xOffsetRepeat == 1 && isSignup ? "The two passwords don't match" : "")
                                        .foregroundStyle(.red)
                                        .font(.system(size: 12))
                                }
                            }
                        }
                        
                        if !isSignin {
                            Button("Sign up") {
                                if isBeginning {
                                    isBeginning = false
                                    isSignup = true
                                } else {
                                    Task {
                                        if await loginOnFirebaseManager.signUpOnFirebase(email, password) {
                                            isSignup = false
                                            isSignin = true
                                            signUpOnFirebase = true
                                            resultSignup = "You have successfully registered."
                                            password = ""
                                            repeatPassword = ""
                                        } else {
                                            resultSignup = "You failed to sign up.\n Please try again"
                                        }
                                        isCompleteSignup = true
                                    }
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(isSignup && (email == "" || password.count < 6 || password != repeatPassword))
                            .tint(.orange)
                            .padding()
                            .alert(isPresented: $isCompleteSignup, content: {
                                Alert(title: Text(resultSignup), dismissButton: .default(Text("ok"), action: {
                                    if !signUpOnFirebase {
                                        resetAll()
                                    }
                                }))
                            })
                        }
                        
                        if !isSignup {
                            Button("Sign in") {
                                if isBeginning {
                                    isBeginning = false
                                    isSignin = true
                                } else {
                                    Task {
                                        if await loginOnFirebaseManager.signInOnFirebase(email, password) {
                                            resultSignin = ""
                                        } else {
                                            resultSignin = "You failed to sign in.\n Please check your password."
                                        }
                                        password = ""
                                        repeatPassword = ""
                                        isCompleteSignin = true
                                    }
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(isSignin && (email == "" || password.count < 6))
                            .tint(.orange)
                            .padding()
                            .alert(isPresented: $isCompleteSignin, content: {
                                Alert(title: Text(resultSignin), dismissButton: .default(Text("ok")))
                            })
                        }
                    }
                }
            } else {
                SLinkDataView()
            }
        }
        .padding()
    }
    
    func resetAll() {
        email = ""
        password = ""
        repeatPassword = ""
        signUpOnFirebase = false
        isBeginning = true
        isSignup = false
        isSignin = false
        isCompleteSignup = false
        isCompleteSignin = false
        resultSignup = ""
        resultSignin = ""
        xOffsetEmail = 0
        xOffsetPassword = 0
        xOffsetRepeat = 0
    }
}

#Preview {
    SLogInOnFirebase()
}
