//
//  JsonManager.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 11.02.24.
//

import Foundation

enum JSONManagerError: Error {
    case fileNotFound
    case decodingError(Error)
}

class JSONManager {
    static let shared = JSONManager()

    private init() {}

    func readBook(from filePath: String) throws -> Book {
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            throw JSONManagerError.fileNotFound
        }
        do {
            let book = try JSONDecoder().decode(Book.self, from: jsonData)
            return book
        } catch {
            throw JSONManagerError.decodingError(error)
        }
    }
}
