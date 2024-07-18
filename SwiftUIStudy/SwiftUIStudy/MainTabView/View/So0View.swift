//
//  So0View.swift
//  SwiftUIStudy
//
//  Created by Soom on 6/25/24.
//

import SwiftUI
import AVFoundation

struct Members: Identifiable {
    var id: UUID = UUID()
    var nick: String
    var name: String
    var message: String
}

struct So0View: View {
    let members: [Members] = [
        Members(nick: "Soom", name: "수은님", message: " 몬가 믿음직스러워여"),
        Members(nick: "So0", name: "소영", message: "은 내 이름\n"),
        Members(nick: "Lips", name: "원호님", message: " 리더 감사합니당"),
        Members(nick: "Sumchive", name: "수민님", message: " 또 같은조 돼서 조아요"),
        Members(nick: "ActIve", name: "문성님", message: " 열심히 해보자구욤"),
        Members(nick: "Marble", name: "승우님", message: " 저희 동갑이네용")
    ]
    let speechSynth = AVSpeechSynthesizer()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.indigo, .white]), startPoint: .bottom, endPoint: .top)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Label("So0's tab", systemImage: "swift")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    Section("Swift Study Group") {
                        LazyVGrid(columns: [.init(), .init()]) {
                            ForEach(members) { member in
                                GroupBox("🔆\(member.nick)") {
                                    let comMessage: String = "\(member.name + member.message)"
                                    Button(comMessage) {
                                        let utterance = AVSpeechUtterance(string: comMessage)
                                        speechSynth.speak(utterance)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    Section("Task") {
                        ScrollView() {
                            VStack(alignment:.leading) {
                                NavigationLink {
                                    
                                } label: {
                                    VStack {
                                        Text("1주차")
                                            .frame(maxWidth: .infinity)
                                        Text("화면 꾸미기")
                                            .font(.system(size: 12))
                                    }
                                        
                                }
                                .disabled(true)
                                .buttonStyle(.borderedProminent)
                                .tint(.white)
                                
                                NavigationLink {
                                    lottoView()
                                } label: {
                                    VStack {
                                        Text("2주차")
                                            .frame(maxWidth: .infinity)
                                        Text("로또 만들기")
                                            .font(.system(size: 12))
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.white)
                            }
                        }
                        .bold()
                        .foregroundStyle(.black)
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}

enum Grades: String {
    case firstGrade = "1등"
    case secondGrade = "2등"
    case thirdGrade = "3등"
    case forthGrade = "4등"
    case fifthGrade = "5등"
    case lose = "낙첨"
}

struct lottoView:View {
    @State var numbersArray: [Int] = []
    @State var autoArray = [Array<Int>]()
    @State var bonusNum: Int = 0 // 보너스 숫자
    @State var commonArray: [Int] = []
    @State var totalPrize: Int = 0
    @State var resultMessages: [String] = [String]()
    @State var grades: Set = Set<Int>()
    @State var isInit: Bool = true
    @State var prizes: [String:Int] = [Grades.firstGrade.rawValue:2386382421,
                                       Grades.secondGrade.rawValue:48077302,
                                       Grades.thirdGrade.rawValue:1404957,
                                       Grades.forthGrade.rawValue:50000,
                                       Grades.fifthGrade.rawValue:5000]
    
    var body: some View {
        VStack {
            Text("\(numbersArray.count != 0 ? "당첨번호" : "")")
                .font(.title)
                .bold()
            HStack {
                if isInit {
                    Text("순위별 금액")
                        .font(.title)
                        .bold()
                }
                if bonusNum != 0 {
                    ForEach(numbersArray, id: \.self) { num in
                        makeColoredCircle(num: num)
                    }
                    
                    Text("+")
                    makeColoredCircle(num: bonusNum)
                }
            }
            .padding()
            
            ZStack {
                Rectangle().fill(Color(UIColor.systemGray6))
                if isInit {
                    VStack {
                        ForEach(prizes.sorted(by: <), id:\.key) { prize in
                            ZStack {
                                Capsule()
                                    .fill(.blue)
                                    .frame(width: 100, height: 45)
                                VStack {
                                    Text(prize.key)
                                        .foregroundColor(.white)
                                        .bold()
                                }
                            }
                            Text("\(prize.value)원")
                                .foregroundColor(.secondary)
                                    .bold()
                        }
                        .padding(5)
                    }
                }
                
                VStack {
                    Text("\(numbersArray.count == 0 ? "" : "\(makeResultMessage())")")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.blue)
                    Text("\(totalPrize == 0 ? "" : "총 \(totalPrize)원 당첨")")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .bold()
                }
                .padding()
            }
            
            VStack {
                ForEach(autoArray, id: \.self) { array in
                    HStack {
                        let intAlpha: Int = autoArray.firstIndex(of: array)!
                        Text("\(String(format: "%C", intAlpha + 65))")
                            .frame(width: 40, height: 40)
                            .bold()
                            .font(.title3)
                            .foregroundStyle(.gray)
                        ForEach(array, id: \.self) { num in
                            makeColoredCircle(num: num, true)
                        }
                        Text("\(resultMessages[autoArray.firstIndex(of: array)!])")
                            .frame(width: 40, height: 40)
                            .bold()
                            .foregroundStyle(.gray)
                    }
                }
                .padding()
            }
            
            Button(action: {
                resetContent()
                var numbers: Set = Set<Int>()
                repeat {
                    numbers.insert(Int.random(in: 1...45))
                    if numbers.count == 7 { // 중복되지 않는 보너스 숫자를 위해
                        numbersArray = numbers.sorted()
                        bonusNum = numbersArray.last ?? 0
                        numbersArray.removeLast()
                    }
                } while numbers.count < 7
                
                autoArray.removeAll()
                for _ in 0...4 {
                    var autoNumbers: Set = Set<Int>()
                    repeat {
                        autoNumbers.insert(Int.random(in: 1...45))
                        if autoNumbers.count == 6 {
                            let sortedArray: Array = autoNumbers.sorted()
                            autoArray.append(sortedArray)
                        }
                    } while autoNumbers.count < 6
                }
                makeGrade()
            }, label: {
                Text("번호 추첨 시작")
                    .font(.title2)
            })
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Lotto")
        .navigationBarBackButtonHidden(true)
    }
    
    func makeColoredCircle(num: Int, _ isAuto: Bool = false) -> some View {
        let isContained: Bool = numbersArray.contains(num)
        let backgroundColor: Color = !isContained || !isAuto ? .clear : .gray
        var borderColor: Color = .clear
    
        switch num {
        case 1...9:
            borderColor = isAuto ? .clear : .red
        case 10...19:
            borderColor = isAuto ? .clear : .yellow
        case 20...29:
            borderColor = isAuto ? .clear : .green
        case 30...39:
            borderColor = isAuto ? .clear : .blue
        default:
            borderColor = isAuto ? .clear : .gray
        }
        
        let textColor: Color = backgroundColor == .clear ? .black : .white
        
        return Circle().stroke(borderColor, lineWidth: 5)
            .fill(backgroundColor)
            .frame(width: 40, height: 40)
            .overlay(
                Text("\(num)")
                    .frame(width: 40, height: 40)
                    .foregroundStyle(textColor)
                    .bold()
            )
    }
    
    func makeGrade() {
        if numbersArray.count == 6 {
            for i in 0..<autoArray.count {
                commonArray = autoArray[i].filter{numbersArray.contains($0)}
                switch commonArray.count {
                case 6:
                    totalPrize += prizes[Grades.firstGrade.rawValue] ?? 0
                    resultMessages.insert(Grades.firstGrade.rawValue, at: i)
                    grades.insert(1)
                case 5:
                    if autoArray[i].contains(bonusNum) {
                        totalPrize += prizes[Grades.secondGrade.rawValue] ?? 0
                        resultMessages.insert(Grades.secondGrade.rawValue, at: i)
                        grades.insert(2)
                    } else {
                        totalPrize += prizes[Grades.thirdGrade.rawValue] ?? 0
                        resultMessages.insert(Grades.thirdGrade.rawValue, at: i)
                        grades.insert(3)
                    }
                case 4:
                    totalPrize += prizes[Grades.forthGrade.rawValue] ?? 0
                    resultMessages.insert(Grades.forthGrade.rawValue, at: i)
                    grades.insert(4)
                case 3:
                    totalPrize += prizes[Grades.fifthGrade.rawValue] ?? 0
                    resultMessages.insert(Grades.fifthGrade.rawValue, at: i)
                    grades.insert(5)
                default :
                    resultMessages.insert(Grades.lose.rawValue, at: i)
                    grades.insert(0)
                }
            }
        }
    }
    
    func makeResultMessage() -> String {
        if grades.contains(1) {
            return "💰🎊🎉1등 축하합니다🎉🎊💰"
        } else if grades.contains(2) {
            return "🎊🎉2등 축하합니다🎉🎊"
        } else if grades.contains(3) {
            return "🎉3등 축하합니다🎉"
        } else if grades.contains(4) {
            return "4등 축하합니다!"
        } else if grades.contains(5) {
            return "5등 축하합니다"
        } else {
            return "아쉽게도 모두 낙첨입니다"
        }
    }
        
    func resetContent() {
        isInit = false
        bonusNum = 0
        totalPrize = 0
        grades.removeAll()
    }
}

#Preview {
    So0View()
//    lottoView()
}
