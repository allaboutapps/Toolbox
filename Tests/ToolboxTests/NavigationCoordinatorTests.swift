#if canImport(UIKit)

@testable import Toolbox
import XCTest

final class NavigationCoordinatorTests: XCTestCase {
    
    func testNavigationCoordinatorRootIsUINavigationController() async throws {
        let expectation = XCTestExpectation(description: "NavigationCoordinator initialization")
        
        // Switch to the main actor context.
        await MainActor.run {
            let navCoordinator = NavigationCoordinator(navigationController: .init())
            
            // Test your coordinator instance here, e.g.:
            XCTAssertNotNil(navCoordinator)
            
            // Check if the rootViewController is of type UITabBarController
            XCTAssertTrue(navCoordinator.rootViewController is UINavigationController)
            
            // Fulfill the expectation when the test is complete.
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled.
        await fulfillment(of: [expectation], timeout: 10)
    }

}

#endif
