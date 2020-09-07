
import Foundation

private class BundleClass {}

extension Bundle {
    public static var current: Bundle {
        return Bundle(for: BundleClass.self)
    }
}
