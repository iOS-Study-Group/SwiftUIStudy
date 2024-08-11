//
//  SoomCustomButton.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/31/24.
//

import SwiftUI

struct SoomCustomButton: View {
    let buttonLabel: String
    let buttonBackgroundColor: Color
    let buttonForgroundColor: Color
    let buttonFont: Font
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    let action: () -> Void
    var body: some View {
        Button{
            action()
        }label: {
            Text(buttonLabel)
                .frame(maxWidth: buttonWidth)
                .frame(height: buttonHeight)
                .font(buttonFont)
                .foregroundStyle(buttonForgroundColor)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(buttonBackgroundColor)
                )
                .padding(.horizontal,20)
        }
    }
}

#Preview {
    SoomCustomButton(buttonLabel: "버튼 입니당", buttonBackgroundColor: .black, buttonForgroundColor: .white, buttonFont: .footnote, buttonWidth: .infinity, buttonHeight: 50){
       print("Button!")
    }
}
