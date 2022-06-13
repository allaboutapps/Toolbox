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
    
    // Layout guide
    
    func alignLeading(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        return leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: constant)
    }
    
    func alignTrailing(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        return trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: constant)
    }
    
    func alignLeft(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        return leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: constant)
    }
    
    func alignRight(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        return rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: constant)
    }
    
    func alignTop(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        return topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: constant)
    }
    
    func alignBottom(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        return bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: constant)
    }
    
    func alignEdges(_ layoutGuide: UILayoutGuide,
                    edgeInsets: UIEdgeInsets) -> [NSLayoutConstraint] {
        return [
            alignLeft(layoutGuide, constant: edgeInsets.left),
            alignRight(layoutGuide, constant: -edgeInsets.right),
            alignTop(layoutGuide, constant: edgeInsets.top),
            alignBottom(layoutGuide, constant: -edgeInsets.bottom)
        ]
    }
    
    func alignEdges(_ layoutGuide: UILayoutGuide,
                    directionalEdgeInsets: NSDirectionalEdgeInsets) -> [NSLayoutConstraint] {
        return [
            alignLeading(layoutGuide, constant: directionalEdgeInsets.leading),
            alignTrailing(layoutGuide, constant: -directionalEdgeInsets.trailing),
            alignTop(layoutGuide, constant: directionalEdgeInsets.top),
            alignBottom(layoutGuide, constant: -directionalEdgeInsets.bottom)
        ]
    }
    
    // View
    
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
    
    func alignVertically(_ view: UIView? = nil, topInset: CGFloat = 0, bottomInset: CGFloat = 0) -> [NSLayoutConstraint] {
        return [
            alignTop(view, constant: topInset),
            alignBottom(view, constant: bottomInset)
        ]
    }
    
    func alignHorizontally(_ view: UIView? = nil, leadingInset: CGFloat = 0, trailingInset: CGFloat = 0) -> [NSLayoutConstraint] {
        return [
            alignLeading(view, constant: leadingInset),
            alignTrailing(view, constant: trailingInset)
        ]
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
    
    func alignEdges(_ view: UIView? = nil,
                    edgeInsets: UIEdgeInsets) -> [NSLayoutConstraint] {
        return [
            alignLeft(view, constant: edgeInsets.left),
            alignRight(view, constant: -edgeInsets.right),
            alignTop(view, constant: edgeInsets.top),
            alignBottom(view, constant: -edgeInsets.bottom)
        ]
    }
    
    func alignEdges(_ view: UIView? = nil,
                    directionalEdgeInsets: NSDirectionalEdgeInsets) -> [NSLayoutConstraint] {
        return [
            alignLeading(view, constant: directionalEdgeInsets.leading),
            alignTrailing(view, constant: -directionalEdgeInsets.trailing),
            alignTop(view, constant: directionalEdgeInsets.top),
            alignBottom(view, constant: -directionalEdgeInsets.bottom)
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
            constraintWidth(size.width),
            constraintHeight(size.height)
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
    /// - Parameter offset: The `UIEdgeInsets` that should be applied to all edges of the subview
    func pin(to view: UIView, edgeInsets: UIEdgeInsets) {
        view.addSubview(self)
        
        self.withConstraints { view in
            view.alignEdges(edgeInsets: edgeInsets)
        }
    }
    
    /// Adds `self` to `view` as a subview and applies constraints to all edges
    /// - Parameter view: The superview to which the view should be added as a subview
    /// - Parameter directionalEdgeInsets: The `NSDirectionalEdgeInsets` that should be applied to all edges of the subview
    func pin(to view: UIView, directionalEdgeInsets: NSDirectionalEdgeInsets) {
        view.addSubview(self)
        
        self.withConstraints { view in
            view.alignEdges(directionalEdgeInsets: directionalEdgeInsets)
        }
    }
    
    /// Adds `view` to `self` as a subview and applies constraints to all edges
    /// - Parameter view: The subview that should be added to the superview
    /// - Parameter edgeInsets: The `UIEdgeInsets` insets that should be applied to all edges of the subview
    func wrap(view: UIView, edgeInsets: UIEdgeInsets) {
        view.pin(to: self, edgeInsets: edgeInsets)
    }
    
    /// Adds `view` to `self` as a subview and applies constraints to all edges
    /// - Parameter view: The subview that should be added to the superview
    /// - Parameter directionalEdgeInsets: The `NSDirectionalEdgeInsets` that should be applied to all edges of the subview
    func wrap(view: UIView, directionalEdgeInsets: NSDirectionalEdgeInsets) {
        view.pin(to: self, directionalEdgeInsets: directionalEdgeInsets)
    }
}

#endif
