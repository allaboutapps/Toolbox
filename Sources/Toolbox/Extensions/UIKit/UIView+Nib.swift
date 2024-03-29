#if canImport(UIKit)

import UIKit

// see http://stackoverflow.com/a/26326006/278288
public extension UIView {
    
    class func fromNib(_ nibNameOrNil: String? = nil, in bundle: Bundle = Bundle.main) -> Self {
        return fromNib(nibNameOrNil, type: self, in: bundle)
    }
    
    class func fromNib<T: UIView>(_ nibNameOrNil: String? = nil, type: T.Type, in bundle: Bundle = Bundle.main) -> T {
        let v: T? = fromNib(nibNameOrNil, type: T.self, in: bundle)
        return v!
    }
    
    class func fromNib<T: UIView>(_ nibNameOrNil: String? = nil, type: T.Type, in bundle: Bundle = Bundle.main) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = nibName
        }
        
        if let nibViews = bundle.loadNibNamed(name, owner: nil, options: nil) {
            for v in nibViews {
                if let tog = v as? T {
                    view = tog
                }
            }
            return view
        } else {
            return nil
        }
    }
    
    class var nibName: String {
        let name = "\(self)".components(separatedBy: ".").first ?? ""
        return name
    }
    
    class var nib: UINib? {
        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
    
    class func nib(in bundle: Bundle) -> UINib? {
        if let _ = bundle.path(forResource: nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
}

#endif
