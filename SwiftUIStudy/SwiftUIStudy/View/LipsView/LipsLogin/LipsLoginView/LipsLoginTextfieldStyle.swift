//
//  LipsLoginTextfieldStyle.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 8/4/24.
//

import SwiftUI


struct TextFieldStyle: ViewModifier {
    var paddingTop: CGFloat
    var paddingLeading: CGFloat
    var isFocused: Bool

    func body(content: Content) -> some View {
        content
            .padding(.top, paddingTop)
            .padding(.leading, paddingLeading)
            .font(.caption2)
            .foregroundColor(.gray)
            .opacity(isFocused ? 1 : 0)
            .animation(.easeInOut, value: isFocused)
    }
}

extension View {
    func textFieldStyle(paddingTop: CGFloat, paddingLeading: CGFloat, isFocused: Bool) -> some View {
        self.modifier(TextFieldStyle(paddingTop: paddingTop, paddingLeading: paddingLeading, isFocused: isFocused))
    }
}

struct PasswordStyle: ViewModifier {
    var paddingTop: CGFloat
    var isFocused: Bool

    func body(content: Content) -> some View {
        content
            .padding(.top, paddingTop)
            .font(.caption2)
            .foregroundColor(.gray)
            .opacity(isFocused ? 1 : 0)
    }
}

extension View {
    func passwordStyle(paddingTop: CGFloat, isFocused: Bool) -> some View {
        self.modifier(PasswordStyle(paddingTop: paddingTop, isFocused: isFocused))
    }
}
