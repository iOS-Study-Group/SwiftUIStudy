//
//  LipsCreateAccountVeiw.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 8/2/24.
//

import SwiftUI

struct LipsCreateAccountVeiw: View {
    @StateObject private var viewModel = LipsCreateAccountViewModel()
    // @Environment(\.presentationMode) private var presentationMode
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
    
    @State private var isSuccessCreateAccountAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    // @State var isPasswordUnCorrectError: Bool = true
    
    
    
    
    var body: some View {
        VStack(spacing: 30) {
            
            VStack{
                //맘에안듬..
                Text("SuperMario5 회원가입")
                    .font(.title)
                    .bold()
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.pink, .blue , .yellow, .red, .green, .pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                    .padding(.bottom, 5)
                
                Text("이메일과 비밀번호를 입력하여 회원가입을 해보세요!")
                    .font(.callout)
                    .foregroundColor(.white) // 흰색 텍스트
                    .shadow(color: .black, radius: 1, x: 0, y: 1)
            }
            
            VStack{
                
                Text("이름").textFieldStyle(paddingTop: 20, paddingLeading: -165, isFocused: focusedField == .name)
                
                UnderlineTextFieldView(
                    text: $userName,
                    textFieldView: nameView,
                    placeholder: "이름을 입력해주세요" ,
                    isFocused: focusedField == .name
                )
                .focused($focusedField, equals: .name)
            }
            
            VStack{
                
                Text("이메일")
                    .textFieldStyle(paddingTop: 20, paddingLeading: -165, isFocused: focusedField == .email)
                
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
                
                Text("패스워드")
                    .textFieldStyle(paddingTop: 20, paddingLeading: -165, isFocused: focusedField == .password)
                
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
                
                Text("패스워드 확인")
                    .textFieldStyle(paddingTop: 20, paddingLeading: -165, isFocused: focusedField == .checkingPassword)
                
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
                    await signUpUser()
                }
            }, label: {
                Text("회원가입").font(.headline)
            }).disabled(!checkSignup() ? true : false)
                .frame(width: 280, height: 40)
                .background(checkSignup() ? Color(red: 200 / 255, green: 46 / 255, blue: 90 / 255):Color.gray)
                .cornerRadius(10)
                .foregroundColor(.white)
                .alert(isPresented: $isSuccessCreateAccountAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text(viewModel.successMessage ?? "\(userName)님 회원가입을 환영합니다"),
                        dismissButton: .default(Text("확인")) {
                            viewModel.successMessage = nil
                            // presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
                .alert(isPresented: $showErrorAlert) {
                    Alert(
                        title: Text("오류"),
                        message: Text(viewModel.errorMessage ?? "회원가입에 실패했습니다."),
                        dismissButton: .default(Text("확인")) {
                            viewModel.errorMessage = nil
                        }
                    )
                }
            
            
        }.padding()
        Spacer()
        
    }
    
    //현재 로그인이 성공하였을때 알림이 안뜸. 고민중.. 콘솔에 찍히는걸 보아 successMessage를 뷰모델에서 받아오는거 같긴한데.. 알림을 안띄어줌..
    private func signUpUser() async {
        await viewModel.signUp(email: userEmail, userName: userName, password: userPassword)
        print("Error Message: \(viewModel.errorMessage ?? "None")")
        print("Success Message: \(viewModel.successMessage ?? "None")")
        if viewModel.errorMessage != nil {
            showErrorAlert = true
        } else if viewModel.successMessage != nil {
            isSuccessCreateAccountAlert = true
        }
    }
    
    
    private func checkSignup() -> Bool {
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
