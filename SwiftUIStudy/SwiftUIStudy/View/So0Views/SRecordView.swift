//
//  SRecordView.swift
//  SwiftUIStudy
//
//  Created by 이소영 on 7/11/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
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
                        if audioRecorderManager.isPlaying {
                            audioRecorderManager.stopPlaying()
                        } else {
                            audioRecorderManager.startPlaying(recordedFile: recordedFile)
                        }
                    }, label: {
                        Text(recordedFile).foregroundStyle(audioRecorderManager.isPlaying && audioRecorderManager.audioPlayer?.url?.lastPathComponent == recordedFile ? .red : .black)
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
    let session = AVAudioSession.sharedInstance()
    var hours: Int = 0, minutes: Int = 0, sec: Int = 0
    var totalTime: Float = 0.0
    var timeInterval: TimeInterval = 0.2
    let arfm = AudioRecorderFirebaseManager()
    
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
        let audioData =  try? Data(contentsOf: (audioRecorder?.url)!)
        let encodedString = audioData?.base64EncodedString()
        guard let encodedString = encodedString else {
            print("Fail to encode")
            return
        }
        Task {
            await arfm.saveOnFirebase(fileName, encodedString)
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
            let removeFilesOnFirebase = filter.filter{!arfm.recordedFiles.contains($0)}
            // firebase에 저장 파일과 로컬 파일 동기화(로컬에 없는데 파이어 베이스에 있을 경우 해당 파일 삭제)
            for removeFile in removeFilesOnFirebase {
                Task {
                    await arfm.removeOnFirebase(removeFile)
                }
            }
            let removeFilesInLocal = filter.filter{!recordedFiles.contains($0)}
            for removeFile in removeFilesInLocal {
                let fileURL = getDocumentsDirectory().appendingPathComponent(removeFile)
                try FileManager.default.removeItem(at: fileURL)
                Task {
                    await arfm.removeOnFirebase(removeFile)
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

struct AudioRecorderFirebaseManager {
    let db = Firestore.firestore()
    let collection: String = "voice_folder"
    var recordedFiles = [String]()
    
    func saveOnFirebase(_ fileName: String, _ voiceData: String) async {
        do {
            try await db.collection(collection).document(fileName).setData(["data": "\(voiceData)"])
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    func removeOnFirebase(_ fileName: String) async {
        do {
          try await db.collection(collection).document(fileName).delete()
        } catch {
            print("Error removing document: \(error)")
        }
    }
    
    mutating func getVoiceFilesOnFirebase() async {
        do {
            let documents = try await db.collection(collection).getDocuments()
            for document in documents.documents {
                // document.documentID 파일 이름
                // document.data() 딕셔너리로 저장한 음성 데이터
                self.recordedFiles.append(document.documentID)
            }
        } catch {
            print("Error getting document: \(error)")
        }
    }
}

#Preview {
    SRecordView()
}
