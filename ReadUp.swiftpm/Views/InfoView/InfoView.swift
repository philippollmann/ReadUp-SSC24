//
//  InfoView.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 24.02.24.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var showOnboarding: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section("Illustrations") {
                        Link(destination: URL(string: "https://blush.design")!, label: {
                            Text("Made by Blush")
                                .foregroundStyle(Color.flixoSecondary)
                                .style(.body3)

                        })
                    }
                    
                    Section("Libraries") {
                        Link(destination: URL(string: "https://github.com/simibac/ConfettiSwiftUI")!, label: {
                            Text("ConfettiSwiftUI")
                                .foregroundStyle(Color.flixoSecondary)
                                .style(.body3)
                        })
                    }
                    
                    Section("Other") {
                        Text("The story and all of the sounds were created by me. (Philipp Ollmann)")
                            .style(.body3)
                            
                    }
                }
                .listStyle(.inset)
                .style(.body3)
                
                CustomButton(text: "Show Onboarding") {
                    showOnboarding = true
                }
                .padding(Spacing.spacingXL)
            }
            .tint(.flixoSecondary)
            .navigationTitle("Acknowledgments")
            .sheet(isPresented: $showOnboarding) {
                OnboardingView()
            }
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.flixoDarkGray)
                }
            }
        }
    }
}

#Preview {
    InfoView()
}
