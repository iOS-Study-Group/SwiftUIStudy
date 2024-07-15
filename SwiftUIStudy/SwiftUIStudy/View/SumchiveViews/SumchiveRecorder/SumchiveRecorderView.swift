//
//  SumchiveRecorderView.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 7/8/24.
//


import SwiftUI

struct SumchiveRecorderView: View {
    @StateObject private var voiceRecorder = VoiceRecorder()
    
    var body: some View {
        TabView {
            
            // 녹음기 뷰
            RecordButtonView(voiceRecorder: voiceRecorder)
                .tabItem {
                    Label("Record", systemImage: "mic.fill")
                }
            
            // 녹음파일 리스트 뷰
            RecordListView(voiceRecorder: voiceRecorder)
                .tabItem {
                    Label("Files", systemImage: "list.bullet")
                }
        }
        .accentColor(.red)
        .font(.headline)
        .background(Color.white)
    }
    
    //탭 바 하얀색으로 고정
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}

// 녹음기 뷰
struct RecordButtonView: View {
    @ObservedObject var voiceRecorder: VoiceRecorder
    @State private var isRecording = false
    
    //record 텍스트
    @State private var showrecord = false
    
    //saved 텍스트
    @State private var showSaved = false
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.9)
                .edgesIgnoringSafeArea(.top)
            VStack {
                Button(action: {
                    // 녹음 종료하기
                    if isRecording {
                        //녹음종료
                        voiceRecorder.stopRecord()
                        //saved 텍스트 1초 나타나고 사라짐
                        showrecord = false
                        showSaved = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            showSaved = false
                        }
                    }
                    
                    //녹음 시작하기
                    else {
                        //녹음시작
                        voiceRecorder.startRecord()
                        //record...텍스트
                        showrecord = true
                    }
                    isRecording.toggle()
                }) {
                    //녹음 시작,종료 아이콘
                    Image(systemName: isRecording ? "stop.circle" : "mic.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding()
                        .foregroundColor(.red)
                }
                
                //녹음 종료 텍스트
                if showSaved {
                    Text("saved")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.light)
                }
                
                //녹음 시작 텍스트
                if showrecord {
                    Text("record.....")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.light)
                }
            }
            .padding()
        }
    }
    
}

// 녹음파일 리스트 뷰
struct RecordListView: View {
    @ObservedObject var voiceRecorder: VoiceRecorder
    @State private var isPlaying = false
    @State private var recordFile: URL?
    
    var body: some View {
//            녹음파일 아예 없을 때
            if voiceRecorder.recordFiles.isEmpty{
                Text("There is no file")
                    .font(.title)
                    .fontWeight(.bold)
            }
            //녹음파일 있을 때
            //녹음파일 리스트 보여주기
            else{
                List(voiceRecorder.recordFiles, id: \.self) { file in
                    HStack{
                        //녹음파일명
                        Text(file.lastPathComponent)
                        Divider()
                        //녹음 파일 재생 / 종료 버튼
                        Button(action: {
                            
                            //녹음 파일 종료하기
                            if isPlaying && recordFile == file {
                                //녹음파일 종료
                                voiceRecorder.stopPlay()
                                isPlaying = false
                                recordFile = nil
                            }
                            
                            //녹음 파일 재생하기
                            else {
                                voiceRecorder.startPlay(url: file)
                                isPlaying = true
                                recordFile = file
                            }
                        }){
                            //녹음파일 재생, 종료 아이콘
                            Image(systemName: isPlaying && recordFile == file ? "stop.circle" : "play.circle")
                        }
                        .padding()
                        Divider()
                        //녹음 파일 삭제하기
                        Button(action: {
                            if isPlaying && recordFile == file {
                                voiceRecorder.stopPlay()
                                isPlaying = false
                                recordFile = nil
                            }
                            voiceRecorder.deleteFile(url: file)
                        }) {
                            Image(systemName: "trash.fill")
                        }
                    }
                }
                .cornerRadius(8)
                .scrollContentBackground(.hidden)
                .background(Color.black.opacity(0.9))
            }
    }
}
#Preview {
    SumchiveRecorderView()
}

