import SwiftUI

struct SumchiveView: View {
    
    let study = ["SwiftUI","UIKit","iOS","APP", "GIT/GITHUB"]
    let member = ["Soom","So0","lips","Actlve", "Marble"]
    //study, member 배열 선언
    
    var body: some View {
        Spacer(minLength: 70)
        //위에 여유 공간, 최소 여백 70 보장한다..
        
        //ZStack은 위로 쌓임(뷰 중첩)
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            //그라데이션 배경
            //시작 색상(위)- 끝 색상(아래)
            //.edgesIgnoringSafeArea(.all) - 가득 채워짐, .top - 아래 공간 남음, .bottom - 위 공간 남음
            VStack {
                
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
                //frame 사이즈
                //가장자리 둥글게
                //overlay 사각형 위로 쌓음
                
                    .shadow(color: .indigo, radius: 5)
                    //그림자(색상, 범위)
                
                    .padding(10)
                
                Image("SwiftLogo")
                    .resizable() // 사이즈 조정 가능(해상도가 화면을 초과하는 경우를 막음)
                    .frame(width: 100, height: 100)
                    .padding(20)
                //이미지는 Assets 파일에 추가하면된다
                            
                Text("iOS-STUDY-GROUP")
                    .font(.system(size: 30, weight: .light, design: .default))
                    .foregroundColor(.black)
                
                Spacer()
                
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 400, height: 545)
                    .cornerRadius(70)
                    .overlay(
                        VStack {
                            Text("Learn About · · ·  ")
                                .font(.system(size: 30, weight: .black, design: .default))
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                            
                            ForEach(study, id: \.self) { item in
                                HStack{
                                    Image(systemName: "apple.logo")
                                        .foregroundColor(.white)
                                    Text(item)
                                        .font(.system(size: 25, weight: .regular, design: .default))
                                        .foregroundColor(.white)
                                        .padding(7)
                                }
                            }
                            
                            //애플로고-study 배열 원소
                            
                            Text("MEMBER")
                                .font(.system(size: 30, weight: .black, design: .default))
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
                    .padding(10)
            }
        }
    }
}

#Preview {
    SumchiveView()
}
