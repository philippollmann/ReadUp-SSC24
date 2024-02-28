//
//  AudioPlayerManager.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 12.02.24.
//

import Foundation
import AVFoundation

class AudioPlayerManager {
    static let shared = AudioPlayerManager()

    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func playSound(soundFileName: String, soundFileType: String) {
        if let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: soundFileType) {
            DispatchQueue.main.async {
                self.audioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
                self.audioPlayer?.play()
            }
        } else {
            print("Sound file not found")
        }
    }
}
