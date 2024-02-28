//
//  TextPageViewModel.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 22.02.24.
//

import Foundation


import SwiftUI
import Speech

enum WordStatus {
    case correct
    case incorrect
    case not_determined
}

@Observable
final class TextPageViewModel {
    
    var error: Error? = nil
    var recognizedText: String { return recognizedWords.concatStrings() }
    var unrecognizedText: String { return Array(wordsToRecognize.dropFirst()).concatStrings()}
    var expectedWord: String { return wordsToRecognize.first ?? ""}
    var nextPage: Bool = false
    var addDetectedWord: (_ value: String, _ correct: Bool) -> Void = { _, _ in }
    
    private var wordsToRecognize: [String] = [] // words the user has not read yet
    private var recognizedWords: [String] = [] // words the user has already read
    private let speechToTextManager: SpeechToTextManager = SpeechToTextManager.shared
    private let textToSpeechManager: TextToSpeechManager = TextToSpeechManager.shared
    private var page: TextPage? = nil
    
    var isRecording: Bool = false {
        willSet {
            if newValue {
                try? startRecording()
            } else {
                stopRecording()
            }
        }
    }
    
    func setup(page: TextPage, addDetectedWord: @escaping (_ value: String, _ correct: Bool) -> Void) {
        self.isRecording = false
        self.page = page
        setWords()
        self.isRecording = true
        self.addDetectedWord = addDetectedWord
    }
    
    deinit {
        self.isRecording = false
    }
    
    private func setWords(){
        guard let page else { return }
        wordsToRecognize =  page.text.components(separatedBy: .whitespacesAndNewlines)
        recognizedWords = []
    }
    
    func wordDetected(detectedWords: [String]){
        
        if detectedWords.first?.isEmpty ?? false {
            return
        }
                
        if let nextWord = wordsToRecognize.first {
            // if word only consts of 1 character then skip listening because words (e.g. a) are hard to detect
            if detectedWords.contains(where: {nextWord.withoutPunctuationsLowercase.hasPrefix($0.withoutPunctuationsLowercase) ||
                $0.withoutPunctuationsLowercase.hasPrefix(nextWord.withoutPunctuationsLowercase)
            }) || nextWord.count == 1 || nextWord == "an" {
                
                self.addDetectedWord(nextWord, true)
                print("Correct! (Expected: \(nextWord), Detected: \(detectedWords.description)")
                recognizedWords.append(nextWord)
                wordsToRecognize.removeFirst()
                                
                if wordsToRecognize.isEmpty {
                    isRecording = false
                    nextPage.toggle()
                }
            } else {
                print("Not Correct! (Expected: \(nextWord), Detected: \(detectedWords.description)")
                self.addDetectedWord(nextWord, false)
            }
        } else {
            isRecording = false
            nextPage.toggle()
        }
    }
}

extension TextPageViewModel {
    
    func requestAuthorization() {
        if !speechToTextManager.requestAuthorization() {
            error = CustomError.runtimeError("Speech Detection not granted. Check in settings")
        }
    }
    
    func startRecording(){
        if !isRecording {
            error = speechToTextManager.startRecording { [weak self] detectedWords in
                self?.wordDetected(detectedWords: detectedWords)
            }
        }
    }
    
    func stopRecording(){
        if isRecording {
            speechToTextManager.stopRecording()
        }
    }
    
    func speakWord(){
        textToSpeechManager.speak(text: expectedWord)
        wordDetected(detectedWords: [expectedWord])
    }
}
