@testable import Toolbox
import XCTest

final class NavigationCoordinatorTests: XCTestCase {

    func testNavigationCoordinatorInitialization() async throws {
        let expectation = XCTestExpectation(description: "NavigationCoordinator initialization")
        
        // Switch to the main actor context.
        await MainActor.run {
            let navCoordinator = NavigationCoordinator()
            
            // Test your coordinator instance here, e.g.:
            XCTAssertNotNil(navCoordinator)
            
            // Fulfill the expectation when the test is complete.
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled.
        wait(for: [expectation], timeout: 10)
    }
    
    func testNavigationCoordinatorRootIsUINavigationController() async throws {
        let expectation = XCTestExpectation(description: "NavigationCoordinator initialization")
        
        // Switch to the main actor context.
        await MainActor.run {
            let navCoordinator = NavigationCoordinator()
            
            // Test your coordinator instance here, e.g.:
            XCTAssertNotNil(navCoordinator)
            
            // Check if the rootViewController is of type UITabBarController
            XCTAssertTrue(navCoordinator.rootViewController is UINavigationController)
            
            // Fulfill the expectation when the test is complete.
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled.
        wait(for: [expectation], timeout: 10)
    }

}
