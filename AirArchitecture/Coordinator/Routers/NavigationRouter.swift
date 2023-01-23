// Copyright © 2023 Yurii Lysytsia. All rights reserved.

import UIKit

/// The wrapper for the `NavigationController` which manages navigation
open class NavigationRouter: NSObject, UINavigationControllerDelegate {
    let navigationController: UINavigationController
    
    // MARK: - Inits
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }
    
    // MARK: - Internal Methods
    
    /// Replaces the view controllers currently managed by the navigation controller with the specified items.
    func set(viewControllers: [UIViewController], anchorViewController: UIViewController?, animated: Bool) {
        // Set new view controllers if previous stack is empty.
        // This case possible if you set first view controller for initial flow.
        if navigationController.viewControllers.isEmpty {
            navigationController.setViewControllers(viewControllers, animated: animated)
            return
        }
        
        // Do nothing if anchor view controllers is not found. In this case the new flow was started and push should be called soon.
        // This case possible if you set first view controller for additional flow.
        guard let anchorViewController, let anchorIndex = navigationController.viewControllers.lastIndex(of: anchorViewController) else {
            return
        }
        
        // Define new navigation view controllers stack
        // This case possible if you changing current flow stack.
        
        // Get only parent view controllers and append new stack
        var newViewControllers = Array(navigationController.viewControllers[..<anchorIndex])
        newViewControllers.append(contentsOf: viewControllers)
        
        // Call all pop callbacks to deallocate it.
        let oldViewControllers = navigationController.viewControllers[anchorIndex...]
        oldViewControllers.forEach { runPopCallback(for: $0) }
        
        // Set new root view controllers
        navigationController.setViewControllers(newViewControllers, animated: animated)
    }
    
    // MARK: - Public Methods
    
    /// Push single module to current flow. You should use this method only when module is part of current flow.
    open func push(_ viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    /// Pops the top view controller from the navigation stack and updates the display.
    open func pop(animated: Bool) {
        guard let viewController = navigationController.popViewController(animated: animated) else {
            assertionFailure("\(#function) - unable to pop because you can't pop the last item on the stack")
            return
        }
        runPopCallback(for: viewController)
    }
    
    /// Pops view controllers until the specified view controller is at the top of the navigation stack.
    open func pop(to viewController: UIViewController, animated: Bool) {
        guard let viewControllers = navigationController.popToViewController(viewController, animated: animated), !viewControllers.isEmpty else {
            assertionFailure("\(#function) unable to pop to \(viewController)")
            return
        }
        viewControllers.forEach { runPopCallback(for: $0) }
    }
    
    // MARK: - UINavigationControllerDelegate
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Ensure the view controller is popping
        guard let popViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
            
        // Check is router removed pop view controller
        if navigationController.viewControllers.contains(popViewController) { return }
        
        runPopCallback(for: popViewController)
    }
}

// MARK: - Private

private extension NavigationRouter {
    /// Runs pop callback and deinitialize it.
    func runPopCallback(for popViewController: UIViewController) {
        popViewController.popCallback?()
        popViewController.popCallback = nil
    }
}

// MARK: - UIViewController + PopCallback

extension UIViewController {
    private static var popCallbackKey = "\(UIViewController.self).popCallback"
    
    /// Block using for save pop callback.
    var popCallback: (() -> Void)? {
        get { objc_getAssociatedObject(self, &UIViewController.popCallbackKey) as? (() -> Void) }
        set { objc_setAssociatedObject(self, &UIViewController.popCallbackKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
