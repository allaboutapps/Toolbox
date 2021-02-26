import UIKit

public extension UIView {
    
    func resolveSuperviewOf<T: UIView>(type: T.Type) -> T? {
        return superview as? T ?? superview?.resolveSuperviewOf(type: type)
    }
}
