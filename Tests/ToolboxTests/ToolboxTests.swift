@testable import Toolbox
import XCTest

final class ToolboxTests: XCTestCase {
    // MARK: Array Testing

    func testArrayRemoveIsRemovedTrue() {
        var array = ["foo", "bar"]
        array.remove(element: "foo")
        XCTAssertTrue(array.count == 1)
    }

    func testArrayIsUnifiedTrue() {
        var array = [1, 2, 3, 3, 2, 1, 4]
        array.unify()
        XCTAssertTrue(array.count == 4)
        XCTAssertEqual(array.sorted(), [1, 2, 3, 4])
    }
    
    func testArraySafeIndexTrue() {
        let array = ["foo", "bar"]
        XCTAssertNil(array[safeIndex: 3])
        XCTAssertEqual(array[safeIndex: 1], "bar")
    }
    
    // MARK: String Testing
    
    func testStringIsBlankTrue() {
        let stringIsEmpty = ""
        XCTAssertTrue(stringIsEmpty.isBlank)
        
        let stringIsNil: String? = nil
        XCTAssertTrue(stringIsNil.isBlank)
        
        let stringNewLine = "\n"
        XCTAssertTrue(stringNewLine.isBlank)
        
        let stringTabSpacing = "    "
        XCTAssertTrue(stringTabSpacing.isBlank)
        
        let stringSpacing = " "
        XCTAssertTrue(stringSpacing.isBlank)
    }
    
    func testStringDigitsOnlyTrue() {
        let stringContainsDigitsOnly = "123456"
        XCTAssert(stringContainsDigitsOnly.containsOnlyDigits)
    }
    
    func testStringToNilTrue() {
        let stringInt = "22a"
        let intString = stringInt.toIntOrNil()
        XCTAssertNil(intString)
    }
    
    func testStringToIntTrue() {
        let stringInt = "22"
        let intString = stringInt.toIntOrNil()
        XCTAssertEqual(intString, 22)
    }
    
    func testStringSubscriptTrue() {
        let stringToSubscript = "0123456789"
        
        XCTAssertEqual(stringToSubscript[0...5], "012345")
        XCTAssertEqual(stringToSubscript[..<5], "01234")
        XCTAssertEqual(stringToSubscript[7...], "789")
        XCTAssertEqual(stringToSubscript[3...5], "345")
    }

    static var allTests = [
        ("testArrayRemoveIsRemovedTrue", testArrayRemoveIsRemovedTrue),
        ("testArrayIsUnifiedTrue", testArrayIsUnifiedTrue),
        ("testStringIsBlankTrue", testStringIsBlankTrue),
        ("testStringDigitsOnlyTrue", testStringDigitsOnlyTrue),
        ("testStringToNilTrue", testStringToNilTrue),
        ("testStringToIntTrue", testStringToIntTrue),
        ("testStringSubscriptTrue", testStringSubscriptTrue)
    ]
}
