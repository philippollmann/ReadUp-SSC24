//
//  TextToSpeechManager.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 08.02.24.
//

import AVFoundation

class TextToSpeechManager {
    static let shared = TextToSpeechManager()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    init() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try? audioSession.setMode(AVAudioSession.Mode.spokenAudio)
    }
    
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        print(AVSpeechSynthesisVoice.speechVoices().description)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.3
        utterance.volume = 1.5
        
        synthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

