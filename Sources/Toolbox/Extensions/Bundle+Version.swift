
import Foundation

public extension Bundle {
    var appVersion: String? {
        self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var semanticAppVersion: SemanticVersion? {
        appVersion.flatMap { SemanticVersion($0) }
    }

    static var mainAppVersion: String? {
        Bundle.main.appVersion
    }
}
