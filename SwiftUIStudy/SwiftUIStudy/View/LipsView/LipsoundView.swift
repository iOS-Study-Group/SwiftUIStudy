//
//  LipsoundView.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 7/8/24.
//

import SwiftUI
import AVFoundation
//리스트에 저장해서 누르면 재생도 가능하게 구현해보자!
struct LipsoundView: View {
    @StateObject var recorder = AudioRecorder()
    @State var recordTestText: String = "record?"
    @State private var fileName: String = ""
    @State private var showSaveAlert = false
    @State private var alertMessage = ""
    
    
    var body: some View {
        
        VStack{
            VStack{
                recordFileView(recorder: recorder)
            }
            
            //녹음버튼
            Button(action: {
                if recorder.isRecording {
                    // 녹음 중지 및 모달 표시
                    recorder.stopRecording()
                    showSaveAlert = true
                } else {
                    // 파일 이름이 있으면 녹음 시작
                    recorder.startRecording(FileName: fileName)
                }
            }) {
                Text(recorder.isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .background(recorder.isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Button(action: {
                recorder.removeAllFiles()
            }, label: {
                Text("초기화")
            })
            
            
        }
        .sheet(isPresented: $showSaveAlert) {
            SaveRecordingView(fileName: $fileName, onSave: {
                if !fileName.isEmpty {
                    recorder.saveRecording(withFileName: fileName)
                    showSaveAlert = false
                    recorder.loadRecordedFiles()
                } else {
                    alertMessage = "File name cannot be empty"
                    
                }
            })
        }
    }
}



#Preview {
    LipsoundView()
}
