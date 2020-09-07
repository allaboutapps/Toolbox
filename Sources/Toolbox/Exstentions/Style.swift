
import UIKit

@available(iOS 11, *)
public struct Style {
    public let color: UIColor
    private let _font: UIFont

    public init(font: UIFont, color: UIColor) {
        self._font = font
        self.color = color
    }

    public var font: UIFont {
        return _font.scaled
    }
}

@available(iOS 11, *)
public extension UIFont {
    var scaled: UIFont {
        return UIFontMetrics.default.scaledFont(for: self)
    }
}

// MARK: - Navigation bar stle

public struct NavigationBarStyle {
    public let tintColor: UIColor?
    public let barTintColor: UIColor?
    public let titleTextAttributes: [NSAttributedString.Key: Any]?
    public let largeTitleTextAttributes: [NSAttributedString.Key: Any]?
    public let statusBarStyle: UIStatusBarStyle
}

@available(iOS 11, *)
public extension UINavigationBar {
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

// MARK: - Helper

@available(iOS 11, *)
public extension UILabel {
    func setStyle(_ style: Style) {
        font = style.font
        textColor = style.color
    }
}

@available(iOS 11, *)
public extension UITextField {
    func setStyle(_ style: Style) {
        font = style.font
        textColor = style.color
    }
}

@available(iOS 11, *)
public extension UITextView {
    func setStyle(_ style: Style) {
        font = style.font
        textColor = style.color
    }
}

@available(iOS 11, *)
public extension String {
    func setStyle(_ style: Style, at subString: String, defaultStyle: Style) -> NSAttributedString {
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font: defaultStyle.font,
            .foregroundColor: defaultStyle.color
        ]
        let heighlightAttributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .foregroundColor: style.color
        ]

        let attributedString = NSMutableAttributedString(string: self, attributes: defaultAttributes)

        let range = (attributedString.string as NSString).range(of: subString)
        attributedString.addAttributes(heighlightAttributes, range: range)

        return attributedString
    }
}
