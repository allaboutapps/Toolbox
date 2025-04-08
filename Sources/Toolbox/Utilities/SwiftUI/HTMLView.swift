import Foundation
import SwiftUI

public struct HTMLElementStyle {
    public var font: Font?
    public var color: Color?

    public static let defaultStyles: [String: HTMLElementStyle] = [
        "h1": .init(font: .largeTitle, color: .primary),
        "h2": .init(font: .title, color: .primary),
        "h3": .init(font: .title2, color: .primary),
        "h4": .init(font: .title3, color: .primary),
        "h5": .init(font: .headline, color: .primary),
        "h6": .init(font: .subheadline, color: .primary),
        "p": .init(font: .body, color: .primary),
        "li": .init(font: .body, color: .primary),
        "ol": .init(font: .body, color: .primary),
        "ul": .init(font: .body, color: .primary),
        "a": .init(font: .body, color: .blue),
    ]
}

/// A SwiftUI view that renders HTML content with customizable styling.
///
/// `HTMLView` provides a way to render HTML content in SwiftUI with support for common HTML elements
/// including headings, paragraphs, lists, links, and text formatting. It supports custom styling
/// through the `HTMLElementStyle` type and allows for custom handling of link taps.
///
/// # Example
/// ```swift
/// // Basic usage with HTML string
/// HTMLView(htmlString: "<h1>Hello World</h1><p>This is a paragraph</p>")
///
/// // With custom link handling
/// HTMLView(
///     htmlString: "<a href='https://example.com'>Click me</a>",
///     onLinkTap: { url in
///         // Handle link tap
///         print("Link tapped: \(url)")
///     }
/// )
///
/// // With custom tags
/// HTMLView(
///     htmlString: "<custom>Custom content</custom>",
///     customTags: ["custom"]
/// )
/// ```
public struct HTMLView: View {
    @Environment(\.htmlStyles) private var styles

    let element: HTMLElement
    let parentStyle: HTMLElementStyle?
    let onLinkTap: ((URL) -> Void)?

    /// Creates an HTML view with a parsed HTML element.
    ///
    /// - Parameters:
    ///   - element: The parsed HTML element to display
    ///   - parentStyle: Optional parent style to inherit from
    ///   - onLinkTap: Optional closure to handle link taps
    public init(
        element: HTMLElement,
        parentStyle: HTMLElementStyle? = nil,
        onLinkTap: ((URL) -> Void)? = nil
    ) {
        self.element = element
        self.parentStyle = parentStyle
        self.onLinkTap = onLinkTap
    }

    /// Creates an HTML view from an HTML string.
    ///
    /// - Parameters:
    ///   - htmlString: The HTML string to parse and display
    ///   - customTags: Array of custom HTML tags to support
    ///   - onLinkTap: Optional closure to handle link taps
    public init(
        htmlString: String,
        customTags: [String] = [],
        onLinkTap: ((URL) -> Void)? = nil
    ) {
        var parser = HTMLParser(html: htmlString, customTags: customTags)
        let element = parser.parse()
        self.init(element: element, onLinkTap: onLinkTap)
    }

    public var body: some View {
        let style = elementStyle(for: element)

        switch element {
        case let .html(children),
             let .body(children),
             let .head(children):
            VStack(alignment: .leading, spacing: 10) {
                ForEach(children.indices, id: \.self) { i in
                    HTMLView(element: children[i], parentStyle: style, onLinkTap: onLinkTap)
                }
            }

        case let .title(text):
            Text(text)
                .font(.headline)

        case .h1, .h2, .h3, .h4, .h5, .h6, .p:
            Text(inlineAttributedString(for: element))
                .font(style.font ?? parentStyle?.font ?? .body)
                .foregroundStyle(style.color ?? parentStyle?.color ?? .primary)
                .environment(\.openURL, OpenURLAction { url in
                    if let onLinkTap {
                        onLinkTap(url)
                    } else {
                        UIApplication.shared.open(url)
                    }
                    return .handled
                })

        case let .li(children):
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    let inlineContent = children.filter { element in
                        if case .ol = element { return false }
                        if case .ul = element { return false }
                        return true
                    }
                    if !inlineContent.isEmpty {
                        Text(inlineAttributedString(for: .li(children: inlineContent)))
                            .font(style.font ?? parentStyle?.font ?? .body)
                            .foregroundStyle(style.color ?? parentStyle?.color ?? .primary)
                    }

                    ForEach(children.indices, id: \.self) { i in
                        switch children[i] {
                        case .ol, .ul:
                            HTMLView(element: children[i], parentStyle: style, onLinkTap: onLinkTap)
                        default:
                            EmptyView()
                        }
                    }
                }
            }

        case let .a(href, text):
            Text(text)
                .font(style.font ?? parentStyle?.font ?? .body)
                .foregroundColor(style.color ?? parentStyle?.color ?? .blue)
                .underline(true, color: style.color ?? parentStyle?.color ?? .blue)
                .onTapGesture {
                    if let href = href, let url = URL(string: href) {
                        if let onLinkTap {
                            onLinkTap(url)
                        } else {
                            UIApplication.shared.open(url)
                        }
                    }
                }

