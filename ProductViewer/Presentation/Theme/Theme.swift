//
//  Theme.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import UIKit
import SwiftUI

// MARK: - Theme Protocol
public protocol Theme {
    var colors: Colors { get }
    var fonts: Fonts { get }
}

// MARK: - Color Palette Protocol
public protocol Colors {
    var primary: UIColor { get }
    var primaryVariant: UIColor { get }
    var secondary: UIColor { get }
    
    var background: UIColor { get }
    var surface: UIColor { get }
    var surfaceVariant: UIColor { get }
    
    var textPrimary: UIColor { get }
    var textSecondary: UIColor { get }
    var textTertiary: UIColor { get }
    var textOnPrimary: UIColor { get }

    var error: UIColor { get }
    var success: UIColor { get }
    var warning: UIColor { get }

    var priceRegular: UIColor { get }
    var priceSale: UIColor { get }

    var separator: UIColor { get }
    var border: UIColor { get }
    var imagePlaceholder: UIColor { get }
    var buttonBackground: UIColor { get }
    var buttonText: UIColor { get }

    var navigationBar: UIColor { get }
    var navigationBarTint: UIColor { get }
}

public protocol Fonts {
    var headline1: UIFont { get }
    var headline2: UIFont { get }
    var headline3: UIFont { get }
    
    var bodyLarge: UIFont { get }
    var bodyMedium: UIFont { get }
    var bodySmall: UIFont { get }
    
    var labelLarge: UIFont { get }
    var labelMedium: UIFont { get }
    var labelSmall: UIFont { get }

    var priceMain: UIFont { get }
    var priceSecondary: UIFont { get }
    var button: UIFont { get }
    var caption: UIFont { get }
    var captionBold: UIFont { get }
}

public protocol ListViewThemeable {
    var cellBackgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    var imagePlaceholderColor: UIColor { get }
    var titleFont: UIFont { get }
    var titleColor: UIColor { get }
    var priceFont: UIFont { get }
    var salePriceColor: UIColor { get }
    var captionFont: UIFont { get }
    var captionColor: UIColor { get }
    var successColor: UIColor { get }
    var warningColor: UIColor { get }
    var errorColor: UIColor { get }
    var primaryColor: UIColor { get }
    var regularPriceFont : UIFont { get }
    var regularPriceColor : UIColor { get }
}

public protocol DetailViewThemeable {
    var backgroundColor: UIColor { get }
    var surfaceColor: UIColor { get }
    var surfaceVariantColor: UIColor { get }
    var imagePlaceholderColor: UIColor { get }
    var titleFont: UIFont { get }
    var titleColor: UIColor { get }
    var priceFont: UIFont { get }
    var priceColor: UIColor { get }
    var bodyFont: UIFont { get }
    var bodyColor: UIColor { get }
    var captionFont: UIFont { get }
    var captionColor: UIColor { get }
    var headlineFont: UIFont { get }
    var headlineColor: UIColor { get }
    var buttonFont: UIFont { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTextColor: UIColor { get }
    var primaryColor: UIColor { get }
    var successColor: UIColor { get }
    var warningColor: UIColor { get }
    var errorColor: UIColor { get }
    var regularPriceFont : UIFont { get }
    var regularPriceColor : UIColor { get }
}

public protocol ContentUnavailableWrapperThemeable {
    var backgroundColor: UIColor { get }
    var imageColor: UIColor { get }
    var titleFont: UIFont { get }
    var titleColor: UIColor { get }
    var descriptionFont: UIFont { get }
    var descriptionColor: UIColor { get }
    var buttonFont: UIFont { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTextColor: UIColor { get }
    var buttonTintColor: UIColor { get }
}

public protocol NavigationThemeable {
    var barTintColor: UIColor { get }
}

// MARK: - Theme Implementations

public struct ListViewTheme: ListViewThemeable {

    private let theme: Theme

    public init(theme: Theme = ThemeManager.shared.currentTheme) {
        self.theme = theme
    }

