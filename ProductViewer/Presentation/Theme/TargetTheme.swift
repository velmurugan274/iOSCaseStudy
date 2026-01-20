//
//  TargetTheme.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//
import UIKit

public final class TargetTheme: Theme {
    
    public static let shared = TargetTheme()
    
    public let colors: Colors
    public let fonts: Fonts
    
    public init(colors: Colors = TargetColors(), fonts: Fonts = TargetFonts()) {
        self.colors = colors
        self.fonts = fonts
    }
}

public struct TargetColors: Colors {
    
    public init() {}
    
    public var primary: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0xEE/255, green: 0x22/255, blue: 0x22/255, alpha: 1)
                : UIColor(red: 0xCC/255, green: 0x00/255, blue: 0x00/255, alpha: 1)
        }
    }
    
    public var background: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0x12/255, green: 0x12/255, blue: 0x12/255, alpha: 1)
                : UIColor(red: 0xFF/255, green: 0xFF/255, blue: 0xFF/255, alpha: 1)
        }
    }
    
    public var surface: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0x1E/255, green: 0x1E/255, blue: 0x1E/255, alpha: 1)
                : UIColor(red: 0xFF/255, green: 0xFF/255, blue: 0xFF/255, alpha: 1)
        }
    }
    
    public var surfaceVariant: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0x2A/255, green: 0x2A/255, blue: 0x2A/255, alpha: 1)
                : UIColor(red: 0xF5/255, green: 0xF5/255, blue: 0xF5/255, alpha: 1)
        }
    }
    
    public var textPrimary: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0xF5/255, green: 0xF5/255, blue: 0xF5/255, alpha: 1)
                : UIColor(red: 0x00/255, green: 0x00/255, blue: 0x00/255, alpha: 1)
        }
    }
    
    public var textSecondary: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0xB0/255, green: 0xB0/255, blue: 0xB0/255, alpha: 1)
                : UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 1)
        }
    }
    
    public var textTertiary: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0x80/255, green: 0x80/255, blue: 0x80/255, alpha: 1)
                : UIColor(red: 0x66/255, green: 0x66/255, blue: 0x66/255, alpha: 1)
        }
    }
    
    public var error: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0xFF/255, green: 0x6B/255, blue: 0x6B/255, alpha: 1)
                : UIColor(red: 0xD0/255, green: 0x00/255, blue: 0x00/255, alpha: 1)
        }
    }
    
    public var success: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0x4C/255, green: 0xAF/255, blue: 0x50/255, alpha: 1)
                : UIColor(red: 0x2E/255, green: 0x7D/255, blue: 0x32/255, alpha: 1)
        }
    }
    
    public var warning: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0xFF/255, green: 0xA7/255, blue: 0x26/255, alpha: 1)
                : UIColor(red: 0xF5/255, green: 0x7C/255, blue: 0x00/255, alpha: 1)
        }
    }

    public var priceSale: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0xFF/255, green: 0x44/255, blue: 0x44/255, alpha: 1)
                : UIColor(red: 0xAA/255, green: 0x00/255, blue: 0x00/255, alpha: 1)
        }
    }
    
    public var priceStrikethrough: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0x80/255, green: 0x80/255, blue: 0x80/255, alpha: 1)
                : UIColor(red: 0x66/255, green: 0x66/255, blue: 0x66/255, alpha: 1)
        }
    }
    
    public var separator: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0x38/255, green: 0x38/255, blue: 0x38/255, alpha: 1)
                : UIColor(red: 0xE0/255, green: 0xE0/255, blue: 0xE0/255, alpha: 1)
        }
    }
    
    public var imagePlaceholder: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0x2A/255, green: 0x2A/255, blue: 0x2A/255, alpha: 1)
                : UIColor(red: 0xF5/255, green: 0xF5/255, blue: 0xF5/255, alpha: 1)
        }
    }
    
    public var buttonBackground: UIColor { primary }
    
    public var buttonText: UIColor { .white }
}


public struct TargetFonts: Fonts {
    
    public init() {}
    
    public var headline2: UIFont {
        scaledFont(name: "HelveticaNeue-Bold", size: 22, textStyle: .title1)
    }
    
    public var headline3: UIFont {
        scaledFont(name: "HelveticaNeue-Bold", size: 18, textStyle: .title2)
    }
    
    public var titleMedium: UIFont {
        scaledFont(name: "HelveticaNeue", size: 18, textStyle: .title2)
    }
    
    public var bodyMedium: UIFont {
        scaledFont(name: "HelveticaNeue", size: 16, textStyle: .callout)
    }
    
    public var bodySmall: UIFont {
        scaledFont(name: "HelveticaNeue", size: 14, textStyle: .subheadline)
    }
    
    public var priceMain: UIFont {
        scaledFont(name: "HelveticaNeue-Bold", size: 21, textStyle: .title3)
    }
    
    public var priceSecondary: UIFont {
        scaledFont(name: "HelveticaNeue", size: 12, textStyle: .caption1)
    }
    
    public var button: UIFont {
        scaledFont(name: "HelveticaNeue-Bold", size: 18, textStyle: .headline)
    }
    
    public var caption: UIFont {
        scaledFont(name: "HelveticaNeue", size: 12, textStyle: .caption1)
    }
    
    private func scaledFont(name: String, size: CGFloat, textStyle: UIFont.TextStyle) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            return UIFont.preferredFont(forTextStyle: textStyle)
        }
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
}
