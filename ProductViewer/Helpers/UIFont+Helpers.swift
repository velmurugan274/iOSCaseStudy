//
//  Copyright © 2022 Target. All rights reserved.
//
import UIKit
import SwiftUI

extension UIFont {

    static func scaled(name: String, size: CGFloat, textStyle: TextStyle) -> UIFont {
        let base = UIFont(name: name, size: size)
            ?? UIFont.preferredFont(forTextStyle: textStyle)
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: base)
    }

    // Headlines
    static var headline1: UIFont { .scaled(name: "HelveticaNeue-Bold", size: 22, textStyle: .title1) }
    static var headline2: UIFont { .scaled(name: "HelveticaNeue-Bold", size: 18, textStyle: .title2) }
    static var headline3: UIFont { .scaled(name: "HelveticaNeue-Bold", size: 16, textStyle: .title3) }

    // Body Text
    static var bodyLarge: UIFont { .scaled(name: "HelveticaNeue", size: 18, textStyle: .body) }
    static var bodyMedium: UIFont { .scaled(name: "HelveticaNeue", size: 16, textStyle: .callout) }
    static var bodySmall: UIFont { .scaled(name: "HelveticaNeue", size: 14, textStyle: .subheadline) }

    // Labels
    static var labelLarge: UIFont { .scaled(name: "HelveticaNeue-Bold", size: 18, textStyle: .title2) }
    static var labelMedium: UIFont { .scaled(name: "HelveticaNeue-Bold", size: 16, textStyle: .title3) }
    static var labelSmall: UIFont { .scaled(name: "HelveticaNeue-Bold", size: 14, textStyle: .headline) }

    // Special
    static var priceMain: UIFont { .scaled(name: "HelveticaNeue-Bold", size: 21, textStyle: .title3) }
    static var priceSecondary: UIFont { .scaled(name: "HelveticaNeue", size: 12, textStyle: .caption1) }
    static var button: UIFont { .scaled(name: "HelveticaNeue-Bold", size: 18, textStyle: .headline) }
    static var caption: UIFont { .scaled(name: "HelveticaNeue", size: 12, textStyle: .caption1) }
    static var captionBold: UIFont { .scaled(name: "HelveticaNeue-Bold", size: 12, textStyle: .caption1) }

    // Legacy aliases for backward compatibility
    static var headline: UIFont { headline1 }
    static var title: UIFont { labelLarge }
}


extension UIFont {
    var font: Font {
        return Font(self)
    }
}

