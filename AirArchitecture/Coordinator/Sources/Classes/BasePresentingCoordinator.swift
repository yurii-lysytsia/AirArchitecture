//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

#if canImport(UIKit)
import class UIKit.UIViewController
import class UIKit.UIPresentationController
import protocol UIKit.UIAdaptivePresentationControllerDelegate

open class BasePresentingCoordinator: BaseCoordinator, PresentingCoordinator, UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Public Properties
    
    open private(set) var rootViewController: UIViewController
    
    open private(set) weak var presentedCoordinator: PresentingCoordinator?
    
    // MARK: - Lifecycle
    
    /// Creates a new instance with given root view controller.
    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    open override func remove(coordinator: Coordinator) {
        // Remove dependency if coordinator was presented.
        if coordinator === presentedCoordinator {
            presentedCoordinator = nil
        }
        
        super.remove(coordinator: coordinator)
    }
    
    // MARK: - Methods
    
    open func present(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)? = nil) {
        // Check is current coordinator has already presented coordinator.
        if let presentedCoordinator = presentedCoordinator {
            print("\(#function) - It's not possible to present the child coordinator `\(coordinator)`. Current coordinator has already presented coordinator `\(presentedCoordinator)`")
            return
        }
        
        // Add a new coordinator dependency
        add(coordinator: coordinator)
        coordinator.start()
        coordinator.rootViewController.presentationController?.delegate = self
        
        // Present child coordinator root view controller
        rootViewController.present(coordinator.rootViewController, animated: animated) { [weak self] in
            self?.presentedCoordinator = coordinator
            completion?()
        }
    }
    
    open func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        guard let presentedCoordinator = presentedCoordinator else {
            print("\(#function) - It's not possible to dismiss the child coordinator. Current coordinator didn't present any child coordinator")
            return
        }
        
        guard contains(coordinator: presentedCoordinator) else {
            print("\(#function) - It's not possible to dismiss the child coordinator. Current coordinator doesn't contains child coordinator")
            return
        }
        
        guard rootViewController.presentedViewController == presentedCoordinator.rootViewController else {
            print("\(#function) - It's not possible to dismiss the child coordinator. The presented view controller is not the same as child coordinator root view controller")
            return
        }
        
        rootViewController.dismiss(animated: animated) { [weak self] in
            self?.remove(coordinator: presentedCoordinator)
            completion?()
        }
    }
    
    // MARK: - UIAdaptivePresentationControllerDelegate
    
    open func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // For iOS 13 and newer. When user dismiss view controller using swipe down.
        guard let presentedCoordinator = presentedCoordinator else {
            print("\(#function) - It's not possible to dismiss the child coordinator. Current coordinator didn't present any child coordinator")
            return
        }
        
        guard presentedCoordinator.rootViewController === presentationController.presentedViewController else {
            print("\(#function) - It's not possible to dismiss the child coordinator. The presented view controller is not the same as child coordinator root view controller")
            return
        }
        
        remove(coordinator: presentedCoordinator)
    }
}
#endif
