//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

import XCTest
@testable import AirArchitecture

final class BaseCoordinatorTests: XCTestCase {
    
    // MARK: - Private Properties
    
    private var sut: Coordinator!
    
    // MARK: - Lifecycle
    
    override func setUpWithError() throws {
        sut = BaseCoordinator()
        
        XCTAssertEqual(sut.state, .initial)
        XCTAssertNil(sut.parent)
        XCTAssertTrue(sut.children.isEmpty)
    }
    
    // MARK: - Tests
    
    func testStart() {
        sut.start()
        XCTAssertEqual(sut.state, .active)
        
        // Try to do the same
        sut.start()
        XCTAssertEqual(sut.state, .active)
    }
    
    func testStop() {
        sut.stop()
        XCTAssertEqual(sut.state, .inactive)
        
        // Try to do the same
        sut.stop()
        XCTAssertEqual(sut.state, .inactive)
    }
    
    func testChildren() {
        let child = BaseCoordinator()
        
        sut.add(coordinator: child)
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertTrue(sut.contains(coordinator: child))
        XCTAssertTrue(child.parent === sut)
        XCTAssertEqual(child.state, .initial)
        
        // Try to do the same
        sut.add(coordinator: child)
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertTrue(sut.contains(coordinator: child))
        XCTAssertTrue(child.parent === sut)
        XCTAssertEqual(child.state, .initial)
        
        child.start()
        XCTAssertEqual(child.state, .active)
        
        sut.stop()
        XCTAssertEqual(sut.state, .inactive)
        XCTAssertEqual(child.state, .inactive)
        
        sut.remove(coordinator: child)
        XCTAssertTrue(sut.children.isEmpty)
        XCTAssertFalse(sut.contains(coordinator: child))
        XCTAssertNil(child.parent)
        XCTAssertEqual(child.state, .inactive)
    }
    
}
