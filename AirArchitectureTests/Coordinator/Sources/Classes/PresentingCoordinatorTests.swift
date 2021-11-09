//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

import XCTest
@testable import AirArchitecture

final class PresentingCoordinatorTests: XCTestCase {

    // MARK: - Private Properties
    
    private var sutRootViewController: UIViewController!
    private var sut: PresentingCoordinator!
    
    // MARK: - Lifecycle
    
    override func setUpWithError() throws {
        sutRootViewController = UIViewController()
        sut = BasePresentingCoordinator(rootViewController: sutRootViewController)
        
        XCTAssertEqual(sut.state, .initial)
        XCTAssertNil(sut.parent)
        XCTAssertTrue(sut.children.isEmpty)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
