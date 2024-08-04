//
//  SumchiveSignUpView.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 8/4/24.
//

import SwiftUI

struct SumchiveSignUpView: View {
    @ObservedObject private var viewModel: SignUpModel = SignUpModel()
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordCheck: String = ""
    
    let waveShape = WaveShape()
    
    var body: some View {
        ZStack {
            //배경색
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.71, green: 0.84, blue: 1.0), Color(red: 0.75, green: 0.57, blue: 1.0)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer(minLength: 300)
                
                VStack(spacing: 20) {
                    
                    Text("Sign Up")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .padding(.bottom, 30)
                    
                    TextField(" UserName", text: $name)
                        .padding(8)
                        .background(.thinMaterial)
                        .cornerRadius(12)
                        .frame(width: 300)
                        .shadow(radius: 10)
                    
                    Text(viewModel.nameMessage)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 55)
                    
                    
                    TextField(" Email", text: $email)
                        .padding(8)
                        .background(.thinMaterial)
                        .cornerRadius(12)
                        .frame(width: 300)
                        .shadow(radius: 10)
                    
                    Text(viewModel.emailMessage)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                        .padding(.leading, 55)
                    
                    SecureField(" Password", text: $password)
                        .padding(8)
                        .background(.thinMaterial)
                        .cornerRadius(12)
                        .frame(width: 300)
                        .shadow(radius: 10)
                    SecureField(" Password check", text: $passwordCheck)
                        .padding(8)
                        .background(.thinMaterial)
                        .cornerRadius(12)
                        .frame(width: 300)
                        .shadow(radius: 10)
                    
                    Text(viewModel.passwordMessage)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                        .padding(.leading, 55)

                    Text(viewModel.signUpMessage)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .fontWeight(.thin)

                    Button(action: {
                        viewModel.emptyFormatCheck(email: email, password: password, passwordCheck: passwordCheck, name: name)
                    }, label: {
                        Text("Sign In")
                            .font(.title2)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 118)
                    })
                    .background(Color.indigo)
                    .opacity(0.8)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding(.bottom, 30)
                    .padding(.top, 30)
                }
                
                Spacer()
                
                //물결 모양
                waveShape
                    .fill(Color.white)
                    .opacity(0.5)
                    .frame(height: 300)
                    .offset(y: -100)
            }
        }
    }
}

#Preview {
    SumchiveSignUpView()
}
