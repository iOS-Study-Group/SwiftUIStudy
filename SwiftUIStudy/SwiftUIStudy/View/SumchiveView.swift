import SwiftUI

struct SumchiveView: View {
    
    let study = ["SwiftUI","UIKit","iOS","APP", "GIT/GITHUB"]
    let member = ["Soom","So0","lips","Actlve", "Marble"]
    var body: some View {
        Spacer(minLength: 70)
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

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
                    .shadow(color: .indigo, radius: 5)
                    .padding(10)
                
                Image("SwiftLogo")
                    .resizable() // 사이즈 조정 가능
                    .frame(width: 100, height: 100)
                    .padding(20)
                            
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
