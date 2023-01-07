//  Copyright © 2023 Yurii Lysytsia. All rights reserved.

import Foundation

/// Invokes a closure when this instance is deallocated.
public final class Disposable {

    // MARK: - Private properties
    /// The closure to be called on deallocation.
    private let dispose: () -> Void

    // MARK: - Instance Lifecycle
    /// Creates a new instance.
    ///
    /// - Parameter dispose: The closure that is called on deallocation.
    public init(_ dispose: @escaping () -> Void) {
        self.dispose = dispose
    }

    deinit {
        dispose()
    }

    // MARK: - Public methods
    /// Adds the current instance to the given array of `Disposable`.
    ///
    /// - Parameter bag: Reference to the array of `Disposable`.
    public func store(in bag: inout DisposeBag) {
        bag.append(self)
    }
}

// MARK: - DisposableBag

/// Helper to allow storing multiple disposables.
public typealias DisposeBag = [Disposable]

// MARK: - NSObject + DisposableBag

extension NSObject {
    /// A `DisposeBag` that can be used to dispose observations and bindings.
    public var bag: DisposeBag {
        if let disposeBag = objc_getAssociatedObject(self, &AssociatedKeys.disposeBagKey) as? DisposeBag {
            return disposeBag
        } else {
            let disposeBag = DisposeBag()
            objc_setAssociatedObject(self, &AssociatedKeys.disposeBagKey, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return disposeBag
        }
    }
    
    private enum AssociatedKeys {
        static var disposeBagKey = "DisposeBagKey"
    }
}
