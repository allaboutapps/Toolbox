
import UIKit

public extension UITableView {
    
    /// To be able to use this, please tag the CustomTableViewCell class with the "Reusable" protocol.
    /// *Usage*: self.register(cellType: CustomTableViewCell.self)
    final func register<T: UITableViewCell>(cellType: T.Type) {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    /// *Usage*: if let cell = tableView.dequeueReusableCell(for: indexPath) as CustomTableViewCell {}
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath,
                                                       cellType: T.Type = T.self) -> T {
        let reusableCell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier,
                                               for: indexPath)
        guard let cell = reusableCell as? T else {
            fatalError("Failed \(cellType.reuseIdentifier) for type \(cellType.self).")
        }
        return cell
    }
    
    /// To be able to use this, please tag the CustomTableViewCell class with the "Reusable" protocol.
    /// *Usage*: self.register(viewType: HeaderFooterView.self)
    final func register<T: UITableViewHeaderFooterView>(viewType: T.Type) {
        register(viewType.self, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
    }
    
    /// To be able to use this, please tag the CustomTableViewCell class with the "Reusable" protocol.
    final func dequeueReusableCell<T: UITableViewHeaderFooterView>(viewType: T.Type = T.self) -> T {
        let reusableView = dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier)
        
        guard let view = reusableView as? T else {
            fatalError("Failed \(viewType.reuseIdentifier) for type \(viewType.self).")
        }
        
        return view
    }
    
    /// To be able to use this, please tag the CustomTableViewCell class with the "Reusable" protocol.
    final func registerNib<T: UITableViewCell>(cellType: T.Type, bundle: Bundle = Bundle.main) {
        let nib = UINib(nibName: cellType.reuseIdentifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    /// To be able to use this, please tag the CustomTableViewCell class with the "Reusable" protocol.
    final func registerNib<T: UITableViewHeaderFooterView>(viewType: T.Type, bundle: Bundle = Bundle.main) {
        let nib = UINib(nibName: viewType.reuseIdentifier, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
    }
}
