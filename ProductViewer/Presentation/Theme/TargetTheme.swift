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

    // Brand Colors
    public var primary: UIColor { .primary }
    public var primaryVariant: UIColor { .primaryVariant }
    public var secondary: UIColor { .secondary }

    // Background Colors
    public var background: UIColor { .background }
    public var surface: UIColor { .surface }
    public var surfaceVariant: UIColor { .surfaceVariant }

    // Text Colors
    public var textPrimary: UIColor { .textPrimary }
    public var textSecondary: UIColor { .textSecondary }
    public var textTertiary: UIColor { .textTertiary }
    public var textOnPrimary: UIColor { .textOnPrimary }

    // Semantic Colors
    public var error: UIColor { .error }
    public var success: UIColor { .success }
    public var warning: UIColor { .warning }

    // Price Colors
    public var priceRegular: UIColor { .priceRegular }
    public var priceSale: UIColor { .priceSale }

    // UI Element Colors
    public var separator: UIColor { .separator }
    public var border: UIColor { .border }
    public var imagePlaceholder: UIColor { .imagePlaceholder }
    public var buttonBackground: UIColor { .buttonBackground }
    public var buttonText: UIColor { .buttonText }

    // Navigation Colors
    public var navigationBar: UIColor { .navigationBar }
    public var navigationBarText: UIColor { .navigationBarText }
    public var navigationBarTint: UIColor { .primary }
}

public struct TargetFonts: Fonts {

    public init() {}

    // Headlines
    public var headline1: UIFont { .headline1 }
    public var headline2: UIFont { .headline2 }
    public var headline3: UIFont { .headline3 }

    // Body Text
    public var bodyLarge: UIFont { .bodyLarge }
    public var bodyMedium: UIFont { .bodyMedium }
    public var bodySmall: UIFont { .bodySmall }

    // Labels
    public var labelLarge: UIFont { .labelLarge }
    public var labelMedium: UIFont { .labelMedium }
    public var labelSmall: UIFont { .labelSmall }

    // Special
    public var priceMain: UIFont { .priceMain }
    public var priceSecondary: UIFont { .priceSecondary }
    public var button: UIFont { .button }
    public var caption: UIFont { .caption }
    public var captionBold: UIFont { .captionBold }
}
