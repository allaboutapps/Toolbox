
import Foundation

public extension Array where Element: Equatable {
    /// Usage:
    /// var array = ["foo", "bar"]
    /// array.remove(element: "foo")
    /// array //=> ["bar"]
    @discardableResult
    mutating func remove(element: Element) -> Index? {
        guard let index = firstIndex(of: element) else { return nil }
        remove(at: index)
        return index
    }

    /// Usage:
    /// var array = ["foo", "bar"]
    /// array.remove(element: "foo")
    /// array //=> ["bar"]
    @discardableResult
    mutating func remove(elements: [Element]) -> [Index] {
        return elements.compactMap { remove(element: $0) }
    }
}

public extension Array where Element: Hashable {
    /// Usage:
    /// var array = [1, 2, 3, 3, 2, 1, 4]
    /// array.unify() // [1, 2, 3, 4]
    mutating func unify() {
        self = unified()
    }
}

public extension Collection where Element: Hashable {
    /// Usage:
    /// var array = [1, 2, 3, 3, 2, 1, 4]
    /// array.unify() // [1, 2, 3, 4]
    func unified() -> [Element] {
        return Array(Set(self))
    }
}

extension Array {
    /// Usage:
    /// let array = [1, 2, 3, 4]
    /// array[safeIndex: 6] => nil
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
