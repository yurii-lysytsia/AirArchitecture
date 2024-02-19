// Copyright © 2023 Yurii Lysytsia. All rights reserved.

import UIKit

/// Abstract class of coordinator which contains stack of flows using navigation controller. You should override this class to use.
public protocol NavigationCoordinator: PresentingCoordinator {
    /// Returns an instance of the root navigation stack.
    var router: NavigationRouter { get }
    
    /// Returns root view controller for this navigation stack. Usually this needs to find the coordinator's stack start.
    var anchorViewController: UIViewController? { get }
    
    /// Pushes another flow to current flow. You should use this method when this coordinator needs use another flow inside himself.
    func push(coordinator: NavigationCoordinator, animated: Bool)
    
    /// Pops view controllers until the specified coordinator.
    func pop(coordinator: NavigationCoordinator, animated: Bool)
}

/// Coordinator which based on `NavigationRouter` and prefers work with `push` and `pop` line transitions
open class BaseNavigationCoordinator: BasePresentingCoordinator, NavigationCoordinator {
    public let router: NavigationRouter
    
    open private(set) var anchorViewController: UIViewController?
    
    // MARK: - Inits
    
    /// Creates a new instance with given navigation router. You should pass existing router to continue flow.
    public init(router: NavigationRouter) {
        self.router = router
        super.init(rootViewController: router.navigationController)
    }
    
    // MARK: - Methods
    
    /// Replaces the view controllers currently managed by this coordinator.
    open func set(viewControllers: [UIViewController], animated: Bool) {
        // Check is new array contains at least one view controller
        guard let newAnchorViewController = viewControllers.first else {
            assertionFailure("\(#function) - view controllers couldn't be empty")
            return
        }
        
        // Exchange pop callback from the previous to a new root view controller
        newAnchorViewController.popCallback = anchorViewController?.popCallback
        anchorViewController?.popCallback = nil
        
        // Update navigation stack
        router.set(viewControllers: viewControllers, anchorViewController: anchorViewController, animated: animated)
        
        // Save new anchor controller
        anchorViewController = newAnchorViewController
    }
    
    /// Sets root view controller managed by this coordinator.
    open func set(anchorViewController: UIViewController, animated: Bool) {
        set(viewControllers: [anchorViewController], animated: animated)
    }
    
    /// Push another flow to current flow. You should use this method when this coordinator needs use another flow inside himself.
    open func push(coordinator: NavigationCoordinator, animated: Bool) {
        // Prepare and start presenting coordinator
        coordinator.start()
        
        // Try to get anchor view controller before do next steps
        guard let childAnchorViewController = coordinator.anchorViewController else {
            coordinator.finish()
            assertionFailure("\(#function) - child coordinator doesn't have anchor view controller")
            return
        }
        
        // Add a new coordinator to the children stack
        add(coordinator: coordinator)
        
        // Subscribe for pop callback to remov presented coordinator when it will be popped
        childAnchorViewController.popCallback = { [weak self, unowned coordinator] in
            // Finish presented coordinator and remove it from the presenting coordinator
            coordinator.finish()
            self?.remove(coordinator: coordinator)
        }
        router.push(childAnchorViewController, animated: animated)
    }
    
    /// Pops view controllers until the specified coordinator.
    open func pop(coordinator: NavigationCoordinator, animated: Bool) {
        let viewControllers = router.navigationController.viewControllers
        
        // Get index of given coordinator's root view controller
        guard let childAnchorViewController = coordinator.anchorViewController, let index = viewControllers.lastIndex(of: childAnchorViewController) else {
            assertionFailure("\(#function) - index of coordinator's root view controller not found")
            return
        }
        
        // Get view controller before given coordinator's root view controller and pop to it.
        let previousViewController = viewControllers[index - 1]
        router.pop(to: previousViewController, animated: animated)
    }
}
