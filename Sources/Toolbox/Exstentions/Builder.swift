
import Foundation

public protocol Builder {}

public extension Builder {
    func with(configure: (inout Self) -> Void) -> Self {
        var this = self
        configure(&this)
        return this
    }
}

extension NSObject: Builder {}
