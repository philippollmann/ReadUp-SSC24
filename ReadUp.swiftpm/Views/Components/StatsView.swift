//
//  StatsView.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 11.02.24.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject private var pageViewModel: PageViewModel 
    @State private var showReadWordsView: Bool = false
    let num: Int
    let correctWords: Bool
    
    private var color: Color {
        return correctWords ? Color.flixoSuccess : Color.flixoError
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: correctWords ? "text.badge.checkmark" : "text.badge.xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 28)
                .padding(Spacing.spacingM)
                .background(color.opacity(0.2))
                .clipShape(.circle)
                .foregroundStyle(color)
            
            Text("\(num) \(correctWords ? "Correct" : "Incorrect")")
                .style(.subtitle2)
            
            Text("Words")
                .style(.body3, color: Color.flixoDarkGray)
        }
        .onTapGesture {
            showReadWordsView = true
        }
        .sheet(isPresented: $showReadWordsView) {
            ReadWordsView()
                .environmentObject(pageViewModel)
        }
    }
}

#Preview {
    StatsView(num: 324, correctWords: true)
}
