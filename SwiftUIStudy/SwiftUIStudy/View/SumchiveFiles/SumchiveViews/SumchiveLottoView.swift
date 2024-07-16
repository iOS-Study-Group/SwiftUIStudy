//
//  SumchiveLottoView.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 7/8/24.
//

import SwiftUI

struct SumchiveLottoView: View {
    @State private var buttonClicked = false
    @State private var buttonClicked2 = false
    @State private var userLotto: [[Int]] = [
        LottoModel.makeUserLotto(),
        LottoModel.makeUserLotto(),
        LottoModel.makeUserLotto(),
        LottoModel.makeUserLotto(),
        LottoModel.makeUserLotto()
    ]
    
    @State private var answerLotto: [Int] = LottoModel.makeAnswerLotto()
    
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
                    LottoModel.makeUserLotto(),
                    LottoModel.makeUserLotto(),
                    LottoModel.makeUserLotto(),
                    LottoModel.makeUserLotto(),
                    LottoModel.makeUserLotto()
                ]
                answerLotto = LottoModel.makeAnswerLotto()
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
                                if let rank = LottoModel.checkRank(userLotto[index], with: answerLotto) {
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
    SumchiveLottoView()
}
