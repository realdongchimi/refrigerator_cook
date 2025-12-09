import SwiftUI

extension Color {
    static let Cream = Color(hex: "FFFDf6")
    static let SoftGreen = Color(hex: "C2E0C4")
    static let SoftOrange = Color(hex: "FFD9BB")
    static let SoftYellow = Color(hex: "FFF2BF")
    static let DarkText = Color(hex: "333333")
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
