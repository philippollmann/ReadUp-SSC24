import SwiftUI

enum BookNavigationDirection {
    case forward
    case backward
}

@Observable
final class StartViewModel {
    
    var showOnboarding: Bool = false
    var showInfoSheet: Bool = false
    var showBook: Bool = false
    var currentBook: Int = 0
    var books: [Book] = []
    var error: Error? = nil
    
    func navigateBook(direction: BookNavigationDirection){
        currentBook = currentBook + (direction == .backward ? -1 : +1)
        currentBook = currentBook > books.count-1 ? 0 : currentBook
        currentBook = currentBook < 0 ? books.count-1 : currentBook
        print("Book set to \(currentBook)")
    }
    
    init() {
        // Load books from json files
        do {
            if let filePath = Bundle.main.path(forResource: "lisa_astronaut", ofType: "json") {
                books.append(try JSONManager.shared.readBook(from: filePath))
            }
            
            // coming soon (just for SSC24)
            books.append(Book.bookFixturesComingSoon)
        } catch {
            print("Error Read Book: \(error)")
            self.error = error
        }
    }
}
