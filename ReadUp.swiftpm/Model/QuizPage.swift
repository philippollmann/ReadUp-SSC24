//
//  Quiz.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 12.02.24.
//

import Foundation

class QuizPage : Page {
    let question: String
    let answers: [Answer]
    
    init(question: String, answers: [Answer]) {
        self.question = question
        self.answers = answers
        super.init(type: .quiz)
    }
    
    enum CodingKeys: String, CodingKey {
        case question, answers
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        question = try container.decode(String.self, forKey: .question)
        answers = try container.decode([Answer].self, forKey: .answers)
        try super.init(from: decoder)
    }
}

struct Answer: Codable {
    let answer: String
    let correct: Bool
}

extension QuizPage {
    static let fixture: QuizPage = QuizPage(question: "Who is helping Lisa and Steve cleaning the rocket and cooking for them?", answers: [
        Answer(answer: "Rover the Robot", correct: true),
        Answer(answer: "Allen the Alien", correct: false),
        Answer(answer: "Samy the Dolphin", correct: false),
        Answer(answer: "Max the Dog", correct: false),
    ])
}
