//
//  Text.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 12.02.24.
//

import Foundation

class TextPage: Page, Hashable  {
    let text: String
    let imageName: String?
    
    init(text: String, imageName: String? = nil) {
        self.text = text
        self.imageName = imageName
        super.init(type: .text)
    }
    
    enum CodingKeys: String, CodingKey {
        case text, imageName
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
        try super.init(from: decoder)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(imageName)
    }
    
    static func == (lhs: TextPage, rhs: TextPage) -> Bool {
        lhs.hashValue != rhs.hashValue
    }
}

extension TextPage {
    static let fixture: TextPage = TextPage(text: "Lisa the astronaut and her friend Steve are in their seats, all buckled up inside the rocket getting closer and closer to their destination. They can not wait to land and start their moon adventure!", imageName: "astronaut_page1")
}
