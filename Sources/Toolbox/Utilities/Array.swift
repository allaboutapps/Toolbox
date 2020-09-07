
import Foundation

public extension Array where Element: Equatable {
    /// Usage:
    /// let array = ["foo", "bar"]
    /// array.remove(element: "foo")
    /// array //=> ["bar"]
    @discardableResult
    mutating func remove(element: Element) -> Index? {
        guard let index = firstIndex(of: element) else { return nil }
        remove(at: index)
        return index
    }

    /// Usage:
    /// let array = ["foo", "bar"]
    /// array.remove(element: "foo")
    /// array //=> ["bar"]
    @discardableResult
    mutating func remove(elements: [Element]) -> [Index] {
        return elements.compactMap { remove(element: $0) }
    }
}

public extension Array where Element: Hashable {
    /// Usage:
    /// let array = [1, 2, 3, 3, 2, 1, 4]
    /// array.unify() // [1, 2, 3, 4]
    mutating func unify() {
        self = unified()
    }
}

public extension Collection where Element: Hashable {
    /// Usage:
    /// let array = [1, 2, 3, 3, 2, 1, 4]
    /// array.unify() // [1, 2, 3, 4]
    func unified() -> [Element] {
        return Array(Set(self))
    }
}
