//
//  LottoView.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 7/7/24.
//

import SwiftUI

struct LottoView: View {
    @State private var buttonClicked = false
    @State private var buttonClicked2 = false
    @State private var userLotto: [[Int]] = [
        makeUserLotto(),
        makeUserLotto(),
        makeUserLotto(),
        makeUserLotto(),
        makeUserLotto()
    ]
    
    static func makeUserLotto() -> [Int] {
        var randomLotto = Set<Int>()
        
        repeat {
            randomLotto.insert(Int.random(in: 1...45))
        } while randomLotto.count < 6
        
        return randomLotto.sorted()
    }
    
    static func makeAnswerLotto() -> [Int] {
        var randomLotto = Set<Int>()
        
        repeat {
            randomLotto.insert(Int.random(in: 1...45))
        } while randomLotto.count < 7
        
        return randomLotto.sorted()
    }
    
    @State private var answerLotto: [Int] = makeAnswerLotto()
    
    func checkRank(_ userNumbers: [Int], with answerNumbers: [Int]) -> String? {
        var count: Int = 0
        
        for number in userNumbers {
            if answerNumbers.dropLast().contains(number) {
                count += 1
            }
        }
        if count == 6 {
            return "1등"
        } else if count == 5 {
            if userNumbers.contains(answerNumbers[6]) {
                return "2등"
            } else {
                return "3등"
            }
        } else if count == 4 {
            return "4등"
        } else if count == 3 {
            return "5등"
        } else {
            return "꽝"
        }
    }
    
    var body: some View {
        VStack {
            Image("lotto")
                .resizable()
                .frame(width: 80, height: 80)
                .padding(10)
            Text("버튼을 눌러")
                .font(.system(size: 20, weight: .light, design: .default))
                .foregroundColor(.black)
                .padding(.bottom, 2)
            Text("행운의 번호를 뽑아보세요 !")
                .font(.system(size: 20, weight: .light, design: .default))
                .foregroundColor(.black)
                .padding(.bottom, 10)
            
            Button(action: {
                buttonClicked = true
                userLotto = [
                    LottoView.makeUserLotto(),
                    LottoView.makeUserLotto(),
                    LottoView.makeUserLotto(),
                    LottoView.makeUserLotto(),
                    LottoView.makeUserLotto()
                ]
                answerLotto = LottoView.makeAnswerLotto()
                buttonClicked2 = false
            }, label: {
                Text("번호뽑기")
                    .font(.system(size: 20, weight: .semibold, design: .default))
                    .foregroundColor(.white)
            })
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .padding(.bottom, 10)
            
            if buttonClicked {
                VStack {
                    ForEach(userLotto.indices, id: \.self) { index in
                        HStack {
                            ForEach(userLotto[index], id: \.self) { number in
                                Text("\(number)")
                                    .font(.title3)
                                    .padding(5)
                                    .background(Color.white)
                                    .cornerRadius(5)
                            }
                            if buttonClicked2 {
                                if let rank = checkRank(userLotto[index], with: answerLotto) {
                                    Text(rank)
                                        .font(.title2)
                                        .foregroundColor(.red)
                                        .padding(.leading, 5)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                    }
                    
                    Spacer()
                    Button(action: {
                        buttonClicked2 = true
                    }, label: {
                        Text("행운의 번호 확인하기")
                            .font(.system(size: 25, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    if buttonClicked2 {
                        HStack {
                            HStack {
                                ForEach(answerLotto.prefix(6), id: \.self) { number in
                                    Text("\(number)")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(5)
                                        .background(Color.white)
                                        .cornerRadius(50)
                                        .border(Color.blue)
                                }
                            }
                            .padding(5)
                            Image(systemName: "plus")
                            Text("\(answerLotto[6])")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(5)
                                .background(Color.blue)
                                .cornerRadius(5)
                            
                        }
                        .padding(.bottom,60)
                        Spacer()
                        
                    }
                }
            }
            
        }
    }
}

#Preview {
    LottoView()
}
