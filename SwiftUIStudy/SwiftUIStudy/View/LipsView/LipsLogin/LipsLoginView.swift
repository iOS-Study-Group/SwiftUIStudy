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
    
    @State private var showCreateAccountPasge = false
    @State private var showFailLoginAlert = false
    @State private var showSuccessLoginView = false
    @StateObject private var viewModel = LipsCreateAccountViewModel()
    
    var body: some View {
        
        
        VStack {
            // Text("슈퍼마리5").font(.largeTitle)
            Image("SuperTitle")
                .resizable()
                .frame(width: 200, height: 100)
            
            VStack{
                
                Text("이메일")
                    .textFieldStyle(paddingTop: 50, paddingLeading: -165, isFocused: focusedField == .email)
                
                UnderlineTextFieldView(
                    text: $userEmail,
                    textFieldView: textView,
                    placeholder: "이메일" ,
                    isFocused: focusedField == .email
                )
                .focused($focusedField, equals: .email)
                
                Text("패스워드")
                    .textFieldStyle(paddingTop: 60, paddingLeading: -165, isFocused: focusedField == .password)
            }
            
            VStack{
                
                UnderlineTextFieldView(
                    text: $userPassword,
                    textFieldView: passwordView,
                    placeholder: "패스워드",
                    isFocused: focusedField == .password
                )
                .focused($focusedField, equals: .password)
                
                VStack{
                    
                    Button(action: {
                        Task{
                            await loginUser()
                        }
                    }, label: {
                        Text("로그인").font(.headline)
                    })
                    .frame(width: 280, height: 40)
                    .background(Color(red: 200 / 255, green: 46 / 255, blue: 90 / 255))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .alert(isPresented: $showFailLoginAlert) {
                        Alert(title: Text("알림"),
                              message: Text(viewModel.errorMessage ?? "로그인 실패"),
                              dismissButton: .default(Text("확인")){
                            viewModel.errorMessage = nil
                        })}
                    .fullScreenCover(isPresented: $showSuccessLoginView) {
                        LipsDataView()
                    }
                    
                    Button(action: {
                        showCreateAccountPasge = true
                    }, label: {
                        Text("회원가입").font(.footnote)
                    })
                }.padding(30)
                
                Spacer()
            }
        }
        .padding()
        .background(Color(red: 248 / 255, green: 249 / 255, blue: 250 / 255))
        .sheet(isPresented: $showCreateAccountPasge) {
            LipsCreateAccountVeiw()
        }
    }
    
    private func loginUser() async {
        await viewModel.login(email: userEmail, password: userPassword)
        
        if viewModel.errorMessage != nil {
            showFailLoginAlert = true
        } else if viewModel.successMessage != nil {
            showSuccessLoginView = true
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
