//
//  CustomTextView.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 09.02.24.
//

import SwiftUI

struct CustomTextView: View {
    
    var recognizedWords: [String]
    var nextWordToRecognize: String
    var unrecognizedWords: [String]
    
    private let data  = Array(1...20)
    private let adaptiveColumn = [GridItem(.flexible(minimum: 150, maximum: 3000))]
    
    var body: some View {
        LazyVGrid(columns: adaptiveColumn, spacing: Spacing.spacingS) {
            ForEach(recognizedWords, id: \.self) { word in
                Text(word)
                    .style(.headline0, color: .flixoDarkGray)
            }
            
            Text(nextWordToRecognize)
                .style(.headline0, color: .flixoPrimary)
            
            ForEach(unrecognizedWords, id: \.self) { word in
                Text(word)
                    .style(.headline0)
            }
        }
    }
}

#Preview {
    CustomTextView(recognizedWords: ["Test", "Test1", "Test2", "Test3", "Test4"],
                   nextWordToRecognize: "Next Word",
                   unrecognizedWords: ["Test5", "Test6", "Test7", "Test8", "Test9", "Test10"])
}
