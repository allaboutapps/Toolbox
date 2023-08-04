#if canImport(UIKit)

import UIKit

// MARK: - Coordinator

@MainActor
open class Coordinator: NSObject {
    public weak var parentCoordinator: Coordinator?
    
    public var childCoordinators = [Coordinator]()
    
    public let rootViewController: UIViewController
    var isPresented: Bool = false
    
    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        
        super.init()
    }
    
    func prepareForModalPresentation() {
        isPresented = true
        guard rootViewController.presentationController?.delegate == nil else { fatalError("Coordinator need to set the delegate - for handling UIAdaptivePresentationControllerDelegate look into the ReadMe ") }
        rootViewController.presentationController?.delegate = self
    }
    
    public func addChild(_ coordinator: Coordinator) {
        print("add child: \(String(describing: coordinator.self))")
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    public func removeChild(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            print("remove child: \(String(describing: coordinator.self))")
            let removedCoordinator = childCoordinators.remove(at: index)
            removedCoordinator.parentCoordinator = nil
        }
    }
    
    public func removeAllChildren() {
        for coordinator in childCoordinators {
            removeChild(coordinator)
        }
    }
    
    // MARK: - Present
    
    public func present(_ coordinator: Coordinator, animated: Bool, completion: (() -> Void)? = nil) {
        addChild(coordinator)
        coordinator.prepareForModalPresentation()
        rootViewController.present(coordinator.rootViewController, animated: animated, completion: completion)
    }
    
    public func dismissChildCoordinator(animated: Bool, completion: (() -> Void)? = nil) {
        guard let coordinator = childCoordinators.first(where: { $0.rootViewController.presentingViewController != nil })
        else {
            completion?()
            return
        }
        
        print("dismiss coordinator")
        
        coordinator.rootViewController.presentingViewController?.dismiss(animated: animated, completion: { [weak self] in
            self?.removeChild(coordinator)
            completion?()
        })
    }
    
    // MARK: - Debug
    
    public func debugStructure(level: Int = 0) -> String {
        let tabsRoot = String(repeating: "\t", count: level)
        let tabs = String(repeating: "\t", count: level + 1)
        
        var output = tabsRoot + "{\n"
        
        output += debugInfo(level: level)
        
        if let parentCoordinator = parentCoordinator {
            output += tabs + "- parent: \(parentCoordinator)\n"
        }
        
        if !childCoordinators.isEmpty {
            output += tabs + "- childs:\n"
            output += tabs + "[\n"
            output += childCoordinators
                .map { $0.debugStructure(level: level + 2) }
                .joined(separator: ",\n")
            output += "\n\(tabs)]\n"
        }
        output += tabsRoot + "}"
        return output
    }
    
    public func debugInfo(level: Int) -> String {
        var output = ""
        let tabs = String(repeating: "\t", count: level + 1)
        output += tabs + "* \(self)\n"
        return output
    }
    
    public func printRootDebugStructure() {
        if let parentCoordinator = parentCoordinator {
            parentCoordinator.printRootDebugStructure()
        } else {
            print(debugStructure())
        }
    }
    
    /// This is used to forward `UIAdaptivePresentationControllerDelegate` functions.
    /// Return here the object that should be responsible for the delegate callbacks
    /// E.g.: RootViewController or TopViewController of a NavigationController
    open var targetAdaptiveDelegate: UIAdaptivePresentationControllerDelegate? {
        guard let delegate = rootViewController as? UIAdaptivePresentationControllerDelegate else { return nil }
        return delegate
    }
    
    // MARK: - Start
    
    open func start() {}
    
    deinit {
        print("deinit coordinator: \(String(describing: self))")
    }
}

// MARK: - CoordinatorPresentationDelegate
extension Coordinator: UIAdaptivePresentationControllerDelegate {
    
    open func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let parentCoordinator = parentCoordinator {
            parentCoordinator.removeChild(self)
        }
        
        if let targetAdaptiveDelegate = targetAdaptiveDelegate {
            targetAdaptiveDelegate.presentationControllerDidDismiss?(presentationController)
        }
    }
    
    // MARK: Delegate Forwarding
    
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return targetAdaptiveDelegate
    }
    
    public override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        }
        
        return targetAdaptiveDelegate?.responds(to: aSelector) ?? false
    }
}

#endif
