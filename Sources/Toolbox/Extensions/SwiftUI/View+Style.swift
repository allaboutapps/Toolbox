import Foundation
import SwiftUI

#if canImport(UIKit)

public struct StyleModifier: ViewModifier {

    public let style: Style

    public func body(content: Content) -> some View {
        content
            .font(Font(style.font))
            .foregroundColor(Color(style.color))
    }
}

public extension View {

    func styled(using style: Style) -> some View {
        modifier(StyleModifier(style: style))
    }
}

#endif
