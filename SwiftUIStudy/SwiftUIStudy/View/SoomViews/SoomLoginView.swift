//
//  SoomLoginView.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/31/24.
//

import SwiftUI

struct SoomLoginView: View {
    @State var id: String = ""
    @State var pw: String = ""
    @State var isShow: Bool = false
    @State private var isOn: Bool = false
    @State private var isRegister: Bool = true
    @State private var isAuth: Bool = false
    @StateObject var viewModel = SoomSignUpViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                Image("Swiss")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    Text("로그인")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                    
                    SoomCustomTextField(labelText: "ID", isSecure: false, text: $id, isShow: $isShow)
                    
                    SoomCustomTextField(labelText: "PW", isSecure: true, text: $pw, isShow: .constant(false))
                    
                    SoomCustomButton(buttonLabel: "회원가입", buttonBackgroundColor: .gray.opacity(0.8), buttonForgroundColor: .white, buttonFont: .headline,  buttonWidth: 100,buttonHeight: 30){
                        isRegister = true
                    }
                    Spacer()
                    SoomCustomButton(buttonLabel: "로그인", buttonBackgroundColor: .brown.opacity(0.4), buttonForgroundColor: .white, buttonFont: .subheadline, buttonWidth: .infinity,buttonHeight: 50) {
                        Task{
                               await viewModel.signIn(email: id, password: pw)
                        }
                    }
                }
                .background(
                    Rectangle()
                        .fill(.black.opacity(0.3))
                        .frame(height: 400)
                        .padding(.horizontal, -20)
                )
                .padding(.horizontal,100)
                .onChange(of: viewModel.isLogin){ _, _ in
                    isAuth = viewModel.isLogin
                }
                .onChange(of: viewModel.isCreate){
                    self.isRegister = false
                }
            }
            .sheet(isPresented: $isRegister){
                SoomRegisterView()
                    .presentationDetents([.medium, .fraction(0.8)])
                    .environmentObject(viewModel)
            }
            .navigationDestination(isPresented:$isAuth)  {
                SoomPhotosView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct SoomRegisterView: View {
    @State var id: String = ""
    @State var pw: String = ""
    @State var isShow: Bool = true
    @EnvironmentObject var viewModel: SoomSignUpViewModel
    var body: some View {
        VStack{
            Text("회원가입")
                .font(.largeTitle)
                .padding(.vertical,50)
            SoomCustomTextField(labelText: "ID", isSecure: false, text: $id, isShow: $isShow)
            
            SoomCustomTextField(labelText: "PW", isSecure: true, text: $pw, isShow: .constant(false))
            Spacer()
            
            SoomCustomButton(buttonLabel: "회원가입", buttonBackgroundColor: .blue.opacity(0.4), buttonForgroundColor: .white, buttonFont: .subheadline, buttonWidth: .infinity, buttonHeight: 50) {
                Task{
                    await viewModel.registerCheck(email: id, password: pw)
                }
            }
        }
        .padding(.horizontal,20)
        .onChange(of: viewModel.isCreate){
            print(viewModel.isCreate)
           isShow = false
        }
    }
}

#Preview {
    SoomLoginView()
}
