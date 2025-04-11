import Foundation

public enum HTMLElement {
    case html(children: [HTMLElement])
    case head(children: [HTMLElement])
    case body(children: [HTMLElement])
    case title(text: String)
    case h1(children: [HTMLElement])
    case h2(children: [HTMLElement])
    case h3(children: [HTMLElement])
    case h4(children: [HTMLElement])
    case h5(children: [HTMLElement])
    case h6(children: [HTMLElement])
    case p(children: [HTMLElement])
    case a(href: String?, text: String)
    case ul(children: [HTMLElement])
    case ol(children: [HTMLElement])
    case li(children: [HTMLElement])
    case b(children: [HTMLElement])
    case i(children: [HTMLElement])
    case u(children: [HTMLElement])
    case text(String)
    case customInline(tag: String, children: [HTMLElement])
    case unknown(tag: String, children: [HTMLElement])

    // Helper function to extract inline children for paragraphs and headings
    var inlineChildren: [HTMLElement] {
        switch self {
        case let .h1(children), let .h2(children), let .h3(children), let .h4(children), let .h5(children), let .h6(children),
             let .p(children), let .li(children), let .b(children),
             let .i(children), let .u(children), let .customInline(_, children):
            return children
        default:
            return []
        }
    }

    public var tagName: String? {
        switch self {
        case .html: return "html"
        case .head: return "head"
        case .body: return "body"
        case .title: return "title"
        case .h1: return "h1"
        case .h2: return "h2"
        case .h3: return "h3"
        case .h4: return "h4"
        case .h5: return "h5"
        case .h6: return "h6"
        case .p: return "p"
        case .a: return "a"
        case .ul: return "ul"
        case .ol: return "ol"
        case .li: return "li"
        case .b: return "b"
        case .i: return "i"
        case .u: return "u"
        case .text: return nil
        case let .customInline(tag, _): return tag
        case let .unknown(tag, _): return tag
        }
    }
}

/// A parser that converts HTML strings into a structured `HTMLElement` tree.
///
/// `HTMLParser` provides functionality to parse HTML strings into a structured tree of `HTMLElement`s
/// that can be rendered by `HTMLView`. It supports common HTML elements and can be extended with
/// custom tags.
///
/// # Example
/// ```swift
/// // Basic parsing
/// let parser = HTMLParser(html: "<h1>Title</h1><p>Content</p>")
/// let element = parser.parse()
///
/// // With custom tags
/// let parser = HTMLParser(
///     html: "<custom>Custom content</custom>",
///     customTags: ["custom"]
/// )
/// let element = parser.parse()
/// ```
public struct HTMLParser {
    private var text: String
    private var index: String.Index
    private var openTags: [(tag: String, startIndex: Int, children: [HTMLElement])] = []
    private let customTags: Set<String>

    // Add a helper property to check if we're inside a list
    private var isInsideList: Bool {
        openTags.contains { $0.tag.lowercased() == "ul" || $0.tag.lowercased() == "ol" }
    }

    /// Creates a new HTML parser instance.
    ///
    /// - Parameters:
    ///   - html: The HTML string to parse
    ///   - customTags: Array of custom HTML tags to support
    public init(html: String, customTags: [String] = []) {
        text = HTMLParser.minifyHTML(html)
        index = text.startIndex
        self.customTags = Set(customTags)
    }

    /// Minifies HTML by removing unnecessary whitespace and normalizing the content.
    ///
    /// This method:
    /// - Normalizes all newlines and multiple spaces to single spaces
    /// - Removes spaces between tags
    /// - Trims leading and trailing whitespace
    ///
    /// - Parameter html: The HTML string to minify
    /// - Returns: A minified version of the HTML string
    public static func minifyHTML(_ html: String) -> String {
        // First normalize all newlines and multiple spaces to single spaces
        var minified = html.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)

        // Remove spaces only between tags (><), but not between text and tags
        let regex = try! NSRegularExpression(pattern: ">\\s+<", options: [])
        minified = regex.stringByReplacingMatches(
            in: minified,
            options: [],
            range: NSRange(location: 0, length: minified.utf16.count),
            withTemplate: "><"
        )

        // Trim leading and trailing whitespace
        minified = minified.trimmingCharacters(in: .whitespacesAndNewlines)

