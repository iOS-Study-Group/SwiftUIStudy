//
//  LipsCreateAccountVeiw.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 8/2/24.
//

import SwiftUI

struct LipsCreateAccountVeiw: View {
    @StateObject private var viewModel = LipsCreateAccountViewModel()
    
    @State var userName: String = ""
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @State var checkUserPassword: String = ""
    @FocusState private var focusedField: Field?

    //패스워드 숫자 길이 제한 검증하기 위한 연산 프로퍼티
    private var isPasswordCount: Bool {
        userPassword.count <= 5
    }
    //이메일 형식 검증하기 위한 연산 프로퍼티(지피티야 고마웡)
    private var isEmailForm: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: userEmail)
    }
    @State var isSuccesCreateAccountAlert: Bool = false
    
   // @State var isPasswordUnCorrectError: Bool = true
    
    
    
    
    var body: some View {
        VStack(spacing: 30) {
            
            VStack{
                Text("SuperMario5 회원가입").font(.title)
                Text("이메일과 비밀번호를 입력하여 회원가입을 해보세요!").font(.callout)
            }
            
            VStack{
                Text("이름").padding(.top)
                    .padding(.leading,-165)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .opacity(userName.isEmpty ? (focusedField == .name ? 1 : 0) : 1) // 플레이스홀더처럼 보이게
                
                UnderlineTextFieldView(
                    text: $userName,
                    textFieldView: nameView,
                    placeholder: "이름을 입력해주세요" ,
                    isFocused: focusedField == .name
                )
                .focused($focusedField, equals: .name)
            }
                        
            VStack{
                Text("이메일").padding(.top)
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
                HStack{
                    Image(systemName: "exclamationmark.triangle.fill").font(.caption2)
                    Text("이메일 형식으로 입력해주세요!")
                        .font(.caption2)
                        
                        Spacer()
                }
                .padding(.leading)
                .foregroundColor(isEmailForm ? .clear : .red)
                .opacity(userEmail.isEmpty ? (focusedField == .email ? 1 : 0) : 1)
            }
            
         
            
            VStack{
                Text("패스워드").padding(.top)
                    .padding(.leading,-165)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .opacity(userPassword.isEmpty ? (focusedField == .password ? 1 : 0) : 1)
                
                UnderlineTextFieldView(
                    text: $userPassword,
                    textFieldView: passwordView,
                    placeholder: "패스워드",
                    isFocused: focusedField == .password
                )
                .focused($focusedField, equals: .password)
                
                HStack{
                    Image(systemName: "exclamationmark.triangle.fill").font(.caption2)
                    Text("패스워드는 6자리 이상 입력해주세용!")
                        .font(.caption2)
                        
                        Spacer()
                }
                .padding(.leading)
                .foregroundColor(isPasswordCount ? .red : .clear)
                .opacity(userPassword.isEmpty ? (focusedField == .password ? 1 : 0) : 1)
    
            }
            
            VStack{
                Text("패스워드 확인").padding(.top)
                    .padding(.leading,-165)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .opacity(checkUserPassword.isEmpty ? (focusedField == .checkingPassword ? 1 : 0) : 1)
                    
                
                UnderlineTextFieldView(
                    text: $checkUserPassword,
                    textFieldView: checkPasswordView,
                    placeholder: "패스워드를 다시 입력해주세요",
                    isFocused: focusedField == .checkingPassword
                )
                .focused($focusedField, equals: .checkingPassword)
                HStack{
                    
                    if checkUserPassword != userPassword {
                        Image(systemName: "exclamationmark.triangle.fill").font(.caption2)
                        Text("비밀번호가 서로 달라용!")
                            .font(.caption2)
                    }
                        Spacer()
                }
                .padding(.leading)
                .opacity(checkUserPassword.isEmpty ? (focusedField == .checkingPassword ? 1 : 0) : 1)
                //.foregroundColor(isPasswordUnCorrectError ? .red : .clear)
                .foregroundColor(.red)
    
            }
            Button(action: {
                Task {
                    await viewModel.signUp(email:userEmail , userName: userName ,password: userPassword)
                   
                    if viewModel.successMessage != nil {
                        isSuccesCreateAccountAlert = true
                    }
                }
                isSuccesCreateAccountAlert = true
            }, label: {
                Text("회원가입")
            }).disabled(!checkSignup() ? true : false)
                .alert(isPresented: $isSuccesCreateAccountAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text(String(viewModel.successMessage ?? "")), //알림뜨기전에 "" 지연 시간 추후 해결 필요
                        dismissButton: .default(Text("확인")) {
                            // Alert 닫기 후 successMessage 초기화
                            viewModel.successMessage = nil
                        }
                    )
                }



        }.padding()
        Spacer()
            
    }
    
    func checkSignup() -> Bool {
        if userName.isEmpty || userEmail.isEmpty || userPassword.isEmpty || checkUserPassword.isEmpty || checkUserPassword != userPassword{
            return false
        }
        
        return true
    }
    

    
}




extension LipsCreateAccountVeiw {
    
    private var nameView: some View {
        TextField("", text: $userName)
            .foregroundColor(.black)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .onTapGesture {
                focusedField = .name
            }
    }
    
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
    private var checkPasswordView: some View {
        SecureField("", text: $checkUserPassword)
            .foregroundColor(.black)
            .onTapGesture {
                focusedField = .checkingPassword
            }
        
    }
}


#Preview {
    LipsCreateAccountVeiw()
}
