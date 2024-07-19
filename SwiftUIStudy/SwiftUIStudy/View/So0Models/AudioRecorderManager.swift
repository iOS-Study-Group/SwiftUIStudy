//
//  AudioRecorderManager.swift
//  SwiftUIStudy
//
//  Created by 이소영 on 7/19/24.
//

import Foundation
import AVFoundation

class AudioRecorderManager: NSObject, ObservableObject {
    @Published var isPlaying = false
    @Published var isRecording = false
    @Published var audioLevels: [CGFloat] = []
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    var recordTimer: Timer?
    var timerString: String = ""
    var fileName: String = ""
    var recordedFiles = [String]()
    var recordedData = [Data]()
    let session = AVAudioSession.sharedInstance()
    var hours: Int = 0, minutes: Int = 0, sec: Int = 0
    var totalTime: Float = 0.0
    var timeInterval: TimeInterval = 0.2
    var arfm = AudioRecorderFirebaseManager()
    
    func startRecording() {
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("session error: \(error.localizedDescription)")
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd.HH:mm:ss"
        let nowDate: String = dateFormatter.string(from: Date())
        fileName = "voice-\(nowDate).m4a"
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            isRecording = true
            audioLevels.removeAll()
            recordTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (value) in
                self.getRecordingTime(self.audioRecorder?.currentTime ?? 0.0)
                if self.audioRecorder?.isRecording ?? false {
                    self.updateAudioLevels()
                }
            })
        } catch {
            print("record error: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        setRecoredFiles()
        isRecording = false
        stopTimer()
        Task {
            await arfm.saveOnFirebaseStorage(fileName, (audioRecorder?.url)!)
        }
    }
    
    func setRecoredFiles() {
        let documentsURL = getDocumentsDirectory()
        
        do {
            recordedFiles = try FileManager.default.contentsOfDirectory(atPath: documentsURL.path())
        } catch {
            print("Fail to read  in local files")
        }
    }
    
    func removeRecordedFile() {
        let documentsURL = getDocumentsDirectory()
        do {
            let filter = try FileManager.default.contentsOfDirectory(atPath: documentsURL.path())
            let removeFilesInLocal = filter.filter{!recordedFiles.contains($0)}
            for removeFile in removeFilesInLocal {
                let fileURL = getDocumentsDirectory().appendingPathComponent(removeFile)
                try FileManager.default.removeItem(at: fileURL)
                Task {
                    await arfm.removeOnFirebaseStorage(removeFile)
                }
            }
        } catch {
            print("remove error: \(error.localizedDescription)")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func startPlaying(recordedFile: String) {
        let playSession = AVAudioSession.sharedInstance()
        let fileURL = getDocumentsDirectory().appendingPathComponent(recordedFile)
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("play error: \(error.localizedDescription)")
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.isMeteringEnabled = true
            audioPlayer?.play()
            isPlaying = true
            audioLevels.removeAll()
            totalTime = Float(audioPlayer?.duration ?? 0.0)
            recordTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { value in
                self.getRecordingTime(self.audioPlayer?.currentTime ?? 0.0)
                if self.audioPlayer?.isPlaying ?? false {
                    self.updateAudioLevels()
                } else {
                    self.isPlaying = false
                    self.stopTimer()
                }
            })
        } catch {
            print("open error: \(error.localizedDescription)")
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
        stopTimer()
    }
    
    func getRecordingTime(_ duration: TimeInterval) {
        hours = Int(duration / 3600)
        minutes = Int(duration / 60) % 60
        sec = Int(duration) % 60
    }
    
    func stopTimer() {
        hours = 0
        minutes = 0
        sec = 0
        audioLevels.removeAll()
        recordTimer?.invalidate()
        recordTimer = nil
    }
    
    func updateAudioLevels() {
        if isRecording {
            audioRecorder?.updateMeters()
            if let averagePower = audioRecorder?.averagePower(forChannel: 0) {
                audioLevels.append(65 + max(CGFloat(averagePower), -60))
            }
        } else if isPlaying {
            audioPlayer?.updateMeters()
            if let averagePower = audioPlayer?.averagePower(forChannel: 0) {
                audioLevels.append(65 + max(CGFloat(averagePower), -60))
            }
        }
    }
}
