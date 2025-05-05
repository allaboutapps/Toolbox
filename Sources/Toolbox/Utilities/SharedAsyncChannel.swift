import AsyncAlgorithms
import Foundation

public final class SharedAsyncChannel<Element: Sendable>: AsyncSequence, @unchecked Sendable {
    public typealias Element = Element
    public typealias AsyncIterator = Iterator
    private let lock = NSLock()
    private var storage = [UUID: AsyncChannel<Element>]()

    public init() {}

    public func send(_ element: Element) async {
        let channels = lock.withLock { storage }
        for (_, channel) in channels {
            await channel.send(element)
        }
    }

    public func makeAsyncIterator() -> Iterator {
        let channel = AsyncChannel<Element>()
        let id = UUID()
        lock.withLock { storage[id] = channel }
        return Iterator(innerIterator: channel.makeAsyncIterator(), parent: self, id: id)
    }

    private func gotCancelled(id: UUID) {
        lock.withLock { storage[id] = nil }
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
