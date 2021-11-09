//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

#if canImport(UIKit)
import class UIKit.UIViewController
import protocol UIKit.UIAdaptivePresentationControllerDelegate

open class BasePresentingCoordinator: BaseCoordinator, PresentingCoordinator {
    
    // MARK: - Private Properties
    
    open private(set) var rootViewController: UIViewController
    
    // MARK: - Inits
    
    /// Creates a new instance with given root view controller.
    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    // MARK: - Methods
    
    open func childCoordinator(with rootViewController: UIViewController) -> Coordinator? {
        children.first {
            guard let presentingCoordinator = $0 as? PresentingCoordinator else { return false }
            return presentingCoordinator.rootViewController === rootViewController
        }
    }
    
    /// Removes child coordinator with root view controller if the coordinator contains.
    open func removeCoordinator(with rootViewController: UIViewController) {
        guard let coordinator = childCoordinator(with: rootViewController) else {
            print("\(#function) - It's not possible to remove the child coordinator with root view controller `\(rootViewController)`. Current coordinator doesn't contains child coordinator")
            return
        }
        remove(coordinator: coordinator)
    }
    
    /// Starts the given coordinator and present another flow above coordinator.
    open func present(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)? = nil) {
        add(coordinator: coordinator)
        coordinator.start()
        coordinator.rootViewController.presentationController?.delegate = self as? UIAdaptivePresentationControllerDelegate
        rootViewController.present(coordinator.rootViewController, animated: animated, completion: completion)
    }
    
    /// Dismisses presented coordinator from current flow and removes dependency.
    open func dismiss(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)? = nil) {
        guard contains(coordinator: coordinator) else {
            print("\(#function) - It's not possible to dismiss the child coordinator. Current coordinator doesn't contains child coordinator")
            return
        }
        guard rootViewController.presentedViewController == coordinator.rootViewController else {
            print("\(#function) - It's not possible to dismiss the child coordinator. The presented view controller is not the same as child coordinator root view controller")
            return
        }
        rootViewController.dismiss(animated: animated) { [weak self] in
            self?.remove(coordinator: coordinator)
            completion?()
        }
    }
}
#endif
