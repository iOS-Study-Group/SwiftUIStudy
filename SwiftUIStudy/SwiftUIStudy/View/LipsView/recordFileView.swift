//
//  recordFileView.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 7/12/24.
//

import SwiftUI

struct recordFileView: View {
//    @State private var fileURLs: [URL] = []
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
