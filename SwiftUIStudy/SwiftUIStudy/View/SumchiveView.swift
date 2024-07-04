import SwiftUI

struct SumchiveView: View {
    
    let study = ["SwiftUI","UIKit","iOS","APP", "GIT/GITHUB"]
    let member = ["Soom","So0","lips","Actlve", "Marble"]
    // study, member 배열 선언
    
    var body: some View {
        NavigationView{
            // ZStack은 위로 쌓임(뷰 중첩)
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]),
                               startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                // 그라데이션 배경
                // 시작 색상(위) - 끝 색상(아래)
                // .edgesIgnoringSafeArea(.all) - 가득 채워짐, .top - 아래 공간 남음, .bottom - 위 공간 남음
                
                VStack(spacing:2) {
                    Spacer().frame(height: 90)
                    // sumchive 네모 박스가 너무 위에 있어서 추가함.
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 330, height: 70)
                        .cornerRadius(10)
                        .overlay(
                            Text("sumchive 📁")
                                .font(.system(size: 25, weight: .black, design: .default))
                                .foregroundColor(.white)
                        )
                    // 투명도 0.6, 검정색
                    // frame 사이즈
                    // 가장자리 둥글게
                    // overlay 사각형 위로 쌓음
                        .shadow(color: .indigo, radius: 5)
                    // 그림자(색상, 범위)
                        .padding(10)
                    
                    Image("SwiftLogo")
                        .resizable() // 사이즈 조정 가능(해상도가 화면을 초과하는 경우를 막음)
                        .frame(width: 80, height: 80)
                        .padding(10)
                    // 이미지는 Assets 파일에 추가하면 된다
                    
                    Text("iOS-STUDY-GROUP")
                        .font(.system(size: 30, weight: .light, design: .default))
                        .foregroundColor(.black)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 400, height: 600)
                        .cornerRadius(70)
                        .overlay(
                            VStack {
                                Text("Workspace")
                                    .font(.system(size: 25, weight: .black, design: .default))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 10)
                                
                                List {
                                    NavigationLink(destination: LottoView()) {
                                        VStack {
                                            Text("Lotto🎱 - 20240701")
                                                .font(.system(size: 20))
                                        }
                                    }
                                }
                                .listStyle(.plain)
                                .frame(height: 150)
                                
                                // 애플 로고 - study 배열 원소
                                // ForEach(study, id: \.self) { item in
                                //     HStack {
                                //         Image(systemName: "apple.logo")
                                //             .foregroundColor(.white)
                                //         Text(item)
                                //             .font(.system(size: 20, weight: .regular, design: .default))
                                //             .foregroundColor(.white)
                                //             .padding(7)
                                //     }
                                // }
                                
                                Text("MEMBER")
                                    .font(.system(size: 25, weight: .black, design: .default))
                                    .foregroundColor(.black)
                                    .padding(.bottom, 5)
                                    .padding(.top, 10)
                                
                                ForEach(member, id: \.self) { item in
                                    Text(item)
                                        .font(.system(size: 20, weight: .regular, design: .default))
                                        .foregroundColor(.black)
                                }
                                // member 배열 원소
                                Spacer()
                            }
                                .padding()
                        )
                        .shadow(color: .indigo, radius: 10)
                        .padding(30)
                }
                .padding(.top, 50)
            }
        }
    }
    
    // 로또 뷰
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
        
        //with가 뭘까유..
        
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
}
#Preview {
    NavigationView{
        SumchiveView()
    }
}
