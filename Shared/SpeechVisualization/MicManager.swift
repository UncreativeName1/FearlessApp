
import Foundation
import AVFoundation

enum MediaExtensionType {
    case caf
    
    var name: String {
        switch self {
        case .caf: return "caf"
        }
    }
}

class MicMonitor: ObservableObject {
    
    private var audioRecorder: AVAudioRecorder!
    private var timer: Timer?
    private var currentSample: Int
    private let numberOfSamples: Int
    let fileExtension: MediaExtensionType = .caf

    let recorderSettings: [String:Any] = [
        AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
        AVSampleRateKey: 44100.0,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
    ]
    
    @Published public var soundSamples: [Float]
    
    init(numberOfSamples: Int) {
        self.numberOfSamples = numberOfSamples > 0 ? numberOfSamples : 10
        self.soundSamples = [Float](repeating: .zero, count: numberOfSamples)
        self.currentSample = 0
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func startMonitoring(fileName: String) {
        /// Save recorded audio in this path
        guard let folderPath = FLFileManager.shared.documentDir?.appendingPathComponent(FLFileManager.FolderNames.audio.name) else { return }
        if !FileManager.default.fileExists(atPath: folderPath.path) {
            try? FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        let url = folderPath.appendingPathComponent(fileName)
        debugPrint("\(#function) file path: \(url.path)")
        
        guard let audioRecorder = try? AVAudioRecorder(url: url, settings: recorderSettings) else { return }
        self.audioRecorder = audioRecorder
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            self.audioRecorder.updateMeters()
            self.soundSamples[self.currentSample] = self.audioRecorder.averagePower(forChannel: 0)
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
        })
    }
    
    public func totalDuration(fileName: String) -> Double {
        guard let url = FLFileManager.shared.getFilePath(fileName: fileName, folder: .audio) else { return 0 }
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            return audioPlayer.duration
        } catch {
            debugPrint("\(#function) file path: \(url.path), error: \(error.localizedDescription)")
            return 0
        }
    }
    
    public func stopMonitoring() {
        timer?.invalidate()
        self.stopRecording()
    }
    
    public func stopRecording() {
        guard let audioRecorder = audioRecorder else { return }
        audioRecorder.stop()
    }
    
    deinit {
        timer?.invalidate()
        self.stopRecording()
    }
    
}
