import SwiftUI

struct CustomIconButton: View {
    var icon: Image
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 21)
                .padding(Spacing.spacingM)
                .foregroundStyle(Color.flixoDarkGray)
        }
        .frame(width: 64, height: 64)
        .background(Color.flixoLightGray)
        .clipShape(.circle)
         
    }
}

#Preview("Custom Icon Button"){
    CustomIconButton(icon: Image(systemName: "xmark")) {
        print("Working!")
    }
}
