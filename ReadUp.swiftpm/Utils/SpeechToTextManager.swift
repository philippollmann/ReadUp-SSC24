//
//  SpeechToTextManager.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 08.02.24.
//

import Foundation
import Speech


// TODO: move to class
enum CustomError: Error {
    case runtimeError(String)
}

class SpeechToTextManager {
    
    static let shared: SpeechToTextManager = SpeechToTextManager()
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?

    private init() {}
    
    @discardableResult func requestAuthorization() -> Bool {
        SFSpeechRecognizer.requestAuthorization {
            (authStatus) in
            switch authStatus {
            case .authorized:
                print("Authorized!")
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
            @unknown default:
                fatalError()
            }
        }
        
        return SFSpeechRecognizer.authorizationStatus() == .authorized
    }
    
    func startRecording(wordDetectedAction: @escaping ([String])->()) -> Error? {
        do {
            audioEngine.reset()
            self.request = SFSpeechAudioBufferRecognitionRequest() // recreates recognitionRequest object (else error can happen)

            let node = audioEngine.inputNode
            print("Number of Inputs: \(node.numberOfOutputs)")
            print("Channel Count: \(node.outputFormat(forBus: 0).channelCount)")
            
            if node.outputFormat(forBus: 0).channelCount == 0 {
                return CustomError.runtimeError("Not enough available inputs.")
            }
            
            let recordingFormat = node.outputFormat(forBus: 0)
            
            node.removeTap(onBus: 0)
            node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [unowned self] (buffer, _) in
                self.request.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            recognitionTask = speechRecognizer?.recognitionTask(with: request) { (result, _) in
                
                guard let transcriptions = result?.transcriptions else {
                    print("Transcription failed")
                    return
                }
                
                let segments = transcriptions.compactMap{ $0.segments.last}
                var detectedWords: [String] = []
                
                for segment in segments {
                    detectedWords.append(segment.substring)
                    detectedWords.append(contentsOf: segment.alternativeSubstrings)
                }
                
                wordDetectedAction(detectedWords)
            }
            return nil
        } catch {
            print("Error startRecord(): \(error)")
            return error
        }
    }
    
    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        request.endAudio()
        recognitionTask?.cancel()
    }
}
