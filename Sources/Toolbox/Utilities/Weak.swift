import Foundation

// MARK: - WeakBox

public final class WeakBox<A: AnyObject> {
    weak var unbox: A?
    
    public init(_ value: A) {
        unbox = value
    }
}

// MARK: - WeakArray

public struct WeakArray<Element: AnyObject> {
    private var items: [WeakBox<Element>] = []
    
    public init(_ elements: [Element]) {
        items = elements.map { WeakBox($0) }
    }
    
    public mutating func append(_ element: Element) {
        items.append(WeakBox(element))
    }
    
    public mutating func remove(at index: Int) {
        items.remove(at: index)
    }
    
    public mutating func removeAll() {
        items.removeAll()
    }
}

// MARK: Collection

extension WeakArray: Collection {
    public var startIndex: Int { return items.startIndex }
    public var endIndex: Int { return items.endIndex }
    
    public subscript(_ index: Int) -> Element? {
        return items[index].unbox
    }
    
    public func index(after idx: Int) -> Int {
        return items.index(after: idx)
    }
}
