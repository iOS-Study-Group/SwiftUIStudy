
//
//  SumchiveLoginView.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 8/1/24.
//

import SwiftUI

//로그인 뷰

struct SumchiveSignInView: View {
    @ObservedObject private var viewModel: SignInModel = SignInModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    let waveShape = WaveShape()
    
    var body: some View {
        NavigationStack {
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
                        
                        Text("Login")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                            .padding(.bottom, 30)
                        
                        //이메일 입력
                        VStack(spacing: 10) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                                TextField("Email", text: $email)
                            }
                            .padding(8)
                            .background(.thinMaterial)
                            .cornerRadius(12)
                            .frame(width: 300)
                            .shadow(radius: 10)
                            
                            HStack {
                                Text(viewModel.emailMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .fontWeight(.light)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.leading, 55)
                        }
                        
                        //비밀번호 입력
                        VStack(spacing: 10) {
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                SecureField("Password", text: $password)
                            }
                            .padding(8)
                            .background(.thinMaterial)
                            .cornerRadius(12)
                            .frame(width: 300)
                            .shadow(radius: 10)
                            
                            HStack {
                                Text(viewModel.passwordMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .fontWeight(.light)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.leading, 55)
                        }
                        
                        //이메일, 비밀번호 일치하지 않을 때 알려주기
                        Text(viewModel.signInMessage)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        
                        //로그인버튼
                        Button(action: {
                            viewModel.emptyFormatCheck(email: email, password: password)
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
                        
                        //이메일, 비번 없는 경우 회원가입창으로 이동
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.black)
                                .padding(.leading, 10)
                            
                            NavigationLink(destination: SumchiveSignUpView()) {
                                Text("Sign Up")
                                    .foregroundColor(.blue)
                            }
                        }
                        .font(.headline)
                        .fontWeight(.thin)
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
            .navigationDestination(isPresented: $viewModel.isSignIn) {
                //로그인 성공하면 5주차 뷰로 이동
                MainView()
            }
        }
    }
}

#Preview {
    SumchiveSignInView()
}

