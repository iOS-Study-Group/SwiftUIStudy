//
//  recordFileView.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 7/12/24.
//

import SwiftUI

struct recordFileView: View {

    @StateObject var recorder = AudioRecorder()
  
    var body: some View {
        VStack {
   
            List(recorder.recordedFiles, id: \.self) { url in
                HStack{
                    Text(url.lastPathComponent)
                    Spacer()
                    Button(action: {
                        recorder.playRecording(fileURL: url)
                    }, label: {
                        Text(Image(systemName: "play.fill"))
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 10)
                    Divider()
                   
                    Button {
//                        recorder.removeFile(url: url)
                    } label: {
                        Text("삭제")
                        
                    }.buttonStyle(PlainButtonStyle())

                }
            }
                .onAppear {
                    recorder.loadRecordedFiles()
                }
            
        }
    }
}

#Preview {
    recordFileView()
}
