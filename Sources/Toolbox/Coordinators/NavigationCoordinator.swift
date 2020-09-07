import UIKit

open class NavigationCoordinator: Coordinator {
    
    public var pushedViewControllers: WeakArray<UIViewController>
    public let navigationController: UINavigationController
    
    // NavigationCoordinator can only have one child coordinator
    var childCoordinator: Coordinator? {
        return childCoordinators.first
    }
    
    public init(navigationController: UINavigationController = UINavigationController()) {
        self.pushedViewControllers = WeakArray([])
        self.navigationController = navigationController
        
        self.navigationController.interactivePopGestureRecognizer?.delegate = nil
                
        super.init(rootViewController: navigationController)
        
        if self.navigationController.delegate == nil {
            self.navigationController.delegate = self
        }
    }
    
    public func removePushedViewController(_ viewController: UIViewController) {
        if let index = pushedViewControllers.firstIndex(of: viewController) {
            pushedViewControllers.remove(at: index)
            print("remove: \(pushedViewControllers.count) from \(self)")
            if let parentCoordinator = parentCoordinator as? NavigationCoordinator, pushedViewControllers.isEmpty {
                parentCoordinator.removeChild(self)
                navigationController.delegate = parentCoordinator
            }
        }
    }
    
    // MARK: ViewController
    
    public func push(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
        print("append: \(pushedViewControllers.count)")
        
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    @objc public func popViewController(animated: Bool) {
        if let viewController = navigationController.popViewController(animated: animated) {
            removePushedViewController(viewController)
        }
    }
    
    public func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        navigationController.present(viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        viewController.presentingViewController?.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: Coordinator
    
    public func push(_ coordinator: Coordinator, animated: Bool) {
        addChild(coordinator)
        if let navigationCoordinator = coordinator as? NavigationCoordinator {
            navigationController.delegate = navigationCoordinator // hand delegate to last coordinator
        }
    }
    
    public func popCoordinator(animated: Bool) {
        if let lastViewController = pushedViewControllers[pushedViewControllers.count - 1] {
            navigationController.popToViewController(lastViewController, animated: animated)
        }
        if let childCoordinator = childCoordinator {
            removeChild(childCoordinator)
        }
        navigationController.delegate = self
    }
    
    // MARK: Reset
    
    public func popToRoot(animated: Bool) {
        removeAllChildren()
        
        if let first = pushedViewControllers[0] {
            pushedViewControllers = WeakArray([first])
        }
        
        navigationController.dismiss(animated: animated, completion: nil)
        navigationController.popToRootViewController(animated: false)
    }

    // MARK: - Debug
    
    override public func debugInfo(level: Int = 0) -> String {
        var output = ""
        let tabs = String(repeating: "\t", count: level + 1)
        output += tabs + "* \(self)\n"
        if navigationController.delegate === self {
            output += tabs + "- is delegate\n"
        }
        let viewControllers = pushedViewControllers
            .compactMap { $0 }
            .map { String(describing: $0) }
            .joined(separator: ", ")
        output += tabs + "- VCs: [ \(viewControllers) ]\n"
        return output
    }
}

// MARK: UINavigationControllerDelegate

extension NavigationCoordinator: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // ensure the view controller is popping
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            navigationController.viewControllers.contains(fromViewController) == false
            else { return }
        
        removePushedViewController(fromViewController)
    }
}

// MARK: UIGestureRecognizerDelegate

extension NavigationCoordinator: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension NavigationCoordinator {
}
