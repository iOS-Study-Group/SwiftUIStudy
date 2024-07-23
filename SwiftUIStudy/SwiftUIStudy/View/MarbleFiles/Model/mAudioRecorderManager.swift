//
//  AudioRecorderManager.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/09.
//

import Foundation
import AVFoundation
import FirebaseCore
import FirebaseStorage

class mAudioRecorderManager : NSObject, ObservableObject, AVAudioPlayerDelegate {
    var audioRecorder : AVAudioRecorder!
    @Published var isRecording = false
    
    /// 음성메모 재생 관련 프로퍼티
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var isPaused = false
    let storage = Storage.storage()
    
    /// 음성메모된 데이터
    @Published var recordedFiles = [URL]()
    
    func startRecording() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("recording-\(Date().timeIntervalSince1970).m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            self.isRecording = true
        } catch {
            print("녹음 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        self.recordedFiles.append(self.audioRecorder!.url)
        self.isRecording = false
        uploadRecordFile(self.audioRecorder!.url)
    }
    
    func uploadRecordFile(_ file : URL) {
        // gs://voiceproject-47036.appspot.com/marble/ 경로에 recording-\(Date().timeIntervalSince1970).m4a 파일로 저장됨
        let storageRef : StorageReference = self.storage.reference(forURL: "gs://voiceproject-47036.appspot.com/marble/recording-\(Date().timeIntervalSince1970).m4a")
        
        let uploadTask = storageRef.putFile(from: file, metadata: nil) { metadata, error in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension mAudioRecorderManager {
    func startPlaying(recordingURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            self.isPlaying = true
            self.isPaused = false
        } catch {
            print("재생 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        self.isPlaying = false
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        self.isPaused = true
    }
    
    func resumePlaying() {
        audioPlayer?.play()
        self.isPaused = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.isPaused = false
    }
    
    func eraseFile(_ url : URL) {
        guard let index = recordedFiles.firstIndex(of: url) else {
            return
        }
        recordedFiles.remove(at: index)
    }
    
}
