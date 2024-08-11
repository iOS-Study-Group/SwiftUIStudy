//
//  TextFieldModifier.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/31.
//

import Foundation
import SwiftUI

struct textFieldModifier: ViewModifier {
    
    var width: CGFloat
    var height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16))
            .padding()
            .textInputAutocapitalization(.never) // 처음 문자 자동으로 대문자로 바꿔주는 기능 막기
            .frame(width: width, height: height)
            .background {
                RoundedRectangle(cornerRadius: 7)
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .frame(width: width, height: height)
            }
    }
}
