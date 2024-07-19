//
//  SRecordView.swift
//  SwiftUIStudy
//
//  Created by 이소영 on 7/11/24.
//

import SwiftUI

struct SRecordView: View {
    @StateObject var audioRecorderManager = AudioRecorderManager()
    @State var scale: CGFloat = 1.0
    @State var isAnimate: Bool = false

    var body: some View {
        VStack {
            List {
                ForEach(audioRecorderManager.recordedFiles, id: \.self) { recordedFile in
                    Button(action: {
                        if audioRecorderManager.isPlaying {
                            audioRecorderManager.stopPlaying()
                        } else {
                            audioRecorderManager.startPlaying(recordedFile: recordedFile)
                        }
                    }, label: {
                        Text(recordedFile.lastPathComponent).foregroundStyle(audioRecorderManager.isPlaying && audioRecorderManager.audioPlayer?.url == recordedFile ? .red : .black)
                    })
                    .deleteDisabled(audioRecorderManager.isRecording)
                    
                }
                .onDelete(perform: { indexSet in
                    audioRecorderManager.recordedFiles.remove(atOffsets: indexSet)
                    audioRecorderManager.removeRecordedFile()
                })
            }
            .disabled(audioRecorderManager.isRecording)
            
            Text(String(format: "%02d:%02d:%02d", audioRecorderManager.hours, audioRecorderManager.minutes, audioRecorderManager.sec))
                .font(.largeTitle)
                .fontWeight(.ultraLight)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(audioRecorderManager.audioLevels, id: \.self) { level in
                        Capsule()
                            .frame(width: 2, height: level)
                            .foregroundStyle(Color(.systemGray4))
                    }
                }
                .frame(height: 160)
            }
            .defaultScrollAnchor(.trailing)
            .statusBar(hidden: true)
            .padding()
                       
            ZStack {
                Circle()
                    .frame(width: 90, height: 90, alignment: .center)
                    .scaleEffect(scale)
                    .foregroundStyle(Color(.systemGray3))
                    .animation(isAnimate ? .easeInOut(duration: 0.5).repeatForever(autoreverses: true) : .default, value: scale)
                
                Circle()
                    .frame(width: 90, height: 90)
                    .foregroundStyle(Color(.systemGray6))
                
                Button {
                    if audioRecorderManager.isPlaying {
                        audioRecorderManager.stopPlaying()
                    }
                    audioRecorderManager.isRecording ? audioRecorderManager.stopRecording() : audioRecorderManager.startRecording()
                    isAnimate = isAnimate ? false : true
                    scale = isAnimate ? 1.1 : 1.0
                } label: {
                    Image(systemName: isAnimate ? "mic.fill" : "mic")
                    
                }
                .frame(width: 70, height: 70)
                .background(.red)
                .cornerRadius(50)
                .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    SRecordView()
}
