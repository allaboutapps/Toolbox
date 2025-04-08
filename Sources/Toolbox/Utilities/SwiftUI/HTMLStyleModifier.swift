import SwiftUI

/// A SwiftUI view modifier that applies custom HTML styles to its content.
///
/// `HTMLStyleModifier` allows you to customize the appearance of HTML elements within a view hierarchy.
/// It works by modifying the environment's `htmlStyles` value, which is used by `HTMLView` to style
/// HTML elements.
///
/// # Example
/// ```swift
/// // Apply custom styles to a view hierarchy
/// VStack {
///     HTMLView(htmlString: "<h1>Title</h1><p>Content</p>")
/// }
/// .htmlStyle([
///     "h1": .init(font: .largeTitle, color: .red),
///     "p": .init(font: .body, color: .blue)
/// ])
/// ```
struct HTMLStyleModifier: ViewModifier {
    let styles: [String: HTMLElementStyle]

    func body(content: Content) -> some View {
        content.transformEnvironment(\.htmlStyles) { existingStyles in
            // merge with existing styles, new styles take precedence
            existingStyles = existingStyles.merging(styles) { _, new in new }
        }
    }
}

private struct HTMLStylesKey: EnvironmentKey {
    static let defaultValue: [String: HTMLElementStyle] = HTMLElementStyle.defaultStyles
}

extension EnvironmentValues {
    var htmlStyles: [String: HTMLElementStyle] {
        get { self[HTMLStylesKey.self] }
        set { self[HTMLStylesKey.self] = newValue }
    }
}

/// This extension adds the `htmlStyle` modifier to all SwiftUI views, making it
/// easy to apply custom HTML styles to any view hierarchy containing `HTMLView`s.
///
/// # Example
/// ```swift
/// // Apply custom styles to a view
/// HTMLView(htmlString: "<h1>Title</h1>")
///     .htmlStyle([
///         "h1": .init(font: .largeTitle, color: .red)
///     ])
/// ```
public extension View {
    /// Applies custom HTML styles to the view and its children.
    ///
    /// - Parameter styles: A dictionary mapping HTML tag names to their corresponding styles
    /// - Returns: A view with the specified HTML styles applied
    func htmlStyle(_ styles: [String: HTMLElementStyle]) -> some View {
        modifier(HTMLStyleModifier(styles: styles))
    }
}
