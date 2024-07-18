//
//  LottoView.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/2/24.
//

import SwiftUI


struct LottoView: View {
    @State private var lottoNumbers: Set<Int> = []
    @State private var arrayLottoNumbers: [Int] = []
    @State private var isToggleLotto: Bool = false
    @State private var lottoMessage: String = "Lotto"
    @State private var isAnimation: Bool = false
    let fontGradient: LinearGradient = LinearGradient(colors: [Color.red,Color.orange, Color.yellow,Color.green, Color.red.opacity(0.6)], startPoint: .leading, endPoint: .trailing)
    var body: some View {
        ZStack{
            Color.gray.opacity(0.3).ignoresSafeArea()
            VStack{
                lottoView()
                    .frame(height: 300)
                Spacer()
                Button{
                    lottoNumbers.removeAll()
                    arrayLottoNumbers.removeAll()
                    isAnimation.toggle()
                    isToggleLotto.toggle()
                    createLotto()
                }label: {
                    Text("뽑기")
                        .font(.callout)
                        .foregroundStyle(.white)
                        .padding(15)
                        .background(
                            Circle()
                                .fill(.green.gradient)
                        )
                }
                .padding(.vertical,10)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal,10)
        }
    }
    @ViewBuilder
    func lottoView()-> some View{
        VStack{
            Text("LOTTO")
                .font(.system(size: 80))
                .italic()
                .foregroundStyle(fontGradient)
                .bold()
            if arrayLottoNumbers.isEmpty{
            }else{
                HStack(spacing: -10){
                    ForEach(arrayLottoNumbers.indices){ lottoIndex in
                        Text("\(arrayLottoNumbers[lottoIndex])")
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .background(
                                Circle()
                                    .fill(.blue.gradient)
                                    .shadow(radius: 1)
                                    .padding(10)
                            )
                            .frame(maxWidth: .infinity)
                            .scaleEffect(isAnimation ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5), value: isAnimation)
                    }
                }
            }
        }
    }
    func createLotto(){
        while lottoNumbers.count <= 5{
            lottoNumbers.insert(Int.random(in: 1...45))
        }
        arrayLottoNumbers = Array(lottoNumbers)
    }
}

#Preview {
    LottoView()
}
