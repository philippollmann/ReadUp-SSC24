import SwiftUI

struct CustomPageIndicator: View {
    let numPages: Int
    let currentPage: Int
    
    var body: some View {
        HStack(spacing: Spacing.spacingL) {
            ForEach(1...numPages, id: \.self) { index in
                if index != currentPage {
                    Circle().fill(Color.flixoDarkGray)
                        .frame(width: 12)
                } else {
                    Text("\(currentPage)")
                        .style(.headline2, color: Color.flixoBackground)
                        .padding(Spacing.spacingM)
                        .background(Color.flixoPrimary)
                        .clipShape(.circle)
                }
            }
        }
    }
}

#Preview("Custom Page Indicator") {
    ZStack {
        Color.flixoBackground
        CustomPageIndicator(numPages: 7, currentPage: 2)
    }
}
