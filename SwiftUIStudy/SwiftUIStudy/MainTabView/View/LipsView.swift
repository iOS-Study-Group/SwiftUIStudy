//
//  LipsView.swift
//  SwiftUIStudy
//
//  Created by Soom on 6/25/24.
//

import SwiftUI


struct LipsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: FirstView()) {
                    Text("FirstView로 이동")
                    
                }
                
                NavigationLink(destination: LipsLottoView()) {
                    Text("LottoView로 이동")
                    
                    
                }
                NavigationLink(destination: LipsoundView()) {
                    Text("LipsoundView로이동")
                }
                .navigationTitle("SuperMari5")
            }
        }
    }
}




struct FirstView: View {
    @State var insert: String = ""
    //입력한 텍스트 배열로 저장
    @State var newInsertTexts: [String] = []
    
    var body: some View {
        
        VStack {
            List {
                HStack {
                    TextField("텍스트를 입력하세요", text: $insert)
                    Button(action: {
                        //텍스트필드에 입력된 테스트가 비어지지 않았을때
                        if !insert.isEmpty{
                            newInsertTexts.append(insert)
                            insert = "" //텍스트 초기화해서 새로운 텍스트 입력할수 있게
                            
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                Section("") {
                    ForEach(newInsertTexts, id: \.self){ newInsertText in //newInsertText 배열에 저장된 각요소
                        Text(newInsertText)
                    }
                    
                }
            }
            .navigationTitle("탭뷰 꾸미기")
        }
        
    }
}

struct LipsLottoView: View {
    @State var winningNumbers: [Int] = []
    @State var bonusNumber: Int = 0
    @State var lotteryNumbers: [[Int]] = []
    
    var body: some View {
        VStack(spacing: 5){
            ZStack{
                Rectangle().fill(Color.white)
                    .frame(width: 300, height: 100)
                HStack{
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 35 , height: 26)
                    Text("Lotto").font(.largeTitle)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 35 , height: 26)
                }
            }
            
            ZStack{
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 350, height: 140)
                VStack{
                    Text("번호추첨")
                    HStack {
                        ForEach(winningNumbers, id: \.self) { number in
                            Circle()
                                .fill(getNumberColor(number: number))
                                .frame(width: 30 , height: 30)
                                .overlay(Text("\(number)").foregroundStyle(.white))
                            
                        }
                        if bonusNumber != 0 {
                            Text("✚")
                            Circle()
                                .fill(getNumberColor(number: bonusNumber))
                                .frame(width: 30, height: 30)
                                .overlay(Text("\(bonusNumber)").foregroundStyle(.white))
                            
                        }
                        
                        
                    }
                }
            } .padding(.bottom, 20)
            
            Button {
                let result = getWinNumbers()
                winningNumbers = result.sortWinNum
                bonusNumber = result.bonusNum
                
                lotteryNumbers = getLotteryNum()
            } label: {
                Text("번호추첨")
                    .foregroundColor(.black)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue)
                            .frame(width: 80, height: 40)
                    )
            }
            .padding(.bottom, 20)
            
            ZStack {
                Rectangle().fill(Color.gray)
                List {
                    ForEach(lotteryNumbers.indices, id: \.self) { index in
                        HStack {
                            ForEach(lotteryNumbers[index], id: \.self) { number in
                                Circle()
                                    .fill(getNumberColor(number: number))
                                    .frame(width: 30, height: 30)
                                    .overlay(Text("\(number)").foregroundStyle(.white))
                                
                            }
                            
                            Text(checkLottoResult(winningNumbers: winningNumbers, bonusNumber: bonusNumber, entry: lotteryNumbers[index]))
                        }
                    }
                }
            }
            Spacer()
        }
    }
    //번호 범위에 따른 번호 컬러
    func getNumberColor( number: Int) -> Color {
        switch number {
        case 1...9:
            return Color.red
        case 10...19:
            return Color.orange
        case 20...29:
            return Color.yellow
        case 30...39:
            return Color.green
        case 40...45:
            return Color.blue
        default:
            return Color.white
        }
    }
    
    //로또 당첨번호 함수
    func getWinNumbers() ->(sortWinNum: [Int], bonusNum: Int) {
        
        var winningSet: Set<Int> = []
        
        while winningSet.count < 7 {
            winningSet.insert(Int.random(in: 1...45))
        }
        //set에서 배열로
        var winningNubmer: [Int] = Array(winningSet)
        let bonusNum = winningNubmer.last ?? 0
        winningNubmer.removeLast()
        let sortWinNum: [Int] = winningNubmer.sorted()
        
        return (sortWinNum, bonusNum)
    }
    //추첨번호
    func getLotteryNum() -> [[Int]] {
        
        var lotteryNumArray: [Set<Int>] = []
        var lotteryNum: Set<Int>
        for _  in 1...5 {
            lotteryNum = []
            
            while lotteryNum.count < 6  {
                lotteryNum.insert(Int.random(in: 1...45))
                
            }
            lotteryNumArray.append(lotteryNum)
            
        }
        
        var sortedLotteryArray: [[Int]] = []
        for lta in lotteryNumArray {
            let sortedArray = lta.sorted()
            sortedLotteryArray.append(sortedArray)
        }
        
        return sortedLotteryArray
        
        
    }
    //등수체크
    func checkLottoResult(winningNumbers: [Int], bonusNumber: Int, entry: [Int]) -> String {
        let winningNumberSet = Set(winningNumbers)
        let numberOfCorrect = winningNumberSet.intersection(Set(entry)).count
        
        switch numberOfCorrect {
        case 6:
            return "1등!"
        case 5:
            return winningNumberSet.contains(bonusNumber) ? "2등" : "3등!"
        case 4:
            return "4등!"
        case 3:
            return "5등!"
        default:
            return "낙첨"
        }
    }
    
}


#Preview {
    MainTabView()
}
