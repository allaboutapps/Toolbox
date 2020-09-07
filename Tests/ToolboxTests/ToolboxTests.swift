import XCTest
@testable import Toolbox

final class ToolboxTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Toolbox().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
