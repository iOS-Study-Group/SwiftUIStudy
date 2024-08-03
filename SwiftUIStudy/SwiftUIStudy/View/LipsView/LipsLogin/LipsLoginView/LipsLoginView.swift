//
//  LipsLoginView.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 8/1/24.
//

import SwiftUI

enum Field{
    case email
    case password
    case checkingPassword
    case name
    
}
struct LipsLoginView: View {
    
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @FocusState private var focusedField: Field?
  
    @State private var showSaveAlert = false
    @StateObject private var viewModel = LipsCreateAccountViewModel()
    
    var body: some View {
        
        
        VStack {
           // Text("슈퍼마리5").font(.largeTitle)
            Image("SuperTitle")
                .resizable()
                .frame(width: 200, height: 100)
            
            VStack{
                
                Text("이메일").padding(.top, 50)
                    .padding(.leading,-165)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .opacity(userEmail.isEmpty ? (focusedField == .email ? 1 : 0) : 1)
                
                
                UnderlineTextFieldView(
                    text: $userEmail,
                    textFieldView: textView,
                    placeholder: "이메일" ,
                    isFocused: focusedField == .email
                )
                .focused($focusedField, equals: .email)
                
                Text("패스워드").padding(.top, 60)
                    .padding(.leading,-165)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .opacity(userPassword.isEmpty ? (focusedField == .password ? 1 : 0) : 1) 
            }
            VStack{
                UnderlineTextFieldView(
                    text: $userPassword,
                    textFieldView: passwordView,
                    placeholder: "Password",
                    isFocused: focusedField == .password
                )
                .focused($focusedField, equals: .password)
                VStack{
                    Button(action: {
                        Task{
                            await viewModel.login(email: userEmail , password: userPassword)
                        }
                    }, label: {
                        Text("로그인").font(.headline)
                        
                    })
                    
                    .frame(width: 280, height: 40)
                    .background(Color(red: 200 / 255, green: 46 / 255, blue: 90 / 255))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    
                    Button(action: {
                        showSaveAlert = true
                    }, label: {
                        Text("회원가입")
                    })
                }.padding(23)
                
                Spacer()
            }
        }
        .padding()
        .background(Color(red: 248 / 255, green: 249 / 255, blue: 250 / 255))
        .sheet(isPresented: $showSaveAlert) {
               LipsCreateAccountVeiw()
           }
    }
}


extension LipsLoginView {
    
    private var textView: some View {
        TextField("", text: $userEmail)
            .foregroundColor(.black)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .onTapGesture {
                focusedField = .email
            }
    }
    
    private var passwordView: some View {
        SecureField("", text: $userPassword)
            .foregroundColor(.black)
            .onTapGesture {
                focusedField = .password
            }
            
    }
}






#Preview {
    LipsLoginView()
}
