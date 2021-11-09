//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

#if canImport(UIKit)
import class UIKit.UIViewController

public protocol PresentingCoordinator: Coordinator {
    /// Returns the view controller that is root of this coordinator.
    var rootViewController: UIViewController { get }
    
    /// Returns the coordinator that is presented by this coordinator, if presented.
    var presentedCoordinator: PresentingCoordinator? { get }
    
    /// Return the coordinator that presented this coordinator, if presented.
    var presentingCoordinator: PresentingCoordinator? { get }
    
    /// Starts the given coordinator and present another flow above coordinator.
    func present(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)?)
    
    /// Dismisses presented coordinator from current flow and removes dependency.
    func dismiss(animated: Bool, completion: (() -> Void)?)
}
#endif
