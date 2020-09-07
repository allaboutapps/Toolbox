
import UIKit

public extension String {
    /// return true if the string is nil, empty, empty space, tab, newline or return

    var isBlank: Bool {
        return allSatisfy { $0.isWhitespace }
    }
}

// MARK: - checking isBlank on a string even if optional

public extension Optional where Wrapped == String {
    /// return true if the string is optional, nil, empty, empty space, tab, newline or return

    var isBlank: Bool {
        return self?.isBlank ?? true
    }
}
