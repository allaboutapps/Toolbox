
import Foundation

public protocol Builder {}

public extension Builder {
    /// Usage:
    /// let imageView = UIImageView().with {
    ///     $0.image = UIImage(named: "foo")
    /// }
    func with(configure: (inout Self) -> Void) -> Self {
        var this = self
        configure(&this)
        return this
    }
}

extension NSObject: Builder {}
