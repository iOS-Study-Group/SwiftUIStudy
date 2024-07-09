//
//  mLottoView.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/09.
//

import SwiftUI

struct mLottoView : View{
    @Environment(\.dismiss) private var dismiss
    @State var winningNumbers : Set<Int> = []
    @State var myNumbers : [[Int]] = [[]]
    @State var isButtonClicked : Bool = false
    @State var bonusNum : Int?
    
    var body : some View {
        VStack(spacing:30){
            if isButtonClicked {
                Text("당첨 번호")
                    .font(.system(size: 30))
                HStack { // 로또 번호 보여질 줄
                    ForEach(Array(zip(0..<self.winningNumbers.count,Array(self.winningNumbers))), id:\.0) {index, number in
                        if index==6 {
                            Image(systemName: "plus")
                        }
                        lottoNumber(number)
                    }
                }
                
                Divider()
                ForEach(myNumbers, id:\.self) { numbers in
                    HStack {
                        ForEach(numbers, id:\.self) { number in
                            myNumber(number, winningNumbers.firstIndex(of: number) != nil)
                        }
                        Divider()
                        if winningNumbers.intersection(numbers).count == 6 {
                            if numbers.firstIndex(of: bonusNum!) != nil {
                                Text("2등")
                                    .font(.system(size: 20))
                            } else {
                                Text("1등")
                                    .font(.system(size: 20))
                            }
                        } else if (winningNumbers.intersection(numbers).count >= 3) {
                            
                            Text("\(8 - winningNumbers.intersection(numbers).count)등")
                                .font(.system(size: 20))
                        } else {
                            Text("낙첨")
                                .font(.system(size: 20))
                        }
                    }
                }
                Divider()
            }
            Button {
                createNewNumber()
            } label : {
                Text("로또 번호 생성")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue)
                        .frame(width: 160, height: 40)
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

extension mLottoView {
    func createNewNumber() {
        self.winningNumbers.removeAll()
        self.myNumbers.removeAll()
        self.isButtonClicked = true
        
        while self.winningNumbers.count < 7 {
            let number : Int = Int.random(in: 1...45)
            self.winningNumbers.insert(number)
        }
        bonusNum = Array(winningNumbers)[winningNumbers.count-1]
        
        for _ in 0..<5 {
            var numbers : Set<Int> = []
            while numbers.count < 6 {
                let num = Int.random(in: 1...45)
                numbers.insert(num)
            }
            self.myNumbers.append(Array(numbers))
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
                .font(.system(size: 20, weight: .bold))
        }
    }
    
    func myNumber(_ num : Int, _ isWinning : Bool) -> some View {
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
                .foregroundColor(isWinning ? ballColor : .white)
            Text(String(num))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(isWinning ? .white : .black)
        }
    }
}

#Preview {
    mLottoView()
}
