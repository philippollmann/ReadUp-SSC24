//
//  ReadTipView.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 24.02.24.
//

import SwiftUI
import TipKit

struct ReadTip: Tip {
    var title: Text {
        Text("Read the text aloud")
    }
    var message: Text? {
        Text("Make sure you are in a quiet environment and read the text out loud and clearly. If you are stuck, just click on the text and ReadUp will read it to you.")
    }
    
    var image: Image? {
        Image(systemName: "bubble.right")
    }
}
