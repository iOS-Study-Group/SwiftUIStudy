import AVFoundation
import FirebaseStorage

class VoiceRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    //[녹음] 기능
    var recorder: AVAudioRecorder?
    
    //[녹음 파일 듣기] 기능
    var player: AVAudioPlayer?
    
    //녹음 파일 저장할 배열 선언
    @Published var recordFiles: [URL] = []
    
    
    //[녹음- 시작] 기능
    func startRecord() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            let fileName = "\(Date().timeIntervalSince1970).m4a"
            //파일명 형식 지정
            
            let recordFile = getFile().appendingPathComponent(fileName)
            
            recorder = try AVAudioRecorder(url: recordFile, settings: settings)
            recorder?.delegate = self
            recorder?.record()
            
            self.recordFiles.append(recordFile)
        } catch {
            print("!ERROR!")
        }
    }
    
    //[녹음 - 종료] 기능 & 파이어베이스 업로드
    func stopRecord() {
        recorder?.stop()
        if let url = recorder?.url {
            uploadToFirebase(url: url)
        }
        recorder = nil
    }
    
    //[녹음파일 - 시작] 기능
    func startPlay(url: URL) {
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.play()
        } catch {
            print("!ERROR!")
        }
    }
    
    //[녹음파일 - 종료] 기능
    func stopPlay() {
        player?.stop()
        player = nil
    }
    
    //저장된 녹음 파일 가져오는 함수
    func getFile() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    //FileManager.default.urls(for:in:) : 파일 매니저 객체, URL 목록 반환
    //.documentDirectory : 생성한 파일 저장되는 저장소
    //.userDomainMask : 사용자의 저장소
    //paths : 반환된 URL 목록
    //paths[0] : 목록 안에 문서 디렉터리 하나 반환
    
    //[녹음파일 - 삭제] 기능 & 파이어베이스 삭제
    func deleteFile(url: URL) {
        let file = FileManager.default
        
        do {
            try file.removeItem(at: url)
            if let index = recordFiles.firstIndex(of: url) {
                recordFiles.remove(at: index)
            }
            deleteFromFirebase(url: url)
        } catch {
            print("!ERROR!")
        }
    }
    
    // 파이어베이스에 파일 업로드
    func uploadToFirebase(url: URL) {
        let storage = Storage.storage()
        let storageReference = storage.reference()

        let fileReference = storageReference.child("Sumchive/\(url.lastPathComponent)")
        
        let _ = fileReference.putFile(from: url, metadata: nil) { metadata, error in
            if let error = error {
                print("!ERROR! : \(error.localizedDescription)")
            } else {
                print("Upload success")
            }
        }
    }
    
    //파이어베이스의 파일 삭제
    func deleteFromFirebase(url: URL) {
            let storage = Storage.storage()
            let storageReference = storage.reference()

            let fileReference = storageReference.child("Sumchive/\(url.lastPathComponent)")
            
            fileReference.delete { error in
                if let error = error {
                    print("!ERROR! : \(error.localizedDescription)")
                } else {
                    print("Delete success")
                }
            }
        }
}
