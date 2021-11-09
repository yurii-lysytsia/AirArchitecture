//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

#if canImport(UIKit)
import class UIKit.UIViewController
import class UIKit.UIPresentationController
import protocol UIKit.UIAdaptivePresentationControllerDelegate

open class BasePresentingCoordinator: BaseCoordinator, PresentingCoordinator, UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Private Properties
    
    open private(set) var rootViewController: UIViewController
    
    // MARK: - Inits
    
    /// Creates a new instance with given root view controller.
    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    // MARK: - Methods
    
    /// Starts the given coordinator and present another flow above coordinator.
    open func present(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)? = nil) {
        add(coordinator: coordinator)
        coordinator.start()
        coordinator.rootViewController.presentationController?.delegate = self
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
    
    // MARK: - UIAdaptivePresentationControllerDelegate
    
    open func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // For iOS 13 and newer. When user dismiss view controller using swipe down.
        guard let coordinator = children.first(where: { ($0 as? PresentingCoordinator)?.rootViewController === presentationController.presentedViewController }) else {
            print("\(#function) - It's not possible to find coordinator with given presented view controller `\(presentationController.presentedViewController)`")
            return
        }
        remove(coordinator: coordinator)
    }
}
#endif
