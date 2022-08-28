
import AVFoundation

class FLMediaPlayer: NSObject, ObservableObject {
        
    fileprivate var audioPlayer: AVAudioPlayer?
    var fileUrl: URL = URL(string: "empty")!
    @Published var totalDuration: TimeInterval = 0.0
    @Published var currentDuration: TimeInterval = 0.0
    @Published var isPlaying: Bool = false
    var seekTime: Double = 0.0 {
        didSet {
            self.seekTo(time: seekTime)
        }
    }

    fileprivate var timerPlayer: Timer?
    var isSeeking: Bool = false

    override init() {
        super.init()
        self.configureAudioSession()
    }
    
    fileprivate func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        } catch {
            debugPrint("\(#function) error: \(error)")
        }
    }
    
    //MARK:- Player Services
    
    func play() {
        debugPrint("\(#function) fileUrl: \(fileUrl.path)")
        
        self.stop()
        
        if self.audioPlayer == nil {
            self.audioPlayer = try? AVAudioPlayer(contentsOf: fileUrl)
            self.audioPlayer?.delegate = self
            self.totalDuration = self.audioPlayer?.duration.validValue ?? 0
        }
        
        self.startTimer()
        self.seekTo(time: self.seekTime)
        self.audioPlayer?.play()
        self.isPlaying = true
    }
    
    func stop() {
        guard let player = self.audioPlayer else { return }
        debugPrint("\(#function) fileUrl: \(player.url?.path ?? "")")
        
        self.stopTimer()
        self.audioPlayer?.stop()
        self.audioPlayer = nil
        self.isPlaying = false
        self.seekTime = 0
        self.currentDuration = 0
    }
    
    fileprivate func seekTo(time: Double) {        
        self.audioPlayer?.currentTime = time.validValue
    }
}

extension FLMediaPlayer {
    //MARK:- Player Duration Observer

    fileprivate func startTimer() {
        debugPrint("\(#function)")
        
        guard self.timerPlayer == nil else { return }
        self.timerPlayer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            guard !self.isSeeking else { return }
            self.currentDuration = self.audioPlayer?.currentTime.validValue ?? 0
            debugPrint("\(#function) currentDuration: \(self.currentDuration)/\(self.totalDuration)")
        })
    }
    
    fileprivate func stopTimer() {
        debugPrint("\(#function)")

        self.timerPlayer?.invalidate()
        self.timerPlayer = nil
    }
}

extension FLMediaPlayer: AVAudioPlayerDelegate {
    //MARK:- Player Events
    //MARK:- AVAudioPlayerDelegate

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        debugPrint("\(#function) flag: \(flag)")
        self.stop()
    }
}

extension AVPlayer {
    var url: URL? { self.currentItem?.url }
}

extension AVPlayerItem {
    var url: URL? { self.asset.urlPath }
}

extension AVAsset {
    var urlPath: URL? { (self as? AVURLAsset)?.url }
}
