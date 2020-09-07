import UIKit

// MARK: - Coordinator

open class Coordinator: NSObject {
    
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators = [Coordinator]()
    var presentationDelegate: CoordinatorPresentationDelegate?
    
    let rootViewController: UIViewController

    public init(rootViewController: UIViewController = UIViewController()) {
        self.rootViewController = rootViewController
    }
    
    func addChild(_ coordinator: Coordinator) {
        print("add child: \(String(describing: coordinator.self))")
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    func removeChild(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            print("remove child: \(String(describing: coordinator.self))")
            let removedCoordinator = childCoordinators.remove(at: index)
            removedCoordinator.parentCoordinator = nil
        }
    }
    
    func removeAllChildren() {
        for coordinator in childCoordinators {
            removeChild(coordinator)
        }
    }
    
    // MARK: - Present
    
    func present(_ coordinator: Coordinator, animated: Bool, completion: (() -> Void)? = nil) {
        let delegate = CoordinatorPresentationDelegate(for: coordinator)
        delegate.didDismiss = { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.removeChild(coordinator)
        }
        coordinator.presentationDelegate = delegate
        
        addChild(coordinator)
        rootViewController.present(coordinator.rootViewController, animated: animated, completion: completion)
    }
    
    func dismissChildCoordinator(animated: Bool, completion: (() -> Void)? = nil) {
        guard let coordinator = childCoordinators.first(where: { $0.rootViewController.presentingViewController != nil }) else { return }
 
        print("dismiss coordinator")
        
        coordinator.rootViewController.presentingViewController?.dismiss(animated: animated, completion: { [weak self] in
            self?.removeChild(coordinator)
            completion?()
        })
    }
    
    // MARK: - Debug
    
    func debugStructure(level: Int = 0) -> String {
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
    
    func debugInfo(level: Int) -> String {
        var output = ""
        let tabs = String(repeating: "\t", count: level + 1)
        output += tabs + "* \(self)\n"
        return output
    }
    
    func printRootDebugStructure() {
        if let parentCoordinator = parentCoordinator {
            parentCoordinator.printRootDebugStructure()
        } else {
            print(debugStructure())
        }
    }
    
    deinit {
        print("deinit coordinator: \(String(describing: self))")
    }
}

// MARK: - CoordinatorPresentationDelegate

class CoordinatorPresentationDelegate: NSObject, UIAdaptivePresentationControllerDelegate {
    
    weak var coordinator: Coordinator?
    var previousDelegate: UIAdaptivePresentationControllerDelegate?
    
    var willDismiss: (() -> Void)?
    var didDismiss: (() -> Void)?
    var didAttemptToDismiss: (() -> Void)?
    
    init(for coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
        
        previousDelegate = coordinator.rootViewController.presentationController?.delegate
        coordinator.rootViewController.presentationController?.delegate = self
    }

    // MARK: UIAdaptivePresentationControllerDelegate
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("presentationControllerWillDismiss")
        willDismiss?()
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("presentationControllerDidDismiss")
        didDismiss?()
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        print("presentationControllerDidAttemptToDismiss")
        didAttemptToDismiss?()
    }
    
    // MARK: Delegate Forwarding
    
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return previousDelegate
    }
    
    public override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        }
        
        return previousDelegate?.responds(to: aSelector) ?? false
    }
    
    deinit {
        print("deinit CoordinatorPresentationDelegate")
    }
}
