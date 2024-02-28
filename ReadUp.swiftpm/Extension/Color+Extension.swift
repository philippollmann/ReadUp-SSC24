import SwiftUI

extension Color {
    
    static let flixoPrimary = Color(hex: "8995c1")
    static let flixoSecondary =  Color(hex: "41afe4")
    static let flixoTertiary =  Color(hex: "FEAA47")
    static let flixoFourth =  Color(hex: "D45050")

    static let flixoError = Color(hex: "F06647")
    static let flixoSuccess = Color(hex: "74bab9")
    
    static let flixoBackground = Color(hex: "ffffff")
    static let flixoAccent = Color(hex: "d79aac")
    static let flixoText = Color(hex: "06283b")
    static let flixoDarkGray = Color(hex: "7A7A7A")
    static let flixoLightGray = Color(hex: "F0F0F0")
    
    
    init(hex: String, alpha: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
