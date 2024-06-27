//
//  mCalcView.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/06/27.
//

import SwiftUI

struct mCalcView: View {
    @Environment(\.dismiss) private var dismiss
    @State var showNumber : String = "0"
    @State var beforeButtonIsNumber : Bool = true
    @State var savedNumber : Double = 0
    @State var number : Double = 0
    @State var selectedOp : String = ""
    
    let widthSize : CGFloat = UIScreen.main.bounds.height * 0.1
    let heightSize : CGFloat = UIScreen.main.bounds.width * 0.9
    
    var body: some View {
        VStack {
            Text(showNumber)
                .frame(width: heightSize, height: UIScreen.main.bounds.height * 0.2)
                .font(.system(size: 30))
                .multilineTextAlignment(.trailing)
            HStack(spacing:widthSize){
                numButton(7)
                numButton(8)
                numButton(9)
                opButton("plus")
            }.frame(width: heightSize, height: widthSize)
            HStack(spacing:widthSize) {
                numButton(4)
                numButton(5)
                numButton(6)
                opButton("minus")
            }.frame(width: heightSize, height: widthSize)
            HStack(spacing:widthSize) {
                numButton(1)
                numButton(2)
                numButton(3)
                opButton("multiply")
            }.frame(width: heightSize, height: widthSize)
            HStack(spacing:widthSize) {
                opButton("restart")
                numButton(0)
                opButton("equal")
                opButton("divide")
            }.frame(width: heightSize, height: widthSize)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("실습 목록")
                    }
                }
            }
        }
    }
}

extension mCalcView {
    private func update() {
        showNumber = number == ceil(number) ? String(format: "%.f", number) : String(number)
        savedNumber = number
        number = 0
    }
    
    private func calc(_ op : String) {
        if op == "restart" {
            beforeButtonIsNumber = false
            update()
            selectedOp = ""
        } else {
            if beforeButtonIsNumber{
                switch selectedOp {
                case "plus" :
                    number = savedNumber + number
                    update()
                    beforeButtonIsNumber = false
                case "minus":
                    number = savedNumber - number
                    update()
                    beforeButtonIsNumber = false
                case "multiply":
                    number = savedNumber * number
                    update()
                    beforeButtonIsNumber = false
                case "divide":
                    if number == 0 {
                        showNumber = "오류"
                        savedNumber = 0
                        number = 0
                        beforeButtonIsNumber = false
                    } else {
                        number = savedNumber / number
                        update()
                        beforeButtonIsNumber = false
                    }
                default :
                    update()
                    beforeButtonIsNumber = false
                }
            }
            selectedOp = op
        }
    }
    
    private func numButton(_ num : Int) -> some View {
        Button {
            number = beforeButtonIsNumber ? number * 10 + Double(num) : Double(num)
            showNumber = String(format: "%.f", number)
            beforeButtonIsNumber = true
        } label : {
            Text("\(num)")
        }
    }
    
    private func opButton(_ op : String) -> some View {
        Button {
            calc(op)
        } label : {
            Image(systemName: op)
        }
    }
}

#Preview {
    mCalcView()
}
