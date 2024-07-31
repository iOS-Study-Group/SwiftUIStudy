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
    var body: some View {
        VStack{
            Spacer()
            Text("Login Page")
                .font(.largeTitle)
            
            SoomCustomTextField(labelText: "ID", isSecure: false, text: $id, isShow: $isShow)
            
            SoomCustomTextField(labelText: "PW", isSecure: true, text: $pw, isShow: .constant(false))
            
            SoomCustomButton(buttonLabel: "회원가입", buttonBackgroundColor: .gray.opacity(0.4), buttonForgroundColor: .white, buttonFont: .subheadline,  buttonWidth: 100,buttonHeight: 30){
                // login  action
            }
            SoomCustomButton(buttonLabel: "로그인", buttonBackgroundColor: .brown.opacity(0.4), buttonForgroundColor: .white, buttonFont: .subheadline, buttonWidth: .infinity,buttonHeight: 50) {
                // login  action
            }
            .frame(height: 300, alignment: .bottom)
        }
    }
}

#Preview {
    SoomLoginView()
}
