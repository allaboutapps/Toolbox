#if canImport(UIKit)

import UIKit

public struct Style {
    public let color: UIColor
    private let _font: UIFont

    public init(font: UIFont, color: UIColor) {
        _font = font
        self.color = color
    }

    public var font: UIFont {
        return _font.scaled
    }
}

public extension UIFont {
    var scaled: UIFont {
        return UIFontMetrics.default.scaledFont(for: self)
    }
}

// MARK: - Navigation bar stle

public struct NavigationBarStyle {
    public enum BackgroundStyle {
        case `default`
        case opaque
        case transparent
    }

    public let tintColor: UIColor?
    public let barTintColor: UIColor?
    public let backgroundStyle: BackgroundStyle?
    public let backgroundColor: UIColor?
    public let titleTextAttributes: [NSAttributedString.Key: Any]?
    public let largeTitleTextAttributes: [NSAttributedString.Key: Any]?
    public let buttonTitleAttributes: [NSAttributedString.Key: Any]?
    public let buttonDisabledAttributes: [NSAttributedString.Key: Any]?
    public let statusBarStyle: UIStatusBarStyle
    
    public init(
        tintColor: UIColor?, 
        barTintColor: UIColor?, 
        backgroundStyle: BackgroundStyle?, 
        backgroundColor: UIColor?, 
        titleTextAttributes: [NSAttributedString.Key : Any]?,
        largeTitleTextAttributes: [NSAttributedString.Key : Any]?, 
        buttonTitleAttributes: [NSAttributedString.Key : Any]?, 
        buttonDisabledAttributes: [NSAttributedString.Key : Any]?, 
        statusBarStyle: UIStatusBarStyle
    ) {
        self.tintColor = tintColor
        self.barTintColor = barTintColor
        self.backgroundStyle = backgroundStyle
        self.backgroundColor = backgroundColor
        self.titleTextAttributes = titleTextAttributes
        self.largeTitleTextAttributes = largeTitleTextAttributes
        self.buttonTitleAttributes = buttonTitleAttributes
        self.buttonDisabledAttributes = buttonDisabledAttributes
        self.statusBarStyle = statusBarStyle
    }
}

// MARK: - Helper

public extension UILabel {
    func setStyle(_ style: Style) {
        font = style.font
        textColor = style.color
    }
}

public extension UITextField {
    func setStyle(_ style: Style) {
        font = style.font
        textColor = style.color
    }
}

public extension UITextView {
    func setStyle(_ style: Style) {
        font = style.font
        textColor = style.color
    }
}

public extension String {
    func setStyle(_ style: Style, at subString: String, defaultStyle: Style) -> NSAttributedString {
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font: defaultStyle.font,
            .foregroundColor: defaultStyle.color,
        ]
        let heighlightAttributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .foregroundColor: style.color,
        ]

        let attributedString = NSMutableAttributedString(string: self, attributes: defaultAttributes)

        let range = (attributedString.string as NSString).range(of: subString)
        attributedString.addAttributes(heighlightAttributes, range: range)

        return attributedString
    }
}

public extension NavigationBarStyle {
    func toAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()

        switch backgroundStyle {
        case .default:
            appearance.configureWithDefaultBackground()
        case .opaque:
            appearance.configureWithOpaqueBackground()
        case .transparent:
            appearance.configureWithTransparentBackground()
        case .none:
            break
        }

        if let backgroundColor = backgroundColor {
            appearance.backgroundColor = backgroundColor
        }

        if let titleTextAttributes = titleTextAttributes {
            appearance.titleTextAttributes = titleTextAttributes
        }

        if let largeTitleTextAttributes = largeTitleTextAttributes {
            appearance.largeTitleTextAttributes = largeTitleTextAttributes
        }

        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)

        if let buttonTitleAttributes = buttonTitleAttributes {
            barButtonItemAppearance.normal.titleTextAttributes = buttonTitleAttributes
            barButtonItemAppearance.highlighted.titleTextAttributes = buttonTitleAttributes
            barButtonItemAppearance.focused.titleTextAttributes = buttonTitleAttributes
        }

        if let buttonDisabledAttributes = buttonDisabledAttributes ?? buttonTitleAttributes {
            barButtonItemAppearance.disabled.titleTextAttributes = buttonDisabledAttributes
        }

        appearance.buttonAppearance = barButtonItemAppearance
        appearance.backButtonAppearance = barButtonItemAppearance
        appearance.doneButtonAppearance = barButtonItemAppearance

        return appearance
    }
}

public extension UINavigationBar {

    // preferred to use appearance to style navigation bars
    func setStyle(_ style: NavigationBarStyle) {
        if let tintColor = style.tintColor {
            self.tintColor = tintColor
        }
        if let barTintColor = style.barTintColor {
            self.barTintColor = barTintColor
        }
        if let titleTextAttributes = style.titleTextAttributes {
            self.titleTextAttributes = titleTextAttributes
        }
        if let largeTitleTextAttributes = style.largeTitleTextAttributes {
            self.largeTitleTextAttributes = largeTitleTextAttributes
        }
    }
}

#endif
