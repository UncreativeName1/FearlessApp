
import Foundation
import Speech
import UIKit

class SpeechManager {
    public var isRecording = false
    
    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var audioSession: AVAudioSession!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    public func checkPermissions() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized: break
                case .denied:
                    let vcAlert = UIAlertController(title: "Alert", message: "Please enable Microphone Access and/or Speech Recognition in Settings.", preferredStyle: .alert)
                    vcAlert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }))
                    vcAlert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    DispatchQueue.main.async {
                    /// Show Alert
                    UIApplication.shared.windows.first?.rootViewController?.present(vcAlert, animated: true, completion: nil)
                    }
                default:
                    debugPrint("Speech recognition is not available. Error Code 02")
                }
            }
        }
    }
    
    public func start(completion: @escaping (String?) -> Void) {
        if isRecording {
            stopRecording()
        } else {
            startRecording(completion: completion)
        }
    }
    
    public func startRecording(completion: @escaping (String?) -> Void) {
        guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
            debugPrint("Speech Recognition is not available. Error Code 03")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest!.shouldReportPartialResults = true
        
        recognizer.recognitionTask(with: recognitionRequest!) { (result, error) in
            guard error == nil else {
                debugPrint("Got Error \(error!.localizedDescription) Error Code 04")
                return
            }
            guard let result = result else { return }
            
            if result.isFinal {
                completion(result.bestTranscription.formattedString)
            }
        }
        
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioEngine.start()
        } catch {
            debugPrint(error)
        }
    }
    
    public func stopRecording() {
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        if let audioEngine = audioEngine {
            audioEngine.stop()
        }
        if let inputNode = inputNode {
            inputNode.removeTap(onBus: 0)
        }
        
        if let audioSession = audioSession {
            try? audioSession.setActive(false)
        }
        audioSession = nil
    }
}
