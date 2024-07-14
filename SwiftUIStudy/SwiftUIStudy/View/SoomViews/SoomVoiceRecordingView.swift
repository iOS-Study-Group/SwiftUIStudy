//
//  SoomVoiceRecodingView.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/8/24.
//
import SwiftUI


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
                    CustomSystemImageButton(systemName: "bell.fill", width: 15, height: 15, paddingSize: 0, foregroundColor: .black, isBackground: false){
                        
                    }
                }
            }
        }
    }
    @ViewBuilder
    func contentButton()-> some View{
        HStack{
            CustomSystemImageButton(systemName: isPlay ? "stop" : "play", width: 15 , height: 15, paddingSize: 10, foregroundColor: isPlay ? .red : .black, isBackground: true){
                isPlay.toggle()
                recorder.playRecording(isPlay: isPlay)
            }
            
            CustomSystemImageButton(systemName: isRecording ? "stop.fill" : "mic", width: isRecording ? 35 : 25, height: 35, paddingSize: 30, foregroundColor: isRecording ? .red : .white, isBackground: true ){
                isRecording.toggle()
                recorder.startRecording(isRecord: isRecording)
                    
            }
            .background(.black)
            .clipShape(Circle())
            .padding(.horizontal,40)
            .animation(.smooth(duration: 0.1), value: isRecording)
            .shadow(color: isRecording ? .red.opacity(0.4) : .blue.opacity(0.4), radius: 20)
            
            CustomSystemImageButton(systemName: "xmark", width: 15, height: 15, paddingSize: 10, foregroundColor: .black, isBackground: true){
            }
        }
    }
}

#Preview {
    SoomVoiceRecordingView()
}
