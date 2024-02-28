//
//  QuizView.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 12.02.24.
//

import SwiftUI
import ConfettiSwiftUI

struct QuizPageView: View {
    
    
    let page: QuizPage
    
    @EnvironmentObject private var pageViewModel: PageViewModel
    @State private var shouldShake: Bool = false
    @State private var showConfetti: Int = 0
    
    var body: some View {
        VStack(spacing: Spacing.spacingXL) {
            Spacer()
            
            Text(page.question)
                .style(.headline1)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .minimumScaleFactor(0.5)
                .padding(.bottom, Spacing.spacingXL)
                //.background(Color.flixoBackground)
                //.clipShape(.rect(cornerRadius: 12))
                .multilineTextAlignment(.center)
                //.shadow(radius: 5)
                .confettiCannon(counter: $showConfetti, num: 50, colors: [.flixoPrimary, .flixoSecondary, .flixoTertiary],confettiSize: 15, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360))
            
            ForEach(Array(page.answers.enumerated()), id: \.offset){ index, answer in
                CustomButton(text: answer.answer, setInfinityWidth: true, color: getColorForIndex(index: index)) {
                    if answer.correct {
                        print("Correct!")
                        showConfetti += 1
                        AudioPlayerManager.shared.playSound(soundFileName: "correct", soundFileType: "mp3")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            pageViewModel.nextPage()
                        }
                    } else {
                        shouldShake.toggle()
                        AudioPlayerManager.shared.playSound(soundFileName: "wrong", soundFileType: "mp3")
                    }
                }
            }
            
            Spacer()
        }
        .padding(Spacing.spacingXL)
        .toolbar(.hidden)
        .offset(x: shouldShake ? -5 : 0)
        .animation(Animation.default.repeatCount(6, autoreverses: true).speed(6), value: shouldShake)
        .sensoryFeedback(.error, trigger: shouldShake)
    }
    
    private func getColorForIndex(index: Int) -> Color {
        switch index {
        case 0: return .flixoPrimary
        case 1: return .flixoSecondary
        case 2: return .flixoTertiary
        default: return .flixoFourth
        }
    }
}

#Preview {
    QuizPageView(page: QuizPage.fixture)
}


// TODO: Outsource
fileprivate struct ShakeEffect: AnimatableModifier {
    var offset: CGFloat = 0
    var shouldShake: Bool
    
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: shouldShake ? offset : 0, y: 0)
    }
}

extension View {
    func shake(shouldShake: Bool) -> some View {
        self.modifier(ShakeEffect(shouldShake: shouldShake))
    }
}
