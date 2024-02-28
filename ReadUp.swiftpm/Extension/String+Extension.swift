import SwiftUI

extension String {
    var withoutPunctuationsLowercase: String {
        return self.components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "").lowercased()
    }
}


// Swift Array
extension Array<String> {
    func concatStrings() -> String {
        var rv = ""
        for text in self {
            rv += " \(text.description)"
        }
        return rv
    }
}
