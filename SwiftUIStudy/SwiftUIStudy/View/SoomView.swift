//
//  SoomView.swift
//  SwiftUIStudy
//
//  Created by Soom on 6/25/24.
//

import SwiftUI

struct SoomView: View {
    let nickname: String = "Soom"
    let about: String = "Switf Study"
    @State private var todayLearn: [String] = ["LearningSwift/docs/01.md"]
    var body: some View {
        NavigationStack{
            ZStack{
                VStack(alignment: .leading){
                    Spacer()
                        .frame(height: 32)
                    HStack{
                        VStack(alignment: .leading){
                            Text(nickname)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundStyle(.white)
                                .italic()
                            Text(about)
                                .font(.caption)
                                .bold()
                                .foregroundStyle(.gray.opacity(0.8))
                        }
                        .padding()
                        Spacer()
                        Image("Swift")                            
                            .resizable()
                            .frame(width: 50,height: 50)
                            .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.indigo.gradient)
                    )
                    .padding(.horizontal,10)
                    Spacer()
                    List{
                        NavigationLink{
                            LottoView()
                        }label: {
                            Text("LottoView")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 50)
                                .foregroundStyle(.black)
                        }
                        
                        NavigationLink{
                            SoomVoiceRecordingView()
                        }label: {
                            Text("SoomVoiceRecordingView")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 50)
                                .foregroundStyle(.black)
                        }

                        
                        NavigationLink{
                            SoomLoginView()
                        }label: {
                            Text("SoomLoginView")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 50)
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SoomView()
}
