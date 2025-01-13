#if canImport(UIKit)

@testable import Toolbox
import XCTest

final class TabBarCoordinatorTests: XCTestCase {
    
    func testTabBarCoordinatorRootIsUITabBarController() async throws {
        let expectation = XCTestExpectation(description: "TabBarCoordinator initialization")
        
        // Switch to the main actor context.
        await MainActor.run {
            let tabBarCoordinator = TabBarCoordinator(tabBarController: UITabBarController())
            
            // Test your coordinator instance here, e.g.:
            XCTAssertNotNil(tabBarCoordinator)
            
            // Check if the rootViewController is of type UITabBarController
            XCTAssertTrue(tabBarCoordinator.rootViewController is UITabBarController)
            
            // Fulfill the expectation when the test is complete.
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled.
        await fulfillment(of: [expectation], timeout: 10)
    }
}

#endif
