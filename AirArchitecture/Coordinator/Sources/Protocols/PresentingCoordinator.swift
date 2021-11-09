//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

#if canImport(UIKit)
import class UIKit.UIViewController

public protocol PresentingCoordinator: Coordinator {
    /// Stored root view controller of current coordinator.
    var rootViewController: UIViewController { get }
        
    /// Starts the given coordinator and present another flow above coordinator.
    func present(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)?)
    
    /// Dismisses presented coordinator from current flow and removes dependency.
    func dismiss(coordinator: PresentingCoordinator, animated: Bool, completion: (() -> Void)?)
}
#endif
