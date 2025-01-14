import AsyncAlgorithms
import Foundation

public final class SharedAsyncChannel<Element: Sendable>: AsyncSequence, @unchecked Sendable {
    public typealias Element = Element
    public typealias AsyncIterator = Iterator
    private let lock = NSLock()
    private var storage = [UUID: AsyncChannel<Element>]()

    public init() {}
    
    public func send(_ element: Element) async {
        for channel in storage.values {
            await channel.send(element)
        }
    }

    public func makeAsyncIterator() -> Iterator {
        let channel = AsyncChannel<Element>()
        let id = UUID()
        lock.lock()
        storage[id] = channel
        lock.unlock()
        return Iterator(innerIterator: channel.makeAsyncIterator(), parent: self, id: id)
    }

    private func gotCancelled(id: UUID) {
        lock.lock()
        storage[id] = nil
        lock.unlock()
    }

    public struct Iterator: AsyncIteratorProtocol {
        var innerIterator: AsyncChannel<Element>.AsyncIterator
        let parent: SharedAsyncChannel<Element>
        let id: UUID

        public mutating func next() async -> Element? {
            return await withTaskCancellationHandler {
                await innerIterator.next()
            } onCancel: { [parent, id] in
                parent.gotCancelled(id: id)
            }
        }
    }
}
