//
//  SoundRecord.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 7/11/24.
//

import AVFoundation

class AudioRecorder: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingSession: AVAudioSession!
    private var temporaryRecordingURL: URL?

    @Published var isRecording = false
    @Published var recordedFiles: [URL] = []
    init() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true) //오디오세션
        } catch {
            print("오디오 세션 에러")
        }
    }
    
    func startRecording(FileName fileName: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        temporaryRecordingURL = paths[0].appendingPathComponent("\(UUID().uuidString).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: temporaryRecordingURL!, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("레코딩 에러 ")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
    }
    
    func saveRecording(withFileName fileName: String) {
        guard let temporaryURL = temporaryRecordingURL else { return }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let destinationURL = paths[0].appendingPathComponent("\(fileName).m4a") // 저장할 파일 URL 생성
        
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL) // 기존 파일이 있으면 삭제
            }
            try FileManager.default.moveItem(at: temporaryURL, to: destinationURL) // 임시 파일을 새 파일로 이동
            print("\(fileName).m4a 로 저장함")
        } catch {
            print("저장 불가용")
        }
    }

    func playRecording(fileURL: URL) {
           do {
               audioPlayer = try AVAudioPlayer(contentsOf: fileURL) // AVAudioPlayer 인스턴스 생성
               audioPlayer?.play() // 녹음 파일이 있으면 재생
           } catch {
               print("재생불가용")
           }
       }
    // 저장된 녹음 파일을 로드하는 메서드
        func loadRecordedFiles() {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = paths[0]
            
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
                recordedFiles = fileURLs.filter { $0.pathExtension == "m4a" } // m4a 파일만 필터링하여 목록에 추가
            } catch {
                print("파일을 로드해오지 못하였습니다.")
            }
        }
    func removeAllFiles(){
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        do {
                 let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
                 let m4aFiles = fileURLs.filter { $0.pathExtension == "m4a" }
                 for fileURL in m4aFiles {
                     try FileManager.default.removeItem(at: fileURL)
                 }
                 recordedFiles.removeAll()
                 print("모든파일 삭제")
             } catch {
                 print("삭제가 불가능합니다ㅜㅜ")
             }
    }
    
//    func removeFile(fileURL: URL) {
//        let file = FileManager.default
//        
//        do {
//            try file.removeItem(at: url)
//            if let index = recordedFiles.firstIndex(of: url) {
//                recordedFiles.remove(at: index)
//            }
//        } catch {
//            print("삭제 불가! ")
//        }
//    }
 
    
}
