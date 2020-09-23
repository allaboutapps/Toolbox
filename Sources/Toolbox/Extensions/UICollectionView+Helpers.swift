
import UIKit

public extension UICollectionView {
    
    /// To be able to use this, please tag the CustomCollectionViewCell class with the "Reusable" protocol.
    /// *Usage*: self.register(cellType: CustomCollectionViewCell.self)
    final func register<T: UICollectionViewCell>(cellType: T.Type) {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(supplementaryType: T.Type,
                                               ofKind elementKind: String) where T: Reusable {
        register(supplementaryType.self,
                 forSupplementaryViewOfKind: elementKind,
                 withReuseIdentifier: supplementaryType.reuseIdentifier)
    }
    
    /// To be able to use this, please tag the CustomCollectionViewCell class with the "Reusable" protocol.
    /// *Usage*: if let cell = collectionView.dequeueReusableCell(for: indexPath) as CustomCollectionViewCell {}
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath,
                                                      cellType: T.Type) -> T {
        let reusableCell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier,
                                               for: indexPath)
        guard let cell = reusableCell as? T else {
            fatalError("Failed \(cellType.reuseIdentifier) for type \(cellType.self).")
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String,
                                                                       for indexPath: IndexPath,
                                                                       viewType: T.Type) -> T
        where T: Reusable {
        let view = dequeueReusableSupplementaryView(ofKind: elementKind,
                                                    withReuseIdentifier: viewType.reuseIdentifier,
                                                    for: indexPath)
        guard let reusableCell = view as? T else {
            fatalError("Failed to dequeue a supplementary view with identifier \(viewType.reuseIdentifier)")
        }
        return reusableCell
    }
}
