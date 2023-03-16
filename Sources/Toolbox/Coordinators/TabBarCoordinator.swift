#if canImport(UIKit)

import UIKit

@MainActor
open class TabBarCoordinator: Coordinator {
    public let tabBarController: UITabBarController
    
    public init(tabBarController: UITabBarController? = nil) {
        self.tabBarController = tabBarController ?? UITabBarController()
        super.init(rootViewController: tabBarController!)
        self.tabBarController.delegate = self
    }
    
    // MARK: - Debug
    
    public override func debugInfo(level: Int = 0) -> String {
        var output = ""
        let tabs = String(repeating: "\t", count: level + 1)
        output += tabs + "* \(self)\n"
        if tabBarController.selectedIndex < childCoordinators.count {
            output += tabs + "- selected coordinator: \(childCoordinators[tabBarController.selectedIndex])\n"
        } else {
            output += tabs + "- selected index: \(tabBarController.selectedIndex)\n"
        }
        return output
    }
    
    public func reset() {
        removeAllChildren()
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {}

#endif