        return minified
    }

    /// Parses the HTML string and returns the root element.
    ///
    /// This method processes the entire HTML string and returns a structured tree of `HTMLElement`s.
    /// The root element is typically a `.body` element containing all the parsed content.
    ///
    /// - Returns: The root `HTMLElement` of the parsed HTML tree
    public mutating func parse() -> HTMLElement {
        // Parse the entire text at once
        var elements: [HTMLElement] = []

        while !isAtEnd {
            if peek() == "<" {
                skipWhitespace()
            }
            if isAtEnd { break }
            let element = parseElement()
            if !isEmptyElement(element) {
                elements.append(element)
            }
        }

        return .body(children: elements)
    }

    private func isEmptyElement(_ element: HTMLElement) -> Bool {
        if case let .text(content) = element, content.isEmpty {
            return true
        }
        return false
    }

    private mutating func parseElement() -> HTMLElement {
        // If we're at the end or don't see a tag, treat it as text
        guard !isAtEnd, peek() == "<" else {
            let text = parseText()
            if case let .text(content) = text, !content.isEmpty {
                // Only add text to parent if it's not just whitespace within a list
                if !openTags.isEmpty {
                    let isJustWhitespace = content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    let lastTag = openTags[openTags.count - 1].tag.lowercased()
                    if !(isJustWhitespace && (lastTag == "ul" || lastTag == "ol")) {
                        openTags[openTags.count - 1].children.append(text)
                    }
                    return .text("")
                }
                return text
            }
            return .text("")
        }

        advance() // Skip '<'

        // Check for closing tag
        if peek() == "/" {
            advance()
            let closingTag = parseTagName()
            skipUntil(">")
            advance()

            return handleClosingTag(closingTag)
        }

        // Parse tag name
        let tagName = parseTagName()

        // Handle br tags immediately
        if tagName.lowercased() == "br" || tagName.lowercased() == "br/" {
            skipUntil(">")
            advance() // Skip '>'

            // Add line break to the last open tag if any
            if !openTags.isEmpty {
                openTags[openTags.count - 1].children.append(.text("\n"))
                return .text("")
            }
            return .text("\n")
        }

        // Parse attributes (currently only supporting href)
        var href: String? = nil
        skipWhitespace()
        while peek() != ">" && !isAtEnd {
            let attrName = parseAttributeName()
            if attrName == "href" {
                skipWhitespace()
                if peek() == "=" {
                    advance()
                    skipWhitespace()
                    href = parseAttributeValue()
                }
            }
            skipWhitespace()
        }

        guard !isAtEnd else { return .text("") }
        advance() // Skip '>'

        // For anchor tags, create and return immediately
        if tagName.lowercased() == "a" {
            openTags.append((tagName, openTags.count, []))

            while !isAtEnd {
                if peek() == "<" && text[text.index(after: index)] == "/" {
                    advance() // Skip '<'
                    advance() // Skip '/'
                    let closingTagName = parseTagName()
                    skipUntil(">")
                    advance() // Skip '>'

                    if closingTagName.lowercased() == "a" {
                        let children = openTags.removeLast().children
                        let anchorElement = HTMLElement.a(href: href, text: children.map { $0.textContent }.joined())
                        if !openTags.isEmpty {
                            openTags[openTags.count - 1].children.append(anchorElement)
                            return .text("")
                        }
                        return anchorElement
                    } else {
                        print("Error: Mismatched closing tag. Expected </a> but found </\(closingTagName)>")
                        return .text("")
                    }
                }

                let element = parseElement()
                if !isEmptyElement(element) {
                    openTags[openTags.count - 1].children.append(element)
                }
            }
        }

        // Add new tag to the stack
        openTags.append((tagName, openTags.count, []))

        // Parse children
        while !isAtEnd {
            if peek() == "<" && text[text.index(after: index)] == "/" {
                advance() // Skip '<'
                advance() // Skip '/'
                let closingTagName = parseTagName()
                skipUntil(">")
                advance() // Skip '>'

                if closingTagName.lowercased() == tagName.lowercased() {
                    let (_, _, children) = openTags.removeLast()
                    let element = createElement(tag: tagName, children: children)
                    if !openTags.isEmpty {
                        openTags[openTags.count - 1].children.append(element)
                        return .text("")
                    }
                    return element
                } else {
                    print("Error: Mismatched closing tag. Expected </\(tagName)> but found </\(closingTagName)>")
                    return .text("")
                }
            }

            let element = parseElement()
            if !isEmptyElement(element) {
                if !openTags.isEmpty {
                    openTags[openTags.count - 1].children.append(element)
                } else {
                    return element
                }
            }
        }

        // If we reach the end without finding a closing tag
        if !openTags.isEmpty {
            let (tagName, _, children) = openTags.removeLast()
            print("Error: Missing closing tag for <\(tagName)>")
            let element = createElement(tag: tagName, children: children)
            if !openTags.isEmpty {
                openTags[openTags.count - 1].children.append(element)
                return .text("")
            }
            return element
        }

        return .text("")
    }

    private mutating func handleClosingTag(_ closingTag: String) -> HTMLElement {
        // Find the matching opening tag
        if openTags.lastIndex(where: { $0.tag.lowercased() == closingTag.lowercased() }) != nil {
            // Create the element for the matching tag
            let (tagName, _, children) = openTags.removeLast()
            let element = createElement(tag: tagName, children: children)

            // Add to parent if exists or return
            if !openTags.isEmpty {
                openTags[openTags.count - 1].children.append(element)
                return .text("")
            }
            return element
        } else {
            // Closing tag doesn't match any open tag, print error
            print("Error: Unexpected closing tag </\(closingTag)> with no matching opening tag")
            return .text("")
        }
    }

    private func isInlineElement(_ element: HTMLElement) -> Bool {
        switch element {
        case .text, .a, .b, .i, .u:
            return true
        default:
            return false
        }
    }

    private func isHTMLElement(_ element: HTMLElement) -> Bool {
        if case .html = element {
            return true
        }
        return false
    }

    private mutating func parseText() -> HTMLElement {
        var content = ""
        while !isAtEnd && peek() != "<" {
            content.append(advance())
        }
        return .text(content)
    }

    private mutating func parseTagName() -> String {
        var name = ""
        while !isAtEnd && !CharacterSet.whitespaces.contains(Unicode.Scalar(String(peek()))!) && peek() != ">" {
            name.append(advance())
        }
        return name
    }

    private mutating func parseAttributeName() -> String {
        var name = ""
        while !isAtEnd && !CharacterSet.whitespaces.contains(Unicode.Scalar(String(peek()))!) && peek() != "=" && peek() != ">" {
            name.append(advance())
        }
        return name
    }

    private mutating func parseAttributeValue() -> String {
        guard peek() == "\"" || peek() == "'" else { return "" }
        let quote = advance()
        var value = ""
        while !isAtEnd && peek() != quote {
            value.append(advance())
        }
        if !isAtEnd { advance() } // Skip closing quote
        return value
    }

    private mutating func skipWhitespace() {
        while !isAtEnd, CharacterSet.whitespacesAndNewlines.contains(Unicode.Scalar(String(peek()))!) {
            advance()
        }
    }

    private mutating func skipUntil(_ char: Character) {
        while !isAtEnd, peek() != char {
            advance()
        }
    }

    private var isAtEnd: Bool {
        index >= text.endIndex
    }

    private func peek() -> Character {
        guard !isAtEnd else { return "\0" }
        return text[index]
    }

    @discardableResult
    private mutating func advance() -> Character {
        let current = text[index]
        index = text.index(after: index)
        return current
    }

    private func createElement(tag: String, children: [HTMLElement]) -> HTMLElement {
        switch tag.lowercased() {
        case "html": return .html(children: children)
        case "head": return .head(children: children)
        case "body": return .body(children: children)
        case "title": return .title(text: children.first?.textContent ?? "")
        case "h1": return .h1(children: children)
        case "h2": return .h2(children: children)
        case "h3": return .h3(children: children)
        case "h4": return .h4(children: children)
        case "h5": return .h5(children: children)
        case "h6": return .h6(children: children)
        case "p": return .p(children: children)
        case "a": return .a(href: nil, text: children.first?.textContent ?? "")
        case "ul": return .ul(children: children)
        case "ol": return .ol(children: children)
        case "li":
            // Only create li element if inside a list, otherwise just return the children
            return isInsideList ? .li(children: children) : .body(children: children)
        case "b": return .b(children: children)
        case "i": return .i(children: children)
        case "u": return .u(children: children)
        default:
            // For unknown tags, check if they should be treated as custom inline tags
            if customTags.contains(tag.lowercased()) {
                return .customInline(tag: tag, children: children)
            }
            // For other unhandled tags, just return their children
            return children.count == 1 ? children[0] : .body(children: children)
        }
    }
}

extension HTMLElement {
    var textContent: String {
        switch self {
        case let .text(text):
            return text
        case let .html(children),
             let .head(children),
             let .body(children),
             let .h1(children),
             let .h2(children),
             let .h3(children),
             let .h4(children),
             let .h5(children),
             let .h6(children),
             let .p(children),
             let .ul(children),
             let .ol(children),
             let .li(children),
             let .b(children),
             let .i(children),
             let .u(children),
             let .customInline(_, children),
             let .unknown(_, children):
            return children.map { $0.textContent }.joined(separator: "")
        case let .title(text):
            return text
        case let .a(_, text):
            return text
        }
    }
}
