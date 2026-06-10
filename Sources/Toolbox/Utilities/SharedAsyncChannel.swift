import AsyncAlgorithms
import Foundation

private final class IteratorRegistration<Element: Sendable>: @unchecked Sendable {
    private weak var parent: SharedAsyncChannel<Element>?
    private let id: UUID

    init(parent: SharedAsyncChannel<Element>, id: UUID) {
        self.parent = parent
        self.id = id
    }

    deinit {
        parent?.unregisterIterator(id: id)
    }
}

public final class SharedAsyncChannel<Element: Sendable>: AsyncSequence, @unchecked Sendable {
    public typealias Element = Element
    public typealias AsyncIterator = Iterator
    private let lock = NSRecursiveLock()
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
        let registration = IteratorRegistration(parent: self, id: id)
        return Iterator(
            innerIterator: channel.makeAsyncIterator(),
            parent: self,
            id: id,
            registration: registration
        )
    }

    fileprivate func unregisterIterator(id: UUID) {
        let channel = lock.withLock { () -> AsyncChannel<Element>? in
            let channel = storage[id]
            storage[id] = nil
            return channel
        }
        channel?.finish()
    }

    public struct Iterator: AsyncIteratorProtocol {
        var innerIterator: AsyncChannel<Element>.AsyncIterator
        let parent: SharedAsyncChannel<Element>
        let id: UUID
        private let registration: IteratorRegistration<Element>

        fileprivate init(
            innerIterator: AsyncChannel<Element>.AsyncIterator,
            parent: SharedAsyncChannel<Element>,
            id: UUID,
            registration: IteratorRegistration<Element>
        ) {
            self.innerIterator = innerIterator
            self.parent = parent
            self.id = id
            self.registration = registration
        }

        public mutating func next() async -> Element? {
            return await withTaskCancellationHandler {
                await innerIterator.next()
            } onCancel: { [parent, id] in
                parent.unregisterIterator(id: id)
            }
        }
    }
}
