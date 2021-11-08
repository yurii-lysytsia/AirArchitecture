//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

/// Possible states that managed by coordinator.
public enum CoordinatorState: Int {
    /// The coordinator has been created, but hasn't been started yet.
    case initial
    
    /// The coordinator has been stopped and hasn't been restarted yet.
    case inactive
    
    /// The coordinator has been started.
    case active
}
