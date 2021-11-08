// Copyright © 2021 Yurii Lysytsia. All rights reserved.

public protocol Coordinator: AnyObject {
    /// The dependency of parent coordinator that has started current coordinator.
    var parent: Coordinator? { get }
    
    /// The dependencies of this coordinator.
    var children: [Coordinator] { get }
    
    /// Returns `true` if the coordinator contains other coordinator.
    func contains(coordinator: Coordinator) -> Bool
    
    /// Run code that required to start the coordinator.
    func start()
    
    /// Run code that required to stop the coordinator.
    func stop()
    
    /// Adds unique child coordinator and save dependency.
    func add(coordinator: Coordinator)
    
    /// Removes unique child if contains dependency
    func remove(coordinator: Coordinator)
}
