@testable import Toolbox
import XCTest

final class ToolboxTests: XCTestCase {
    // MARK: Array Testing

    func test_ArrayRemove_isRemoved_true() {
        var array = ["foo", "bar"]
        array.remove(element: "foo")
        XCTAssert(array.count == 1)
    }

    func test_Array_isUnified_true() {
        var array = [1, 2, 3, 3, 2, 1, 4]
        array.unify()
        XCTAssert(array.count == 4)
    }
    
    func test_Array_safeIndex_true() {
        let array = ["foo", "bar"]
        XCTAssertNil(array[safeIndex: 3])
        XCTAssertEqual(array[safeIndex: 1], "bar")
    }
    
    // MARK: String Testing
    
    func test_String_isBlank_true() {
        let stringIsEmpty = ""
        XCTAssert(stringIsEmpty.isBlank)
        
        let stringIsNil: String? = nil
        XCTAssert(stringIsNil.isBlank)
        
        let stringNewLine = "\n"
        XCTAssert(stringNewLine.isBlank)
        
        let stringTabSpacing = "    "
        XCTAssert(stringTabSpacing.isBlank)
        
        let stringSpacing = " "
        XCTAssert(stringSpacing.isBlank)
    }
    
    func test_String_digitsOnly_true() {
        let stringContainsDigitsOnly = "123456"
        XCTAssert(stringContainsDigitsOnly.containsOnlyDigits)
    }
    
    func test_String_toNil_true() {
        let stringInt = "22a"
        let intString = stringInt.toIntOrNil()
        XCTAssertNil(intString)
    }
    
    func test_String_toInt_true() {
        let stringInt = "22"
        let intString = stringInt.toIntOrNil()
        XCTAssertEqual(intString, 22)
    }
    
    func test_String_subscript_true() {
        let stringToSubscript = "0123456789"
        
        XCTAssertEqual(stringToSubscript[0...5], "012345")
        XCTAssertEqual(stringToSubscript[..<5], "01234")
        XCTAssertEqual(stringToSubscript[7...], "789")
        XCTAssertEqual(stringToSubscript[3...5], "345")
    }

    static var allTests = [
        ("test_ArrayRemove_isRemoved_true", test_ArrayRemove_isRemoved_true),
        ("test_Array_isUnified_true", test_Array_isUnified_true),
        ("test_String_isBlank_true", test_String_isBlank_true),
        ("test_String_digitsOnly_true", test_String_digitsOnly_true),
        ("test_String_toNil_true", test_String_toNil_true),
        ("test_String_toInt_true", test_String_toInt_true),
        ("test_String_Subscript_true", test_String_subscript_true)
    ]
}
