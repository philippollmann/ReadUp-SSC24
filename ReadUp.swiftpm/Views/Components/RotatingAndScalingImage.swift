//
//  RotatingAndScalingImage.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 23.02.24.
//

import SwiftUI

struct RotatingAndScalingImage: View {
    
    let imageName: String
    @State private var rotation = 0.0
    @State private var scaling = 0.5
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scaling)
            .onAppear {
                withAnimation(.interactiveSpring(duration: .random(in: 2...5))
                    .repeatForever(autoreverses: true)) {
                    rotation = 360.0
                    scaling = 1.3
                }
            }
    }
}

#Preview("RotatingAndScalingImage") {
    RotatingAndScalingImage(imageName: "astronaut_stone1")
}
