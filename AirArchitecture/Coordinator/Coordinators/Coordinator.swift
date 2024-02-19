// Copyright © 2021 Yurii Lysytsia. All rights reserved.

import ObjectiveC

/// Coordinator contains and manages dependencies of child coordinators.
public protocol Coordinator: AnyObject {
    /// The dependencies that stored in this coordinator.
    var children: [Coordinator] { get }
    
    /// Returns `true` if the coordinator contains other coordinator.
    func contains(coordinator: Coordinator) -> Bool
    
    /// Adds unique child coordinator and save dependency.
    func add(coordinator: Coordinator)
    
    /// Removes unique child if contains dependency
    func remove(coordinator: Coordinator)
    
    /// Prepares the coordinator to be displayed. The root view controller should be set and configured before it will have displayed
    func start()
    
    /// Prepares the coordinator to be dismissed. The root view controller should be removed from the stack
    func finish()
}

/// Abstract class of coordinator which contains dependencies to child coordinators. You should override this class to use.
open class BaseCoordinator: NSObject, Coordinator {
    open private(set) var children = [Coordinator]()
    
    // MARK: - Methods
    
    open func contains(coordinator: Coordinator) -> Bool {
        children.contains { $0 === coordinator }
    }

    open func add(coordinator: Coordinator) {
        if contains(coordinator: coordinator) {
            assertionFailure("\(#function) - failure while adding new coordinator `\(coordinator)`, because the coordinator is already added")
            return
        }
        children.append(coordinator)
    }

    open func remove(coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
    
    open func start() {}
    
    open func finish() {}
}
