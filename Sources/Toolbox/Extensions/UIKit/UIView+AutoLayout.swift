#if canImport(UIKit)

import UIKit

public extension UIView {
    
    func animateConstraints(withDuration duration: TimeInterval, delay: TimeInterval = 0.0, animations: () -> Void) {
        animateConstraints(withDuration: duration, delay: delay, animations: animations, completion: nil)
    }
    
    func animateConstraints(withDuration duration: TimeInterval, delay: TimeInterval = 0.0, animations: () -> Void, completion: ((Bool) -> Void)?) {
        self.layoutIfNeeded()
        animations()
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions(rawValue: 0), animations: { () -> Void in
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
    func animateConstraints(withDuration duration: TimeInterval, delay: TimeInterval = 0.0, options: UIView.AnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
        self.layoutIfNeeded()
        animations()
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { () -> Void in
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
    @discardableResult func withConstraints(_ closure: (_ view: UIView) -> [NSLayoutConstraint]) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(closure(self))
        return self
    }
    
    func alignLeading(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return leadingAnchor.constraint(equalTo: anchorView(view).leadingAnchor, constant: constant)
    }
    
    func alignTrailing(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return trailingAnchor.constraint(equalTo: anchorView(view).trailingAnchor, constant: constant)
    }
    
    func alignLeft(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return leftAnchor.constraint(equalTo: anchorView(view).leftAnchor, constant: constant)
    }
    
    func alignRight(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return rightAnchor.constraint(equalTo: anchorView(view).rightAnchor, constant: constant)
    }
    
    func alignTop(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return topAnchor.constraint(equalTo: anchorView(view).topAnchor, constant: constant)
    }
    
    func alignBottom(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return bottomAnchor.constraint(equalTo: anchorView(view).bottomAnchor, constant: constant)
    }
    
    func alignCenterX(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return centerXAnchor.constraint(equalTo: anchorView(view).centerXAnchor, constant: constant)
    }
    
    func alignCenterY(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return centerYAnchor.constraint(equalTo: anchorView(view).centerYAnchor, constant: constant)
    }
    
    func alignCenter(_ view: UIView? = nil) -> [NSLayoutConstraint] {
        return [
            alignCenterX(view),
            alignCenterY(view),
        ]
    }
    
    func alignEdges(_ view: UIView? = nil, insets: UIEdgeInsets = UIEdgeInsets.init()) -> [NSLayoutConstraint] {
        return [
            alignLeft(view, constant: insets.left),
            alignRight(view, constant: -insets.right),
            alignTop(view, constant: insets.top),
            alignBottom(view, constant: -insets.bottom)
        ]
    }
    
    func constraintWidth(_ width: CGFloat) -> NSLayoutConstraint {
        return widthAnchor.constraint(equalToConstant: width)
    }
    
    func constraintHeight(_ height: CGFloat) -> NSLayoutConstraint {
        return heightAnchor.constraint(equalToConstant: height)
    }
    
    func constraintSize(_ size: CGSize) -> [NSLayoutConstraint] {
        return [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
    }
    
    private func anchorView(_ view: UIView?) -> UIView {
        return view ?? superview!
    }
}

public extension Array where Element: NSLayoutConstraint {
    
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func priority(_ priority: UILayoutPriority) -> [NSLayoutConstraint] {
        for constraint in self {
            constraint.priority = priority
        }
        
        return self
    }
}

public extension UIView {
    
    /// Adds `self` to `view` as a subview and applies constraints to all edges
    /// - Parameter view: The superview to which the view should be added as a subview
    /// - Parameter offset: The offset that should be applied to all edges of the subview
    func pin(to view: UIView, offset: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset.left),
            topAnchor.constraint(equalTo: view.topAnchor, constant: offset.top),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: offset.right),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: offset.bottom)
        ])
    }
    
    /// Adds `view` to `self` as a subview and applies constraints to all edges
    /// - Parameter view: The subview that should be added to the superview
    /// - Parameter offset: The offset that should be applied to all edges of the subview
    func wrap(view: UIView, offset: UIEdgeInsets = .zero) {
        view.pin(to: self, offset: offset)
    }
}

#endif
