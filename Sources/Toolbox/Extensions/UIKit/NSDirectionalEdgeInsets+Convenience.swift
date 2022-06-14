#if canImport(UIKit)

import UIKit

public extension NSDirectionalEdgeInsets {
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    init(_ value: CGFloat) {
        self.init(vertical: value, horizontal: value)
    }
    
    init(vertical: CGFloat) {
        self.init(vertical: vertical, horizontal: .zero)
    }
    
    init(horizontal: CGFloat) {
        self.init(vertical: .zero, horizontal: horizontal)
    }
}

#endif
