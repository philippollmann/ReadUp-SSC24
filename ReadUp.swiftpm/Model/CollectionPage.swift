//
//  CollectionGame.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 23.02.24.
//

import Foundation

class CollectionPage : Page {
    let title: String
    let amount: Int
    let textureName: String
    let objectName: String
    
    init(amount: Int, title: String, objectName: String, textureName: String) {
        self.amount = amount
        self.objectName = objectName
        self.textureName = textureName
        self.title = title
        super.init(type: .collect)
    }
    
    enum CodingKeys: String, CodingKey {
        case amount, textureName, objectName, title
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decode(Int.self, forKey: .amount)
        title = try container.decode(String.self, forKey: .title)
        textureName = try container.decode(String.self, forKey: .textureName)
        objectName = try container.decode(String.self, forKey: .objectName)
        try super.init(from: decoder)
    }
}

extension CollectionPage {
    static let fixture: CollectionPage = CollectionPage(amount: 10, title: "Can you help Lisa and Steve collect all the Stones?", objectName: "asteroid.obj", textureName: "mars.jpg")
}
