//
//  PauseOverlay.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 08.02.24.
//

import Foundation
import SwiftUI

struct PauseOverlay: View {
    
    @EnvironmentObject private var pageViewModel: PageViewModel 

    var correctWords: Int
    var wrongWords: Int
    var resumeAction: ()->()
    var skipPageAction: ()->()
    var homeAction: ()->()
    
    var body: some View {
        VStack {
            Spacer()

            Text("Menu")
                .style(.title_2)
            
            Group{
                CustomButton(text: "Resume Reading", setInfinityWidth: true){ resumeAction() }
                CustomButton(text: "Skip Page", setInfinityWidth: true, color: Color.flixoSecondary ){ skipPageAction() }
                CustomButton(text: "Home Menu",setInfinityWidth: true, color: Color.flixoTertiary){ homeAction() }
            }
            .frame(width: 300)
            Spacer()
        }
        .overlay(alignment: .bottom){
            HStack(spacing: Spacing.spacing3XL){
                StatsView(num: correctWords, correctWords: true)
                StatsView(num: wrongWords, correctWords: false)
            }
            .padding(.bottom, Spacing.spacing5XL)
            .environmentObject(pageViewModel)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
        .preferredColorScheme(.light)
        .onTapGesture {
            resumeAction()
        }
    }
}


#Preview("PauseOverlay") {
    NavigationStack {
        PauseOverlay(correctWords: 10, wrongWords: 2) {
            print("Resume")
        } skipPageAction: {
            print("Skip")
        } homeAction: {
            print("Home")
        }
    }
    .environmentObject(PageViewModel())
}
