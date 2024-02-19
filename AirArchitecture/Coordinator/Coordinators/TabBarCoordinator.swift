// Copyright © 2023 Yurii Lysytsia. All rights reserved.

import UIKit

public protocol TabBarCoordinator: PresentingCoordinator {
    /// Returns the coordinator associated with the currently selected tab item.
    var selectedCoordinator: PresentingCoordinator? { get }
    
    /// Sets the root coordinators of the tab bar controller.
    func set(coordinators: [PresentingCoordinator], animated: Bool)
    
    /// Makes the coordinator's tab item selected and visible.
    func select(coordinator: PresentingCoordinator)
}

/// Abstract class of coordinator which split many flows using tab bar. You should override this class to use.
open class BaseTabBarCoordinator: BasePresentingCoordinator, TabBarCoordinator {
    /// Returns the coordinator associated with the currently selected tab item.
    open var selectedCoordinator: PresentingCoordinator? {
        guard children.indices.contains(tabBarController.selectedIndex) else { return nil }
        let suitableCoordinator = children[tabBarController.selectedIndex] as? PresentingCoordinator
        return suitableCoordinator?.rootViewController === tabBarController.selectedViewController ? suitableCoordinator : nil
    }
    
    // MARK: - Dependency Properties
    
    /// Dependency of root tab bar controller.
    private let tabBarController: UITabBarController
    
    // MARK: - Inits
    
    public init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        super.init(rootViewController: tabBarController)
    }
    
    // MARK: - Methods
    
    /// Sets the root coordinators of the tab bar controller.
    open func set(coordinators: [PresentingCoordinator], animated: Bool) {
        var viewControllers = [UIViewController]()
        coordinators.forEach { childCoordinator in
            // Prepares and adds a new coordinator to the children stack
            childCoordinator.start()
            add(coordinator: childCoordinator)
            viewControllers.append(childCoordinator.rootViewController)
        }
        tabBarController.setViewControllers(viewControllers, animated: animated)
    }
    
    /// Makes the coordinator's tab item selected and visible.
    open func select(coordinator: PresentingCoordinator) {
        guard let index = children.firstIndex(where: { $0 === coordinator }) else {
            assertionFailure("\(#function) - coordinator is not found in the children coordinators")
            return
        }
        tabBarController.selectedIndex = index
    }
}
