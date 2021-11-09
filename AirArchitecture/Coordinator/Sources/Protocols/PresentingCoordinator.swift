//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

#if canImport(UIKit)
import class UIKit.UIViewController

public protocol PresentingCoordinator: Coordinator {
    /// Stored root view controller of current coordinator.
    var rootViewController: UIViewController { get }
    
    /// Returns child coordinator with root view controller if the coordinator contains.
    func childCoordinator(with rootViewController: UIViewController) -> Coordinator?
    
    /// Removes child coordinator with root view controller if the coordinator contains.
    func removeCoordinator(with rootViewController: UIViewController)
    
    /// Starts the given coordinator and present another flow above coordinator.
    func present(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)?)
    
    /// Dismisses presented coordinator from current flow and removes dependency.
    func dismiss(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)?)
}
#endif
