import SwiftUI

struct CustomButton: View {
    
    var text: String
    var setInfinityWidth: Bool = false
    var color: Color = Color.flixoPrimary
    var action: () -> Void
    
    var body: some View {
        Button{
            action()
        } label: {
            HStack {
                Text(text)
                    .style(.headline2, color: color)
                    .padding(.horizontal, Spacing.spacingXL)
            }
            .contentShape(Rectangle())
        }
         .frame(height: 56)
         .frame(maxWidth: setInfinityWidth ? .infinity : nil)
         .background(color.opacity(0.2))
        .clipShape(.rect(cornerRadii: .init(topLeading: 16, bottomLeading: 16, bottomTrailing: 16, topTrailing: 16)))
    }
}

#Preview("Custom Button"){
    CustomButton(text: "Test"){
        print("Working!")
    }
}
