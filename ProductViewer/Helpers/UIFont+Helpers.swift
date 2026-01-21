import UIKit
import SwiftUI

extension UIFont {

    private static func scaled(size: CGFloat, textStyle: TextStyle, weight: UIFont.Weight) -> UIFont {
        let base = UIFont.systemFont(ofSize: size, weight: weight)
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: base)
    }

    // Headlines
    static var headline1: UIFont { .scaled(size: 22, textStyle: .title1, weight: .bold) }
    static var headline2: UIFont { .scaled(size: 18, textStyle: .title2, weight: .bold) }
    static var headline3: UIFont { .scaled(size: 16, textStyle: .title3, weight: .bold) }

    // Body Text
    static var bodyLarge: UIFont { .scaled(size: 18, textStyle: .body, weight: .regular) }
    static var bodyMedium: UIFont { .scaled(size: 16, textStyle: .callout, weight: .regular) }
    static var bodySmall: UIFont { .scaled(size: 14, textStyle: .subheadline, weight: .regular) }

    // Labels
    static var labelLarge: UIFont { .scaled(size: 18, textStyle: .title2, weight: .bold) }
    static var labelMedium: UIFont { .scaled(size: 16, textStyle: .title3, weight: .bold) }
    static var labelSmall: UIFont { .scaled(size: 14, textStyle: .headline, weight: .bold) }

    // Special
    static var priceMain: UIFont { .scaled(size: 21, textStyle: .title3, weight: .bold) }
    static var priceSecondary: UIFont { .scaled(size: 12, textStyle: .caption1, weight: .regular) }
    static var button: UIFont { .scaled(size: 18, textStyle: .headline, weight: .bold) }
    static var caption: UIFont { .scaled(size: 12, textStyle: .caption1, weight: .regular) }
    static var captionBold: UIFont { .scaled(size: 12, textStyle: .caption1, weight: .bold) }

    // Legacy aliases for backward compatibility
    static var headline: UIFont { headline1 }
    static var title: UIFont { labelLarge }
}

extension UIFont {
    var font: Font { Font(self) }
}
