//
//  SignUpView.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/31/24.
//

import SwiftUI

struct SoomCustomTextField: View {
    let textFieldColor = LinearGradient(colors: [.orange, .orange.opacity(0.5)], startPoint: .leading, endPoint: .trailing)
    let labelText: String
    let isSecure: Bool
    @Binding var text: String
    @Binding var isShow: Bool
    var body: some View {
        VStack{
            if isSecure{
                Text(labelText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                SecureField("",
                            text: $text,
                            prompt: Text("비밀번호를 입력해주세요")
                    .font(.headline)
                    .foregroundStyle(.black.opacity(0.7))
                )
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(.horizontal,20)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(textFieldColor,lineWidth: 1.5)
                        .fill(.white.opacity(0.5))
                )
            }else{
                Text(labelText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("",
                          text: $text,
                          prompt: Text("Email 형식을 입력해주세요")
                    .font(.headline)
                    .foregroundStyle(.black.opacity(0.7))
                )
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(.horizontal,20)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(textFieldColor,lineWidth: 1.5)
                        .fill(.white.opacity(0.5))
                )
            }
        }
    }
}

#Preview {
    SoomCustomTextField(labelText: "iD", isSecure: false, text: .constant(""), isShow: .constant(false))
}
