//
//  SoomVoiceRecodingView.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/8/24.
//

import SwiftUI
import AVFoundation


struct SoomVoiceRecordingView: View {
    @State private var isRecording: Bool = false
    @State private var isPlay: Bool = false
    @State var recorder: Recorder = Recorder()
    var body: some View {
        NavigationStack{
            ZStack{
                Circle()
                    .fill(isRecording ? .red.opacity(0.4) :  .gray.opacity(0.3))
                    .scaleEffect(2)
                    .animation(.easeInOut, value: isRecording)
                    .offset(y:250)
                VStack{
                    Spacer()
                    contentButton()
                    Spacer()
                        .frame(height: 30)
                    Text(isRecording ? "Recording . . ." : "Start Recoding!")
                        .font(.system(size: 20))
                        .foregroundStyle( isRecording ? .red.opacity(0.5) : .black.opacity(0.5))
                        .bold()
                    Spacer()
                        .frame(height: 100)
                    HStack(spacing: 10){
                        Text("Previous")
                            .frame(maxWidth: .infinity)
                            .padding(30)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white.gradient)
                            )
                        Text("New")
                            .frame(maxWidth: .infinity)
                            .padding(30)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.black.gradient)
                            )
                    }
                    .padding(.horizontal,30)
                    Spacer()
                        .frame(height: 50)
                }
            }
            .navigationTitle("New Recording")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Image(systemName: "bell.fill")
                        .resizable()
                        .frame(width: 15,height: 15)
                        .foregroundStyle(.black)
                }
            }
        }
    }
    @ViewBuilder
    func contentButton()-> some View{
        HStack{
            Button{
                isPlay.toggle()
                recorder.playRecording(isPlay: isPlay)
            }label: {
                Image(systemName: isPlay ? "stop" : "play")
                    .foregroundStyle( isPlay ? .red : .black)
                    .padding(10)
                    .background(
                        Circle()
                            .stroke()
                            .fill(.black)
                    )
            }
            Button{
                isRecording.toggle()
                recorder.startRecording(isRecord: isRecording)
            }label: {
                Image(systemName: isRecording ? "stop.fill" : "mic")
                
                    .resizable()
                    .frame(width: isRecording ? 35 : 25,height: 35)
                    .foregroundStyle(isRecording ? .red : .white)
                    .aspectRatio(contentMode: .fit)
                    .padding(30)
                    .background(
                        Circle()
                            .fill(.black)
                    )
                    .padding(.horizontal,40)
                    .animation(.smooth(duration: 0.1), value: isRecording)
                    .shadow(color: isRecording ? .red.opacity(0.4) : .blue.opacity(0.4), radius: 20)
            }
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 15,height: 15)
                .padding(10)
                .background(
                    Circle()
                        .stroke()
                        .fill(.black)
                )
        }
    }
}

#Preview {
    SoomVoiceRecordingView()
}
