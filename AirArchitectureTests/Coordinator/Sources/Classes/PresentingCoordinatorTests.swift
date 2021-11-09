//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

import XCTest
@testable import AirArchitecture

final class PresentingCoordinatorTests: XCTestCase {

    // MARK: - Private Properties
    
    private var sut: PresentingCoordinator!
    
    // MARK: - Lifecycle
    
    override func setUpWithError() throws {
        let rootViewController = MockPresentingViewController()
        sut = BasePresentingCoordinator(rootViewController: rootViewController)
        
        XCTAssertEqual(sut.state, .initial)
        XCTAssertNil(sut.parent)
        XCTAssertTrue(sut.children.isEmpty)
        XCTAssertTrue(sut.rootViewController === rootViewController)
    }

    // MARK: - Tests
    
    func testChild() throws {
        let child = BasePresentingCoordinator(rootViewController: MockPresentingViewController())
        XCTAssertEqual(child.state, .initial)
        XCTAssertNil(child.parent)
        XCTAssertTrue(child.children.isEmpty)
        
        sut.start()
        XCTAssertEqual(sut.state, .active)

        sut.present(coordinator: child, animated: false, completion: nil)
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertTrue(sut.contains(coordinator: child))
        XCTAssertTrue(child.parent === sut)
        XCTAssertTrue(sut.rootViewController.presentedViewController === child.rootViewController)
        
        
        sut.dismiss(coordinator: child, animated: false, completion: nil)
        XCTAssertTrue(sut.children.isEmpty)
        XCTAssertFalse(sut.contains(coordinator: child))
        XCTAssertNil(child.parent)
        XCTAssertNil(sut.rootViewController.presentedViewController)
    }

}
