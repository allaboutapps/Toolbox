#if canImport(UIKit)

import UIKit

public extension UIEdgeInsets {
    init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
    
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    init(vertical: CGFloat) {
        self.init(top: vertical, left: .zero, bottom: vertical, right: .zero)
    }
    
    init(horizontal: CGFloat) {
        self.init(top: .zero, left: horizontal, bottom: .zero, right: horizontal)
    }
}

#endif
