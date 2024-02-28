//
//  TextView.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 22.02.24.
//

import SwiftUI
import TipKit

struct TextPageView: View {
    let page: TextPage
    
    @EnvironmentObject private var pageViewModel: PageViewModel
    @State private var viewModel: TextPageViewModel = TextPageViewModel()
       
    var body: some View {
        VStack(spacing: Spacing.spacingM) {
            Spacer()
            
            if let image = page.imageName {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(minHeight: 100, maxHeight: 350)
            }
            
            Spacer()
            
            Group {
                Text(viewModel.recognizedText)
                    .font(.headline0)
                    .foregroundStyle(Color.flixoDarkGray) +
                
                Text(createAttributedString())
                    .font(.headline0)
                    .foregroundStyle(Color.flixoPrimary) +
                
                Text(viewModel.unrecognizedText.trimmingCharacters(in: .whitespaces))
                    .font(.headline0)
                    .foregroundStyle(Color.flixoText)
            }
            .minimumScaleFactor(0.5)
            .multilineTextAlignment(.center)
            .onTapGesture {
                viewModel.speakWord()
            }
            .popoverTip(ReadTip(), arrowEdge: .bottom)
            //.popoverTip(ClickTextTip(), arrowEdge: .top)

            Spacer()
        }
        .overlay(alignment: .topLeading) {
            Label(viewModel.isRecording ? "Listening" : "Not Listening", systemImage: viewModel.isRecording ? "waveform.circle.fill" : "waveform.circle")
                .font(.body)
                .foregroundStyle(Color.flixoTertiary)
        }
        .padding(Spacing.spacingXL)
        .onAppear {
            viewModel.setup(page: page) { value, correct in
                pageViewModel.addReadWord(value: value, correct: correct)
            }
        }
        .onChange(of: viewModel.nextPage) {
            AudioPlayerManager.shared.playSound(soundFileName: "correct", soundFileType: "mp3")
            pageViewModel.nextPage()
        }
        .onChange(of: pageViewModel.showPauseOverlay) { _, new in
            viewModel.isRecording = !new
        }
        .onChange(of: pageViewModel.currentPageIndex) { old, new in
            if let page = pageViewModel.currentPage as? TextPage {
                viewModel.setup(page: page) { value, correct in
                    pageViewModel.addReadWord(value: value, correct: correct)
                }
            }
        }
    }
    
    private func createAttributedString() -> AttributedString {
        var expectedWord = AttributedString(" " + viewModel.expectedWord + " ")
        
        expectedWord.font  = .headline0
        expectedWord.foregroundColor  = .flixoPrimary
        expectedWord.backgroundColor = Color.flixoPrimary.opacity(0.2)
        
        return expectedWord
    }
}

#Preview("TextPageView") {
    TextPageView(page: TextPage.fixture)
        .environmentObject(PageViewModel())
}
