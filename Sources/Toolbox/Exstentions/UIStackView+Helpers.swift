
import UIKit

@available(iOS 9.0, *)
public extension UIStackView {
    /// Allows to add multiple subviews to a UIStackView at once.
    ///
    /// **Usage:** self.stackView.addArrangedSubviews(self.firstSubview, self.secondSubview, etc.).
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach(addArrangedSubview)
    }

    /// Allows to remove all arrangedSubviews from UIStackView.
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }

        removedSubviews.forEach { $0.removeFromSuperview() }
    }
}
