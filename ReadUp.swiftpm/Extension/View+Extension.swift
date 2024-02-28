import SwiftUI

extension View {
    func style(_ font: Font, color: Color = Color.flixoText) -> some View {
        self.modifier(TextStyleModifier(font: font, color: color))
    }
}