        case let .ul(children):
            VStack(alignment: .leading) {
                ForEach(children.indices, id: \.self) { i in
                    HStack(alignment: .top) {
                        Text("•")
                            .font(style.font ?? parentStyle?.font ?? .body)
                            .foregroundStyle(style.color ?? parentStyle?.color ?? .primary)
                            .bold()
                        HTMLView(element: children[i], parentStyle: style, onLinkTap: onLinkTap)
                    }
                }
            }
            .padding(.leading, 20)

        case let .ol(children):
            VStack(alignment: .leading) {
                ForEach(children.indices, id: \.self) { i in
                    HStack(alignment: .top) {
                        Text("\(i + 1).").frame(minWidth: 18)
                            .font(style.font ?? parentStyle?.font ?? .body)
                            .foregroundStyle(style.color ?? parentStyle?.color ?? .primary)
                        HTMLView(element: children[i], parentStyle: style, onLinkTap: onLinkTap)
                    }
                }
            }
            .padding(.leading, 20)

        case let .text(text):
            Text(text)

        case .b, .i, .u:
            Text(inlineAttributedString(for: element))

        case let .customInline(tag, _):
            if let style = styles[tag] {
                Text(inlineAttributedString(for: element))
                    .font(style.font ?? parentStyle?.font ?? .body)
                    .foregroundStyle(style.color ?? parentStyle?.color ?? .primary)
            } else {
                Text(inlineAttributedString(for: element))
            }

        case let .unknown(tag, _):
            if let style = styles[tag] {
                Text(inlineAttributedString(for: element))
                    .font(style.font ?? parentStyle?.font ?? .body)
                    .foregroundStyle(style.color ?? parentStyle?.color ?? .primary)
            } else {
                Text(inlineAttributedString(for: element))
            }
        }
    }

    private func inlineAttributedString(for element: HTMLElement) -> AttributedString {
        var attributedString = AttributedString()
        let baseStyle = elementStyle(for: element)

        func processInlineElement(_ child: HTMLElement, currentStyle: HTMLElementStyle, parentStyle: HTMLElementStyle?) -> AttributedString {
            switch child {
            case let .text(text):
                var result = AttributedString(text)
                result.font = currentStyle.font ?? parentStyle?.font ?? .body
                result.foregroundColor = currentStyle.color ?? parentStyle?.color ?? .primary
                return result

            case let .a(href, text):
                var linkText = AttributedString(text)
                linkText.font = currentStyle.font ?? parentStyle?.font ?? .body
                linkText.foregroundColor = styles["a"]?.color ?? .blue
                linkText.underlineStyle = .single
                if let href = href, let url = URL(string: href) {
                    linkText.link = url
                }
                return linkText

            case let .b(children):
                var boldText = AttributedString()
                let boldStyle = HTMLElementStyle(
                    font: (currentStyle.font ?? parentStyle?.font ?? .body).bold(),
                    color: currentStyle.color ?? parentStyle?.color
                )
                for grandChild in children {
                    boldText.append(processInlineElement(grandChild, currentStyle: boldStyle, parentStyle: parentStyle))
                }
                return boldText

            case let .i(children):
                var italicText = AttributedString()
                let italicStyle = HTMLElementStyle(
                    font: (currentStyle.font ?? parentStyle?.font ?? .body).italic(),
                    color: currentStyle.color ?? parentStyle?.color
                )
                for grandChild in children {
                    italicText.append(processInlineElement(grandChild, currentStyle: italicStyle, parentStyle: parentStyle))
                }
                return italicText

            case let .u(children):
                var underlinedText = AttributedString()
                for grandChild in children {
                    var processedText = processInlineElement(grandChild, currentStyle: currentStyle, parentStyle: parentStyle)
                    processedText.underlineStyle = .single
                    underlinedText.append(processedText)
                }
                return underlinedText

            case let .customInline(tag, children):
                var customText = AttributedString()
                let customStyle = styles[tag] ?? baseStyle
                for grandChild in children {
                    customText.append(processInlineElement(grandChild, currentStyle: customStyle, parentStyle: currentStyle))
                }
                return customText

            default:
                var result = AttributedString(child.textContent)
                result.font = currentStyle.font ?? parentStyle?.font ?? .body
                result.foregroundColor = currentStyle.color ?? parentStyle?.color ?? .primary
                return result
            }
        }

        for child in element.inlineChildren {
            attributedString.append(processInlineElement(child, currentStyle: baseStyle, parentStyle: parentStyle))
        }

        return attributedString
    }

    private func elementStyle(for element: HTMLElement) -> HTMLElementStyle {
        let tagName = element.tagName ?? "p"
        return styles[tagName]
            ?? HTMLElementStyle.defaultStyles[tagName]
            ?? HTMLElementStyle.defaultStyles["p"]!
    }
}
