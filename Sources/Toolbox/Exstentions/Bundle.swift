
import Foundation

private class BundleClass {}

public extension Bundle {
    static var current: Bundle {
        return Bundle(for: BundleClass.self)
    }
}

public extension Bundle {
    var appVersion: String? {
        self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var mainAppVersion: String? {
        Bundle.main.appVersion
    }
}