    public var cellBackgroundColor: UIColor { theme.colors.surface }
    public var separatorColor: UIColor { theme.colors.separator }
    public var imagePlaceholderColor: UIColor { theme.colors.imagePlaceholder }
    public var titleFont: UIFont { theme.fonts.bodySmall }
    public var titleColor: UIColor { theme.colors.textPrimary }
    public var priceFont: UIFont { theme.fonts.priceMain }
    public var salePriceColor: UIColor { theme.colors.priceSale }
    public var regularPriceFont : UIFont { theme.fonts.priceSecondary }
    public var regularPriceColor : UIColor { theme.colors.textTertiary }
    public var captionFont: UIFont { theme.fonts.caption }
    public var captionColor: UIColor { theme.colors.textTertiary }
    public var successColor: UIColor { theme.colors.success }
    public var warningColor: UIColor { theme.colors.warning }
    public var errorColor: UIColor { theme.colors.error }
    public var primaryColor: UIColor { theme.colors.primary }
}

public struct DetailViewTheme: DetailViewThemeable {
    private let theme: Theme

    public init(theme: Theme = ThemeManager.shared.currentTheme) {
        self.theme = theme
    }

    public var backgroundColor: UIColor { theme.colors.background }
    public var surfaceColor: UIColor { theme.colors.surface }
    public var surfaceVariantColor: UIColor { theme.colors.surfaceVariant }
    public var imagePlaceholderColor: UIColor { theme.colors.imagePlaceholder }
    public var titleFont: UIFont { theme.fonts.bodyLarge }
    public var titleColor: UIColor { theme.colors.textPrimary }
    public var priceFont: UIFont { theme.fonts.priceMain }
    public var priceColor: UIColor { theme.colors.priceSale }
    public var regularPriceFont : UIFont { theme.fonts.priceSecondary }
    public var regularPriceColor : UIColor { theme.colors.textTertiary }
    public var bodyFont: UIFont { theme.fonts.bodyMedium }
    public var bodyColor: UIColor { theme.colors.textSecondary }
    public var captionFont: UIFont { theme.fonts.caption }
    public var captionColor: UIColor { theme.colors.textTertiary }
    public var headlineFont: UIFont { theme.fonts.headline2 }
    public var headlineColor: UIColor { theme.colors.textPrimary }
    public var buttonFont: UIFont { theme.fonts.button }
    public var buttonBackgroundColor: UIColor { theme.colors.buttonBackground }
    public var buttonTextColor: UIColor { theme.colors.buttonText }
    public var primaryColor: UIColor { theme.colors.primary }
    public var successColor: UIColor { theme.colors.success }
    public var warningColor: UIColor { theme.colors.warning }
    public var errorColor: UIColor { theme.colors.error }
}

public struct ContentUnavailableWrapperTheme: ContentUnavailableWrapperThemeable {
    private let theme: Theme

    public init(theme: Theme = ThemeManager.shared.currentTheme) {
        self.theme = theme
    }

    public var backgroundColor: UIColor { theme.colors.background }
    public var imageColor: UIColor { theme.colors.textTertiary }
    public var titleFont: UIFont { theme.fonts.headline1 }
    public var titleColor: UIColor { theme.colors.textPrimary }
    public var descriptionFont: UIFont { theme.fonts.bodyMedium }
    public var descriptionColor: UIColor { theme.colors.textSecondary }
    public var buttonFont: UIFont { theme.fonts.button }
    public var buttonBackgroundColor: UIColor { theme.colors.buttonBackground }
    public var buttonTextColor: UIColor { theme.colors.buttonText }
    public var buttonTintColor: UIColor { theme.colors.primary }
}

public struct NavigationTheme: NavigationThemeable {
    private let theme: Theme

    public init(theme: Theme = ThemeManager.shared.currentTheme) {
        self.theme = theme
    }

    public var barTintColor: UIColor { theme.colors.navigationBarTint }
}
