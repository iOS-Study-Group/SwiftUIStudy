//
//  SignUpView.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/31/24.
//

import SwiftUI

struct SoomCustomTextField: View {
    let idColor = LinearGradient(colors: [.red, .green, .blue], startPoint: .leading, endPoint: .trailing)
    let labelText: String
    let isSecure: Bool
    @Binding var text: String
    @Binding var isShow: Bool
    var body: some View {
        VStack{
            if isSecure{
                Text(labelText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                SecureField("",
                          text: $text,
                          prompt: Text("아이디를 입력해주세요")
                    .font(.headline)
                )
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(.horizontal,20)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke()
                        .foregroundStyle(idColor)
                )
                .padding(.horizontal,20)
            }else{
                Text(labelText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                TextField("",
                          text: $text,
                          prompt: Text("아이디를 입력해주세요")
                    .font(.headline)
                )
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(.horizontal,20)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke()
                        .foregroundStyle(idColor)
                )
                .padding(.horizontal,20)
            }
        }
    }
}

#Preview {
    SoomCustomTextField(labelText: "iD", isSecure: false, text: .constant(""), isShow: .constant(false))
}
