//
//  SRecordView.swift
//  SwiftUIStudy
//
//  Created by 이소영 on 7/11/24.
//

import SwiftUI
import AVFoundation

struct SRecordView: View {
    @StateObject var audioRecorderManager = AudioRecorderManager()
    @State var scale: CGFloat = 1.0
    @State var isAnimate: Bool = false

    var body: some View {
        VStack {
            List {
                ForEach(audioRecorderManager.recordedFiles, id: \.self) { recordedFile in
                    
                    Button(action: {
                        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                        if audioRecorderManager.isRecording {
                            audioRecorderManager.stopRecording()
                            isAnimate = false
                            scale = 1.0
                        }
                        
                        if audioRecorderManager.isPlaying {
                            audioRecorderManager.stopPlaying()
                        } else {
                            audioRecorderManager.startPlaying(recordingURL: recordedFile)
                        }
                    }, label: {
                        Text(recordedFile.lastPathComponent).foregroundStyle(audioRecorderManager.isPlaying && audioRecorderManager.audioPlayer?.url == recordedFile ? .red : .black)
                    })
                }
                .onDelete(perform: { indexSet in
                    audioRecorderManager.recordedFiles.remove(atOffsets: indexSet)
                    audioRecorderManager.removeRecordedFile()
                })
            }
            
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

class AudioRecorderManager: NSObject, ObservableObject {
    @Published var isPlaying = false
    @Published var isRecording = false
    @Published var audioLevels: [CGFloat] = []
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    var recordTimer: Timer?
    var timerString: String = ""
    var filteringFiles = [URL]()
    var recordedFiles = [URL]()
    let session = AVAudioSession.sharedInstance()
    var hours: Int = 0, minutes: Int = 0, sec: Int = 0
    var totalTime: Float = 0.0
    var timeInterval: TimeInterval = 0.2
    
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
        let fileURL = getDocumentsDirectory().appendingPathComponent("voice-\(nowDate).m4a")
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
        recordedFiles.append(audioRecorder!.url)
        filteringFiles.append(audioRecorder!.url)
        isRecording = false
        stopTimer()
    }
    
    func removeRecordedFile() {
        let newFilterFiles = filteringFiles.filter{recordedFiles.contains($0)}
        let removeFileURLs = filteringFiles.filter{!recordedFiles.contains($0)}
        
        do {
            for removeFileURL in removeFileURLs {
                try FileManager.default.removeItem(at: removeFileURL)
                filteringFiles = newFilterFiles
            }
        } catch {
            print("remove error: \(error.localizedDescription)")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func startPlaying(recordingURL: URL) {
        let playSession = AVAudioSession.sharedInstance()
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("play error: \(error.localizedDescription)")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
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
                audioLevels.append(65 + max(CGFloat(averagePower), -70))
            }
        } else if isPlaying {
            audioPlayer?.updateMeters()
            if let averagePower = audioPlayer?.averagePower(forChannel: 0) {
                audioLevels.append(65 + max(CGFloat(averagePower), -70))
            }
        }
    }
}

#Preview {
    SRecordView()
}
