//
//  MarbleView.swift
//  SwiftUIStudy
//
//  Created by Soom on 6/25/24.
//

import SwiftUI

struct MarbleView: View {
    @State var number : Int = 0
    @State var beforeButtonIsNumber : Bool = true
    @State var savedNumber : Int = 0
    @State var selectedOp : String = ""
    
    let widthSize : CGFloat = UIScreen.main.bounds.height * 0.1
    let heightSize : CGFloat = UIScreen.main.bounds.width * 0.9
    
    var body: some View {
        VStack {
            Text("\(number)")
                .frame(width: heightSize, height: UIScreen.main.bounds.height * 0.2)
                .font(.system(size: 30))
                .multilineTextAlignment(.trailing)
            HStack(spacing:widthSize){
                numButton(7)
                numButton(8)
                numButton(9)
                Image(systemName: "plus")
            }.frame(width: heightSize, height: widthSize)
            HStack(spacing:widthSize) {
                numButton(4)
                numButton(5)
                numButton(6)
                Image(systemName: "minus")
            }.frame(width: heightSize, height: widthSize)
            HStack(spacing:widthSize) {
                numButton(1)
                numButton(2)
                numButton(3)
                Image(systemName: "multiply")
            }.frame(width: heightSize, height: widthSize)
            HStack(spacing:widthSize) {
                Text("0")
                    .foregroundColor(.white)
                numButton(0)
                numButton(1)
                Image(systemName: "divide")
            }.frame(width: heightSize, height: widthSize)
        }
        Spacer()
    }
}

extension MarbleView {
    func calc(_ op : String) -> Int {
        var result : Int!
        
        
        
        return result
    }
    
    func numButton(_ num : Int) -> some View {
        Button {
            number = beforeButtonIsNumber ? number * 10 + num : num
            beforeButtonIsNumber = true
        } label : {
            Text("\(num)")
        }
    }
    
    func opButton(_ op : String) -> some View {
        Button {
            number = calc(op)
            savedNumber = number
            beforeButtonIsNumber = false
        } label : {
            Image(systemName: op)
        }
    }
}

#Preview {
    MarbleView()
}
