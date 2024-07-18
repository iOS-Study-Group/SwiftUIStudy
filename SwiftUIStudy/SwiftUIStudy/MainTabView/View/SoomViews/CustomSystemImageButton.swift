//
//  CustomSystemImageButton.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/14/24.
//

import SwiftUI

struct CustomSystemImageButton: View {
    let systemName: String
    let (width, height) : (CGFloat,CGFloat)
    let paddingSize: CGFloat
    let foregroundColor: Color
    let isBackground: Bool

    let action: ()->()
    
    var body: some View {
        VStack{
            Button{
               action()
            }label: {
                Image(systemName: systemName)
                    .resizable()
                    .frame(width: width, height: height)
                    .foregroundStyle(foregroundColor)
                    .aspectRatio(contentMode: .fit)
                    .padding(paddingSize)
                    .overlay{
                        if isBackground{
                            Circle()
                                .stroke()
                                .fill(.black)
                        }
                    }
            }
        }
    }
}

#Preview {
    CustomSystemImageButton(systemName: "play", width: 35, height: 35, paddingSize: 30, foregroundColor: .black, isBackground: true){
        
        
    }
}
