//
//  MarbleView.swift
//  SwiftUIStudy
//
//  Created by Soom on 6/25/24.
//

import SwiftUI

struct MarbleView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("실습 목록")
                    .font(.system(size: 24, weight: .bold))
                
                List {
                    NavigationLink {
                        mCalcView()
                    } label: {
                        VStack(alignment:.leading) {
                            Text("24.06.18")
                                .font(.system(size: 16))
                            Text("계산기")
                                .font(.system(size: 12))
                        }
                    }
                    NavigationLink {
                        lottoCreator()
                    } label: {
                        VStack(alignment:.leading) {
                            Text("24.07.02")
                                .font(.system(size: 16))
                            Text("로또 번호 생성기")
                                .font(.system(size: 12))
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

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

struct lottoCreator : View{
    @Environment(\.dismiss) private var dismiss
    @State var numbers : Set<Int> = []
    @State var isAnimating: Bool = false
    
    var body : some View {
        VStack(spacing:100){
            HStack { // 로또 번호 보여질 줄
                ForEach(Array(zip(0..<self.numbers.count,Array(self.numbers))), id:\.0) {index, number in
                    lottoNumber(number)
                        .animation(
                            .easeIn(duration: 1)
                            .delay(0.1 * Double(index)),
                            value: isAnimating
                        )
                }
            }
            Button {
                pickNewNumber()
            } label : {
                Text("로또 번호 생성")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue)
                        .frame(width: 160, height: 50)
                        .opacity(0.8))
            }
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

extension lottoCreator {
    func pickNewNumber() {
        self.numbers.removeAll()
        self.isAnimating.toggle()
        
        while self.numbers.count < 7 {
            var number : Int = Int.random(in: 1...45)
            self.numbers.insert(number)
        }
    }
    
    func lottoNumber(_ num : Int) -> some View {
        var ballColor : Color;
        switch num {
        case 1...10 :
            ballColor = .yellow
        case 11...20 :
            ballColor = .blue
        case 21...30 :
            ballColor = .red
        case 31...40 :
            ballColor = .gray
        default:
            ballColor = .green
        }
        return ZStack {
            Circle()
                .frame(width: 42, height: 42)
                .foregroundColor(ballColor)
            Circle()
                .frame(width: 28, height: 28)
                .foregroundColor(.white)
            Text(String(num))
                .font(.system(size: 16))
        }
    }
}

#Preview {
    MarbleView()
}
