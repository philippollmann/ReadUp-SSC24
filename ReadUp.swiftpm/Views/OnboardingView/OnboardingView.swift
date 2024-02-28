//
//  OnboardingView.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 24.02.24.
//

import SwiftUI

fileprivate enum OnnboardingEntries: CaseIterable {
    case coach
    case stories
    case quiz
    case miniGame
    
    
    var title: String {
        switch self {
        case .coach: return "Reading Coach"
        case .stories: return "Stories"
        case .quiz: return "Quizzes"
        case .miniGame: return "Mini Games"
        }
    }
    
    var text: String {
        switch self {
        case .coach: return "ReadUp intelligently monitors children's reading and tracks the correctly and incorrectly read words."
        case .stories: return "Let children dive into stories that take them on thrilling adventures."
        case .quiz: return "Ensure meaningful reading with quizzes between the pages."
        case .miniGame: return "Spark joy in reading with fun-filled mini AR games!"
        }
    }
    
    var image: Image {
        switch self {
        case .coach: return Image(systemName: "text.book.closed")
        case .stories:
            return Image(systemName: "sparkles")
        case .quiz:
            return Image(systemName: "graduationcap.fill")
        case .miniGame:
            return Image(systemName: "gamecontroller.fill")
        }
    }
    
    var imageColor: Color {
        switch self {
        case .coach: return Color.flixoPrimary
        case .stories: return Color.flixoSecondary
        case .quiz: return Color.flixoTertiary
        case .miniGame: return Color.flixoFourth
        }
    }
}

struct OnboardingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var hapticFeedback = false

    var body: some View {
        VStack(spacing: Spacing.spacing2XL) {
            Text("Welcome to ReadUp")
                .style(.headline0, color: .flixoText)
                .multilineTextAlignment(.center)
            
            Group {
                Text("ReadUp is a reading coach, supporting and motivating children in their reading learning process. According to the New York Times, ") +
                Text("1/3 ").foregroundStyle(Color.flixoError) +
                Text("of children in America have inadequate reading skills.") +
                Text("That's bad, and my Swift Student Challenge 2024 ReadUp helps combat this problem.⚔️")
            }
            .style(.subtitle2, color: .flixoDarkGray)
            .multilineTextAlignment(.center)
        
            VStack(alignment: .leading) {
                ForEach(OnnboardingEntries.allCases, id: \.title) { entry in
                    createOnboardingCell(title: entry.title, icon: entry.image, iconColor:entry.imageColor, text: entry.text)
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Spacer()
            
            CustomButton(text: "Get Started") {
                hapticFeedback = true
                dismiss()
            }
            .sensoryFeedback(.success, trigger: hapticFeedback)
        }
        .padding(Spacing.spacingXL)
    }
    
    @ViewBuilder
    func createOnboardingCell(title: String, icon: Image, iconColor: Color, text: String) -> some View {
        HStack(spacing: Spacing.spacingL) {
            
            icon
                .resizable()
                .foregroundStyle(iconColor)
                .scaledToFit()
                .frame(width: 21)
            
            VStack(alignment: .leading) {
                Text(title)
                    .style(.subtitle2)
                
                
                Text(text)
                    .style(.body3, color: .flixoDarkGray)
                    .multilineTextAlignment(.leading)
                    
            }
        }
        .padding(Spacing.spacingM)
    }
}

#Preview {
    OnboardingView()
}
