//
//  RecordingView.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/10/24.
//

import SwiftUI
import AVFoundation



class StorageManager{
    init(){
       adioFileUpload()
    }
    func adioFileUpload(){
            
    }
}

class Recorder: NSObject{
    private var audioPlayer: AVAudioPlayer?
    private var audioSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder?
    
    let filename: URL
    
    override init(){
        // 마이크 권한 요청
        AVAudioApplication.requestRecordPermission { permissionStatus in
            print(permissionStatus)
        }
        audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        }catch{
            print(error.localizedDescription)
        }
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        filename = documentUrl.appendingPathComponent("SoomAudioFile.m4a")
        print(filename)
    }
    
    func startRecording(isRecord: Bool) {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
            audioRecorder?.delegate = self
            if isRecord{
                audioRecorder?.record()
                print("recording")
            }else{
                audioRecorder?.stop()
                print("recording Stop")
            }
        } catch {
            print("Failed to start recording")
        }
    }
    func playRecording(isPlay: Bool) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: filename)
            audioPlayer?.delegate = self
            if isPlay{
                audioPlayer?.play()
                print("play")
            }else{
                audioPlayer?.stop()
                print("stop")
            }
        } catch {
            print("Failed to play recording")
        }
    }
    
   
    // 녹음을 파일을 저장하기 위한 디렉토리 생성, 파일 생성
    func createAudioFolder()-> URL{
        let fileManager = FileManager.default
        // urls를 사용해서 요청하는 도메인에서 지정된 디렉토리에 대한 url를 가지고 올 수 있다.
        let documentUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryPathUrl = documentUrl.appendingPathComponent("SoomAudioFileFolder")
        let directoryPathString = directoryPathUrl.path()
        do{
            if !fileManager.fileExists(atPath: directoryPathString){ //  디렉토리가 존재하지 않으면 디렉토리 생성
                try fileManager.createDirectory(atPath: directoryPathString, withIntermediateDirectories: false, attributes: nil)
            }
        }catch{
            print(error.localizedDescription)
        }
        return directoryPathUrl
    }
    func stopPlaying() {
        audioPlayer?.stop()
    }
    func stopRecording(){
        audioRecorder?.stop()
    }
}

extension Recorder: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    }
}
