//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

#if canImport(UIKit)
import class UIKit.UIViewController
import protocol UIKit.UIAdaptivePresentationControllerDelegate

public protocol PresentingCoordinator: Coordinator {
    /// Stored root view controller of current coordinator.
    var rootViewController: UIViewController { get }
    
    /// Returns child coordinator with root view controller if the coordinator contains.
    func childCoordinator(with rootViewController: UIViewController) -> Coordinator?
    
    /// Returns child coordinator with root view controller if the coordinator contains.
    func removeChildCoordinator(with rootViewController: UIViewController)
    
    /// Starts the given coordinator and present another flow above coordinator.
    func present(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)?)
    
    /// Dismisses presented coordinator from current flow and removes dependency.
    func dismiss(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)?)
}

// MARK: - Default Implementation

public extension PresentingCoordinator {
    /// Returns child coordinator with root view controller if the coordinator contains.
    func childCoordinator(with rootViewController: UIViewController) -> Coordinator? {
        children.first {
            guard let presentingCoordinator = $0 as? PresentingCoordinator else { return false }
            return presentingCoordinator.rootViewController === rootViewController
        }
    }
    
    /// Removes child coordinator with root view controller if the coordinator contains.
    func removeChildCoordinator(with rootViewController: UIViewController) {
        guard let coordinator = childCoordinator(with: rootViewController) else {
            assertionFailure("\(#function) - view controller presented  by coordinator hasn't found in child coordinators")
            return
        }
        remove(coordinator: coordinator)
    }
    
    /// Starts the given coordinator and present another flow above coordinator.
    func present(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)? = nil) {
        add(coordinator: coordinator)
        coordinator.start()
        coordinator.rootViewController.presentationController?.delegate = self as? UIAdaptivePresentationControllerDelegate
        rootViewController.present(coordinator.rootViewController, animated: animated, completion: completion)
    }
    
    /// Dismisses presented coordinator from current flow and removes dependency.
    func dismiss(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)? = nil) {
        guard contains(coordinator: coordinator) else {
            assertionFailure("\(#function) - It is not possible to dismiss coordinator because current flow doesn't contains given coordinator")
            return
        }
        guard rootViewController.presentedViewController == coordinator.rootViewController else {
            assertionFailure("\(#function) - presented view controller not found or not the same as presented controller")
            return
        }
        rootViewController.dismiss(animated: animated) { [weak self] in
            self?.remove(coordinator: coordinator)
            completion?()
        }
    }
}
#endif
