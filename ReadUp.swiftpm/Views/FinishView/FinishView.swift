import SwiftUI
import ConfettiSwiftUI

struct FinishView: View {
    
    @EnvironmentObject private var pageViewModel: PageViewModel 

    let correctWords: Int
    let wrongWords: Int
    @State private var confetti: Int = 0
    @State private var showHome: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("confetti")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: Spacing.spacingS) {
                    Spacer()
                    Group {
                        Text("You did it!")
                            .style(.headline3, color: Color.flixoDarkGray)
                        Text("Congratulations")
                            .style(.headline1)
                    }
                    .onTapGesture {
                        confetti += 1
                    }
                    
                    CustomButton(text: "Home"){
                        showHome = true
                    }
                    .padding(.top, Spacing.spacingM)
                    Spacer()
                }
                .onAppear {
                    confetti = 1
                }
                .frame(maxWidth: .infinity)
                .confettiCannon(counter: $confetti, num: 50, colors: [.flixoPrimary, .flixoSecondary, .flixoTertiary],confettiSize: 15, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360))
                .navigationDestination(isPresented: $showHome) {
                    StartView()
                }
                .overlay(alignment: .bottom) {
                    HStack(spacing: Spacing.spacing4XL) {
                        StatsView(num: correctWords, correctWords: true)
                        StatsView(num: wrongWords, correctWords: false)
                    }
                    .padding(.bottom, Spacing.spacing3XL)
                    .environmentObject(pageViewModel)
                }
            }
        }
        .toolbar(.hidden)
        .onAppear{
            AudioPlayerManager.shared.playSound(soundFileName: "finish-sound", soundFileType: "mp3")
        }
    }
}

#Preview("FinishView") {
    FinishView(correctWords: 12, wrongWords: 2)
}
