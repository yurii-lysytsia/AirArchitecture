//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

import XCTest
@testable import AirArchitecture

final class PresentingCoordinatorTests: XCTestCase {

    // MARK: - Private Properties
    
    private var sut: PresentingCoordinator!
    
    // MARK: - Lifecycle
    
    override func setUpWithError() throws {
        let rootViewController = PresentingViewControllerMock()
        sut = BasePresentingCoordinator(rootViewController: rootViewController)
        
        XCTAssertEqual(sut.state, .initial)
        XCTAssertNil(sut.presentedCoordinator)
        XCTAssertTrue(sut.children.isEmpty)
        XCTAssertTrue(sut.rootViewController === rootViewController)
    }

    // MARK: - Tests
    
    func testPresentMultipleTimes() {
        let child = BasePresentingCoordinator(rootViewController: PresentingViewControllerMock())
        presentAndTest(child: child)
        presentAndTest(child: child)
    }
    
    func testDismissMultipleTimes() {
        let child = BasePresentingCoordinator(rootViewController: PresentingViewControllerMock())
        dismissAndTest(child: child)
        dismissAndTest(child: child)
    }
    
    func testFlow() {
        let child = BasePresentingCoordinator(rootViewController: PresentingViewControllerMock())
        XCTAssertEqual(child.state, .initial)
        XCTAssertTrue(child.children.isEmpty)
        
        sut.start()
        XCTAssertEqual(sut.state, .active)

        presentAndTest(child: child)
        dismissAndTest(child: child)
    }

    func testPresentationDismiss() {
        let child = BasePresentingCoordinator(rootViewController: PresentingViewControllerMock())
        sut.present(coordinator: child, animated: false, completion: nil)
        
        let controller = UIPresentationController(presentedViewController: child.rootViewController, presenting: sut.rootViewController)
        (sut as? BasePresentingCoordinator)?.presentationControllerDidDismiss(controller)
        XCTAssertTrue(sut.children.isEmpty)
        XCTAssertFalse(sut.contains(coordinator: child))
        XCTAssertNil(sut.presentedCoordinator)
    }
}

// MARK: - Private

private extension PresentingCoordinatorTests {
    
    func presentAndTest(child: PresentingCoordinator) {
        sut.present(coordinator: child, animated: false, completion: nil)
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertTrue(sut.contains(coordinator: child))
        XCTAssertTrue(sut.presentedCoordinator === child)
        XCTAssertTrue(sut.rootViewController.presentedViewController === child.rootViewController)
    }
    
    func dismissAndTest(child: PresentingCoordinator) {
        sut.dismiss(animated: false, completion: nil)
        XCTAssertTrue(sut.children.isEmpty)
        XCTAssertFalse(sut.contains(coordinator: child))
        XCTAssertNil(sut.presentedCoordinator)
        XCTAssertNil(sut.rootViewController.presentedViewController)
    }
    
}
