//
//  mPublicView.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/08/02.
//

import Foundation
import SwiftUI

let backColor: Color = Color(red: 81/255, green: 134/255, blue: 234/255)
let alertBackColor: Color = Color(red: 240/255, green: 240/255, blue: 240/255)

func backView() -> some View {
    VStack {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.92)
            .foregroundColor(.black)
            .opacity(0.4)
        Rectangle()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.15)
            .foregroundColor(.white)
    }
}

func alertView(_ title: String, _ content: String, _ btn : @escaping () -> some View) -> some View {
    RoundedRectangle(cornerRadius: 25)
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.25)
        .foregroundColor(alertBackColor)
        .overlay {
            VStack {
                Text(title)
                    .padding(.bottom, 30)
                Text(content)
                    .padding(.bottom, 30)
                Divider()
                btn()
            }
        }
}
