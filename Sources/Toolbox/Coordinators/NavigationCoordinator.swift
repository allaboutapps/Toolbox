#if canImport(UIKit)

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
        
        super.init(rootViewController: navigationController)
        
        if self.navigationController.delegate == nil {
            self.navigationController.delegate = self
        }
    }
    
    open func removePushedViewController(_ viewController: UIViewController) {
        if let index = pushedViewControllers.firstIndex(of: viewController) {
            pushedViewControllers.remove(at: index)
            print("remove: \(pushedViewControllers.count) from \(self)")
            if let parentCoordinator = parentCoordinator as? NavigationCoordinator, pushedViewControllers.isEmpty {
                parentCoordinator.removeChild(self)
                navigationController.delegate = parentCoordinator
                if isPresented {
                    navigationController.presentationController?.delegate = parentCoordinator
                }
            }
        }
    }
    
    // MARK: ViewController
    
    open func push(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
        print("append: \(pushedViewControllers.count)")
        
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    @objc open func popViewController(animated: Bool) {
        if let viewController = navigationController.popViewController(animated: animated) {
            removePushedViewController(viewController)
        }
    }
    
    public func popToViewController(_ viewController: UIViewController, animated: Bool) {
        guard let poppedViewControllers = navigationController.popToViewController(viewController, animated: animated) else { return }
        
        for vc in poppedViewControllers {
            removePushedViewController(vc)
        }
    }
    
    public func popToViewControllerOfType<T: UIViewController>(_ type: T.Type, animated: Bool, willPopToViewController: ((T) -> Void)? = nil) {
        guard let viewController = pushedViewControllers.first(where: { $0 is T }) as? T else { return }
        willPopToViewController?(viewController)
        popToViewController(viewController, animated: animated)
    }
    
    public func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        navigationController.present(viewController, animated: animated, completion: completion)
    }
    
    public func dismiss(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        viewController.presentingViewController?.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: Coordinator
    
    public func push(_ coordinator: NavigationCoordinator, animated: Bool) {
        assert(coordinator.navigationController == navigationController, "Navigation Coordinator should only be pushed on the same UINavigationController! Hand over existing UINavigationController in init!")
        addChild(coordinator)
        navigationController.delegate = coordinator // hand delegate to last coordinator
        coordinator.isPresented = isPresented
        if isPresented {
            navigationController.presentationController?.delegate = coordinator
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
    
    public override func debugInfo(level: Int = 0) -> String {
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
    
    open override var targetAdaptiveDelegate: UIAdaptivePresentationControllerDelegate? {
        guard let delegate = navigationController.topViewController as? UIAdaptivePresentationControllerDelegate else { return nil }
        return delegate
    }
}

// MARK: UINavigationControllerDelegate

extension NavigationCoordinator: UINavigationControllerDelegate {
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // see https://stackoverflow.com/questions/36503224/ios-app-freezes-on-pushviewcontroller
        navigationController.interactivePopGestureRecognizer?.isEnabled = navigationController.viewControllers.count > 1
        
        // ensure the view controller is popping
        if let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), navigationController.viewControllers.contains(fromViewController) == false {
            removePushedViewController(fromViewController)
        }
    }
}

// MARK: UIGestureRecognizerDelegate

extension NavigationCoordinator: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension NavigationCoordinator {}

#endif
