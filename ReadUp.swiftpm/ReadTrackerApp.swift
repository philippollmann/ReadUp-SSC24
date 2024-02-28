//
//  ReadTrackerApp.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 08.02.24.
//

import SwiftUI
import TipKit

@main
struct ReadTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            StartView()
                .preferredColorScheme(.light)
                .tint(.flixoPrimary)
                .task {
                    //try? Tips.resetDatastore() // for testing tips
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}
