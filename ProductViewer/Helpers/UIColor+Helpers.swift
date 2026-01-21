//
//  Copyright © 2022 Target. All rights reserved.
//
import UIKit
import SwiftUI



extension UIColor {

    static var primary : UIColor {
        .dynamic(light: UIColor(hex: 0xCC0000), dark: UIColor(hex: 0xEE2222))
    }

    static var background : UIColor {
        .dynamic(light: UIColor(hex: 0xFFFFFF), dark: UIColor(hex: 0x121212))
    }

    static var surface : UIColor {
        .dynamic(light: UIColor(hex: 0xFFFFFF), dark: UIColor(hex: 0x1E1E1E))
    }

    static var surfaceVariant : UIColor {
        .dynamic(light: UIColor(hex: 0xF5F5F5), dark: UIColor(hex: 0x2A2A2A))
    }

    static var textPrimary : UIColor {
        .dynamic(light: .black, dark: UIColor(hex: 0xF5F5F5))
    }

    static var textSecondary : UIColor {
        .dynamic(light: UIColor(hex: 0x333333), dark: UIColor(hex: 0xB0B0B0))
    }

    static var textTertiary : UIColor {
        .dynamic(light: UIColor(hex: 0x666666), dark: UIColor(hex: 0x808080))
    }

    static var error: UIColor {
        .dynamic(light: UIColor(hex: 0xD00000), dark: UIColor(hex: 0xFF6B6B))
    }

    static var success: UIColor {
        .dynamic(light: UIColor(hex: 0x2E7D32), dark: UIColor(hex: 0x4CAF50))
    }

    static var warning: UIColor {
        .dynamic(light: UIColor(hex: 0xF57C00), dark: UIColor(hex: 0xFFA726))
    }

    static var priceSale: UIColor {
        .dynamic(light: UIColor(hex: 0xAA0000), dark: UIColor(hex: 0xFF4444))
    }

    static var separator: UIColor {
        .dynamic(light: UIColor(hex: 0xE0E0E0), dark: UIColor(hex: 0x383838))
    }

    static var imagePlaceholder: UIColor {
        .dynamic(light: UIColor(hex: 0xF5F5F5), dark: UIColor(hex: 0x2A2A2A))
    }

    // Additional brand colors
    static var primaryVariant: UIColor {
        .dynamic(light: UIColor(hex: 0xAA0000), dark: UIColor(hex: 0xDD1111))
    }

    static var secondary: UIColor {
        .dynamic(light: UIColor(hex: 0x666666), dark: UIColor(hex: 0x999999))
    }

    // Additional text colors
    static var textOnPrimary: UIColor {
        .dynamic(light: .white, dark: .white)
    }

    // Additional price colors
    static var priceRegular: UIColor {
        .dynamic(light: UIColor(hex: 0x333333), dark: UIColor(hex: 0xCCCCCC))
    }

    // Additional UI element colors
    static var border: UIColor {
        .dynamic(light: UIColor(hex: 0xCCCCCC), dark: UIColor(hex: 0x444444))
    }

    static var buttonBackground: UIColor {
        .dynamic(light: UIColor(hex: 0xCC0000), dark: UIColor(hex: 0xEE2222))
    }

    static var buttonText: UIColor {
        .dynamic(light: .white, dark: .white)
    }

    // Navigation colors
    static var navigationBar: UIColor {
        .dynamic(light: UIColor(hex: 0xCC0000), dark: UIColor(hex: 0xEE2222))
    }

    static var navigationBarText: UIColor {
        .dynamic(light: .white, dark: .white)
    }
}


extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex >> 16) & 0xff) / 255
        let g = CGFloat((hex >> 08) & 0xff) / 255
        let b = CGFloat((hex >> 00) & 0xff) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        }
    }
    
    var color : Color {
        return Color(self)
    }
}
