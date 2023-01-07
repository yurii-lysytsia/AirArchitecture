//  Copyright © 2023 Yurii Lysytsia. All rights reserved.

import Foundation

public final class Observable<Value> {
    /// The current value of the observable variable.
    public var value: Value {
        didSet {
            notifyObservers()
        }
    }
    
    // MARK: - Private Properties
    
    /// Cached storage of observation blocks to make strong relation.
    private var observers = [UUID: Block]()
    
    // MARK: - Inits
    
    /// Initializes a new observable object with given value.
    public init(_ value: Value) {
        self.value = value
    }
    
    // MARK: - Private Methods
    
    /// A lightweight implementation of an observable sequence that you can subscribe to.
    ///
    /// - Note: Partly based on [roberthein/Observable](https://github.com/roberthein/Observable).
    ///
    /// - Remark: I'd prefer having a protocol definition here, but casting an instance with a generic (e.g. `Variable<Int>(0)`) to a protocol
    ///           with an associated type (`Observable<Int>`) doesn't work yet. Therefore we use an "abstract" class as a workaround.
    
    private func notifyObservers() {
        observers.values.forEach { observationBlock in
            observationBlock(value)
        }
    }
    
    // MARK: - Public Methods
    
    /// Add observation block with a next value and receive notifications after every value changing.
    /// - Parameter observationBlock: block that will be called after every value changing.
    /// - Returns: a disposable object, that removes the entry for this observer on it's deallocation.
    public func subscribe(_ observationBlock: @escaping Block) -> Disposable {
        let id = UUID()
        observers[id] = observationBlock
        return Disposable { [weak self] in
            self?.observers[id] = nil
        }
    }
    
    /// Add observation block with an initial value and receive notifications after every value changing.
    /// - Parameter observationBlock: block that will be called after every value changing.
    /// - Returns: a disposable object, that removes the entry for this observer on it's deallocation.
    public func observe(_ observationBlock: @escaping Block) -> Disposable {
        let disposable = subscribe(observationBlock)
        observationBlock(value)
        return disposable
    }
    
    // MARK: - Helpers
    
    public typealias Block = (_ value: Value) -> Void
}
