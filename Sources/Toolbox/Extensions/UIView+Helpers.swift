
import UIKit

public protocol Nibable: UIView {
    static func load(from bundle: Bundle) -> Self?
}

public extension UIView {
    /// Allows to add multiple views at once.
    ///
    /// **Usage:** self.view.add(self.firstSubview, self.secondSubview, etc.).
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}

public extension UIView {
    /// Allows to create separator view like => width: 100%, height: 1.0, color: .darkGray
    class func createSeparatorView(width: CGFloat? = nil, height: CGFloat? = nil, color: UIColor = UIColor(white: 0.0, alpha: 0.1), priority: UILayoutPriority = .required) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color

        if let width = width {
            let widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
            widthConstraint.isActive = true
            widthConstraint.priority = priority
        }

        if let height = height {
            let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
            heightConstraint.isActive = true
            heightConstraint.priority = priority
        }

        return view
    }
}

extension UIView: Nibable {
    
    /// Tries to load a view from its nib if possible
    /// - Parameter bundle: The bundle from where to load the nib
    /// - Returns: Nil if there is no such nib
    public static func load(from bundle: Bundle = Bundle.main) -> Self? {
        return loadFromNib(type: self, from: bundle)
    }
    
    private static func loadFromNib<T>(type: T.Type, from bundle: Bundle) -> T? {
        return bundle.loadNibNamed("\(type)", owner: self, options: nil)?.first as? T
    }
}
