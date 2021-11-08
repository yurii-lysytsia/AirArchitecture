//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

#if canImport(ObjectiveC)
import class ObjectiveC.NSObject

/// Abstract class of coordinator which contains dependencies to child coordinators. You should override this class to use.
open class BaseCoordinator: NSObject, Coordinator {
    
    // MARK: - Public Properties
    
    open private(set) var state: CoordinatorState = .initial
    
    open private(set) weak var parent: Coordinator?
    
    open private(set) var children = [Coordinator]()
    
    // MARK: - Methods
    
    open func start() {
        if state == .active { return }
        state = .active
    }
    
    open func stop() {
        if state == .inactive { return }
        state = .inactive
        children.forEach { $0.stop() }
    }
    
    open func contains(coordinator: Coordinator) -> Bool {
        children.contains { $0 === coordinator }
    }
    
    open func add(coordinator: Coordinator) {
        if contains(coordinator: coordinator) {
            print("\(#function) - It's not possible to add a new child coordinator `\(coordinator)`. The coordinator has been already added")
            return
        }
        (coordinator as? BaseCoordinator)?.parent = self
        children.append(coordinator)
    }
    
    open func remove(coordinator: Coordinator) {
        for (offset, child) in children.enumerated() where child === coordinator {
            (child as? BaseCoordinator)?.parent = nil
            child.stop()
            children.remove(at: offset)
        }
    }
}
#endif
