import SwiftUI
import Speech

@Observable
final class PageViewModel: ObservableObject {
    
    
    var showFinishView: Bool = false
    var showStartView: Bool = false
    var showPauseOverlay: Bool = false
    
    var book: Book? = nil
    var currentPageIndex: Int = 0
    var currentPage: Page? {
        return book?.pages[currentPageIndex]
    }
    
    var correctWords: Int {
        return readWords.filter({$0.value == true}).count
    }
    
    var wrongWords: Int {
        return readWords.filter({$0.value == false}).count
    }
    
    var readWords: Dictionary<String, Bool> = [:] // correct and wrong words
    
    func setup(book: Book){
        self.book = book
    }
    
    func nextPage(){
        guard let book else { return }
        if currentPageIndex + 1 < book.pages.count {
            currentPageIndex += 1
            
        } else {
            showFinishView = true
        }
    }
    
    func addReadWord(value: String, correct: Bool) {
        if !readWords.contains(where: {$0.key == value}) {
            readWords[value] = correct
        }
    }
}
