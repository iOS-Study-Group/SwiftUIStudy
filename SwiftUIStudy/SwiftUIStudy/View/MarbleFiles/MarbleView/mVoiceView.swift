//
//  mVoiceView.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/09.
//

import SwiftUI

struct mVoiceView: View {
    @State var isPlaying : Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Text("녹음 그래프?")
                Text("녹음 시간")
            }
            Button {
                isPlaying.toggle()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 75, height: 75)
//                        .background(.red)
                    Image(systemName: isPlaying ? "pause.fill" : "mic.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.9)
        .background(Color(red: 55/255, green: 52/255, blue: 58/255))
        .ignoresSafeArea()
    }
}

#Preview {
    mVoiceView()
}
