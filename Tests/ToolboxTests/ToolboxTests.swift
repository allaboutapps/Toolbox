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
    
    // MARK: Date Testing
    
    func testDates() {
        
        let isoDateInPast = "2020-09-22T10:43:31.227Z"
        let isoDateInPastYear = "2015-03-22T10:43:31.227Z"
        
        let today = Date()
        
        let datePast = Formatters.isoDateFormatter.date(from: isoDateInPast)!
        let datePastYear = Formatters.isoDateFormatter.date(from: isoDateInPastYear)!
        
        XCTAssertFalse(datePast.isDateYesterday)
        XCTAssertFalse(today.isDateTomorrow)
        XCTAssertTrue(today.isDateToday)
        XCTAssertFalse(datePast.isDateWeekend)
        
        XCTAssertFalse(datePast.isDateInSameWeek(with: today))
        XCTAssertFalse(datePastYear.isDateInSameMonth(with: today))
        XCTAssertFalse(datePastYear.isDateInSameYear(with: today))
    }
    
    // MARK: SemanticVersion Tests
    
    func testSemanticVersion() {
        // init and description tests
        // init has to be explicitly written out otherwise a non failable initializer is used(Swift bug?)
        var version: SemanticVersion? = SemanticVersion.init("1.0.0")
        XCTAssertNotNil(version)
        XCTAssertEqual(version?.description, "1.0.0")
                
        version = SemanticVersion.init("1.0")
        XCTAssertNotNil(version)
        XCTAssertEqual(version?.description, "1.0.0")
        
        version = SemanticVersion.init("x.x.x")
        XCTAssertNil(version)
        
        version = SemanticVersion.init("1.0.0-beta.xyz")
        XCTAssertNil(version)
        
        version = SemanticVersion.init("1.0.0+beta.1.2.3")
        XCTAssertNil(version)
        
        //decodable tests
        
        struct TestVersion: Codable {
            let version: SemanticVersion
        }
        
        let decoder = JSONDecoder()
        
        var encodedVersion = "{\"version\": \"1.0.0\"}".data(using: .utf8)!
        XCTAssertNoThrow(try decoder.decode(TestVersion.self, from: encodedVersion))
        
        encodedVersion = "{\"version\": \"1.0\"}".data(using: .utf8)!
        XCTAssertNoThrow(try decoder.decode(TestVersion.self, from: encodedVersion))
        
        encodedVersion = "{\"version\": \"x.x.x\"}".data(using: .utf8)!
        XCTAssertThrowsError(try decoder.decode(TestVersion.self, from: encodedVersion))
        
        encodedVersion = "{\"version\": \"1.0.0+beta.1.2.3\"}".data(using: .utf8)!
        XCTAssertThrowsError(try decoder.decode(TestVersion.self, from: encodedVersion))
        
        encodedVersion = "{\"version\": \"1.0.0-beta.xyz\"}".data(using: .utf8)!
        XCTAssertThrowsError(try decoder.decode(TestVersion.self, from: encodedVersion))

        // comparable tests
        var version0: SemanticVersion = "1.0.0"
        var version1: SemanticVersion = "2.0.0"
        XCTAssertLessThanOrEqual(version0, version1)
        
        version0 = "1.0.0"
        version1 = "1.1.0"
        XCTAssertLessThanOrEqual(version0, version1)
        
        version0 = "1.0.0"
        version1 = "1.0.1"
        XCTAssertLessThanOrEqual(version0, version1)
        
        version0 = "1.0.0"
        version1 = "1.1.1"
        XCTAssertLessThanOrEqual(version0, version1)
        
        version0 = "1.1.1"
        version1 = "2.0.0"
        XCTAssertLessThanOrEqual(version0, version1)
    }

    static var allTests = [
        ("testArrayRemoveIsRemovedTrue", testArrayRemoveIsRemovedTrue),
        ("testArrayIsUnifiedTrue", testArrayIsUnifiedTrue),
        ("testStringIsBlankTrue", testStringIsBlankTrue),
        ("testStringDigitsOnlyTrue", testStringDigitsOnlyTrue),
        ("testStringToNilTrue", testStringToNilTrue),
        ("testStringToIntTrue", testStringToIntTrue),
        ("testStringSubscriptTrue", testStringSubscriptTrue),
        ("testDates", testDates),
        ("testSemanticVersion", testSemanticVersion)
    ]
}
