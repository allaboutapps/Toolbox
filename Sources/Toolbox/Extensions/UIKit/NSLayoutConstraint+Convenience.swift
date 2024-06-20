#if canImport(UIKit)

import UIKit

public extension NSLayoutConstraint {

    func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = self
        constraint.priority = priority
        return constraint
    }
    
    func constant(_ constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self
        constraint.constant = constant
        return constraint
    }
}

#endif
