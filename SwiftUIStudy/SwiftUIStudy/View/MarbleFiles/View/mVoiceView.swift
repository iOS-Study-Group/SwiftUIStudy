//
//  mVoiceView.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/09.
//

import SwiftUI

struct mVoiceView: View {
    @ObservedObject var audioRecorderManager = mAudioRecorderManager()
    @State var isPlaying : Bool = false
    @State var timer = Text("0:00")
    @State var scaleBigger  = 0.0
    @State var scaleMedium  = 0.0
    @State var scaleSmaller  = 0.0
    
    
    var backColor : Color = Color(red: 55/255, green: 52/255, blue: 58/255)
    var compColor : Color = Color(red: 230/255, green: 230/255, blue: 230/255)
    
    var body: some View {
        VStack {
            VStack {
                Text(isPlaying ? "Now recording" : "Push the button to record")
                    .font(.system(size: 24))
                    .foregroundStyle(compColor)
                ZStack {
                    VStack {
                        timer
                            .font(.system(size: 52))
                            .foregroundStyle(compColor)
                            .opacity(isPlaying ? 1 : 0)
                    }
                }
            }
            
            Button {
                clickButton()
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 180, height: 180, alignment: .center)
                        .scaleEffect(CGFloat(scaleBigger))
                        .foregroundColor(Color(.systemGray6))
                        .animation(isPlaying ? Animation.easeOut(duration: 1.5).repeatForever(autoreverses: true) : .default, value: scaleBigger)
            
                    Circle()
                        .frame(width: 150, height: 150, alignment: .center)
                        .scaleEffect(CGFloat(scaleMedium))
                        .foregroundColor(Color(.systemGray5))
                        .animation(isPlaying ? Animation.default
                            .repeatForever(autoreverses: true) : .default, value: scaleMedium)
                    
                    Circle()
                        .frame(width: 120, height: 120, alignment: .center)
                        .scaleEffect(CGFloat(scaleSmaller))
                        .foregroundColor(Color(.systemGray4))
                        .animation(isPlaying ? Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true) : .default, value: scaleSmaller)
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 75, height: 75)
                        .overlay {
                            Image(systemName: isPlaying ? "pause.fill" : "mic.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                }
            }
            
            Text("녹음 리스트")
                .font(.system(size: 26))
                .foregroundStyle(.white)
                .padding(.top, 40)
                .padding(.bottom, 30)
            
            /// 메모 리스트 뷰
            RecordingListView(audioRecorderManager: audioRecorderManager)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.9)
        .background(backColor)
        .ignoresSafeArea()
    }
}

// MARK: - 음성메모 리스트 뷰
private struct RecordingListView: View {
    @ObservedObject private var audioRecorderManager: mAudioRecorderManager
    
    fileprivate init(audioRecorderManager: mAudioRecorderManager) {
        self.audioRecorderManager = audioRecorderManager
    }
    
    fileprivate var body: some View {
        //        ZStack {
        //            RoundedRectangle(cornerRadius: 25)
        //                .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.3)
        //                .background(.white)
        //                .opacity(0.5)
        ScrollView {
            ForEach(audioRecorderManager.recordedFiles, id: \.self) { recordedFile in
                HStack {
                    Spacer()
                    Button {
                        if audioRecorderManager.isPlaying && (audioRecorderManager.audioPlayer?.url)! == recordedFile {
                            audioRecorderManager.isPaused
                            ? audioRecorderManager.resumePlaying()
                            : audioRecorderManager.pausePlaying()
                        } else {
                            audioRecorderManager.startPlaying(recordingURL: recordedFile)
                        }
                    } label :{
                        Text(recordedFile.lastPathComponent)
                            .foregroundColor(
                                audioRecorderManager.isPlaying && audioRecorderManager.audioPlayer?.url == recordedFile
                                ? (audioRecorderManager.isPaused ? .green : .red)
                                : .white
                            )
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        audioRecorderManager.eraseFile(recordedFile)
                    } label : {
                                Text("삭제")
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.white)
                                    .background(
                                        Rectangle()
                                            .fill(.red)
                                            .contentMargins(5)
                                            .frame(width: 35)
                                    )
                    }
                    Spacer()
                }
            }
        }.frame(height: UIScreen.main.bounds.height * 0.2)
        //            .background(.white)
        //        }
        //        .background(Color(red: 55/255, green: 52/255, blue: 58/255))
    }
}


extension mVoiceView {
    func clickButton() {
        if isPlaying { // 스탑
            audioRecorderManager.stopRecording()
            scaleBigger = 0.0
            scaleMedium = 0.0
            scaleSmaller = 0.0
            timer = Text("0:00")
                .font(.system(size: 52))
                .foregroundStyle(compColor)
        } else { // 재생
            audioRecorderManager.startRecording()
            scaleBigger = 1.2
            scaleMedium = 1.2
            scaleSmaller = 1.2
            timer = Text(Date().addingTimeInterval(0.0), style: .timer)
                .font(.system(size: 52))
                .foregroundStyle(compColor)
        }
        isPlaying.toggle()
    }
}

#Preview {
    mVoiceView()
}
