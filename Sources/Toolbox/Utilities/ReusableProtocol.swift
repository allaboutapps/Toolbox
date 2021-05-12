#if canImport(UIKit)

import UIKit

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UICollectionReusableView: Reusable {}
extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}

#endif
