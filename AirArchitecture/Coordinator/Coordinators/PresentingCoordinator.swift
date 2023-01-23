// Copyright © 2021 Yurii Lysytsia. All rights reserved.

import UIKit

public protocol PresentingCoordinator: Coordinator {
    /// Returns the view controller that is root of this coordinator.
    var rootViewController: UIViewController { get }
    
    /// Returns the coordinator that is presented by this coordinator.
    var presentedCoordinator: PresentingCoordinator? { get }
    
    /// Starts the given coordinator and present another flow above coordinator.
    func present(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)?)
    
    /// Dismisses presented coordinator from current flow and removes dependency.
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

/// Abstract class of coordinator which can present or dismiss other flows. You should override this class to use.
open class BasePresentingCoordinator: BaseCoordinator, PresentingCoordinator, UIAdaptivePresentationControllerDelegate {
    public let rootViewController: UIViewController
    
    open private(set) weak var presentedCoordinator: PresentingCoordinator?
    
    // MARK: - Inits
    
    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        super.init()
    }
    
    // MARK: - Overriden Methods
    
    open override func remove(coordinator: Coordinator) {
        // Dismiss presented coordinator if this is removing coordinator dependency if coordinator was presented.
        if presentedCoordinator === coordinator {
            dismiss(animated: false)
            return
        }
        
        super.remove(coordinator: coordinator)
    }
    
    // MARK: - Methods
    
    /// Starts the given coordinator and present another flow above coordinator.
    open func present(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)? = nil) {
        // Reject presenting if this coordinator has already presented other coordinator
        if presentedCoordinator != nil {
            assertionFailure("\(#function) - It's not possible to present coordinator. The coordinator is already presented other coordinator")
            return
        }
        
        // Start and present new coordinator
        add(coordinator: coordinator)
        coordinator.rootViewController.presentationController?.delegate = self
        rootViewController.present(coordinator.rootViewController, animated: animated) { [weak self] in
            self?.presentedCoordinator = coordinator
            completion?()
        }
    }
    
    /// Dismisses the view controller that was presented by this coordinator
    open func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        guard let presentedCoordinator = presentedCoordinator else {
            assertionFailure("\(#function) - It is not possible to dismiss presented coordinator. The coordinator doesn't have presented coordinator")
            return
        }
        
        rootViewController.dismiss(animated: animated) { [weak self] in
            self?.presentedCoordinator = nil
            self?.remove(coordinator: presentedCoordinator)
            completion?()
        }
    }
    
    // MARK: - UIAdaptivePresentationControllerDelegate
    
    open func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Remove interactively dismissed coordinator. Needs for iOS 13 and newer, when user dismiss view controller using swipe down.
        guard let presentedCoordinator = presentedCoordinator else {
            assertionFailure("\(#function) - It's not possible to remove child coordinator. The coordinator doesn't have presented coordinator")
            return
        }
        
        guard presentedCoordinator.rootViewController === presentationController.presentedViewController else {
            assertionFailure("\(#function) - It's not possible to remove child coordinator. The called delegate is not equal to presented coordinator's root view controller")
            return
        }
        
        self.presentedCoordinator = nil
        remove(coordinator: presentedCoordinator)
    }
}
