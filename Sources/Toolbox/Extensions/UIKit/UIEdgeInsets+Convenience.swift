#if canImport(UIKit)

import UIKit

public extension UIEdgeInsets {
    init(vertical: CGFloat = .zero, horizontal: CGFloat = .zero) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    init(_ value: CGFloat) {
        self.init(vertical: value, horizontal: value)
    }
    
    init(
        left: CGFloat = .zero,
        top: CGFloat = .zero,
        right: CGFloat = .zero,
        bottom: CGFloat = .zero
    ) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
}

#endif
