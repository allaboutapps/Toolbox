
import Foundation

/// Usage:
/// let array = ["foo", "bar"]
/// array.remove(element: "foo")
/// array //=> ["bar"]
public extension Array where Element: Equatable {
    @discardableResult
    mutating func remove(element: Element) -> Index? {
        guard let index = firstIndex(of: element) else { return nil }
        remove(at: index)
        return index
    }

    @discardableResult
    mutating func remove(elements: [Element]) -> [Index] {
        return elements.compactMap { remove(element: $0) }
    }
}

/// Usage:
/// let array = [1, 2, 3, 3, 2, 1, 4]
/// array.unify() // [1, 2, 3, 4]
public extension Array where Element: Hashable {
    mutating func unify() {
        self = unified()
    }
}

public extension Collection where Element: Hashable {
    func unified() -> [Element] {
        return Array(Set(self))
    }
}
