
import UIKit

public extension String {
    /// return true if the string is nil, empty, empty space, tab, newline or return

    var isBlank: Bool {
        return allSatisfy { $0.isWhitespace }
    }
}

public extension Optional where Wrapped == String {
    /// return true if the string is optional, nil, empty, empty space, tab, newline or return

    var isBlank: Bool {
        return self?.isBlank ?? true
    }
}

public extension String {
    func toIntOrNil() -> Int? {
        Int(self)
    }

    var isInt: Bool {
        return Int(self) != nil
    }
}

public extension String {
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }
}

public extension String {
    /// Substring: var string = "0123456789"
    /// string[0...5] //=> "012345"
    subscript(bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    /// Substring: var string = "0123456789"
    /// string[..<5] //=> "012345"
    subscript(bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    subscript(bounds: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex..<end])
    }

    subscript(bounds: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex...end])
    }

    subscript(bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }
}
