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
        
        let isoDateInPast = "2020-09-22T10:43:31Z"
        let isoDateInPastYear = "2015-03-22T10:43:31Z"
        
        let today = Date()
        
        let isoDateFormatter = ISO8601DateFormatter()
        
        print(isoDateFormatter.string(from: Date()))
        
        let datePast = isoDateFormatter.date(from: isoDateInPast)!
        let datePastYear = isoDateFormatter.date(from: isoDateInPastYear)!
        
        XCTAssertFalse(datePast.isDateYesterday)
        XCTAssertFalse(today.isDateTomorrow)
        XCTAssertTrue(today.isDateToday)
        XCTAssertFalse(datePast.isDateWeekend)
        
        XCTAssertFalse(datePast.isDateInSameWeek(with: today))
        XCTAssertFalse(datePastYear.isDateInSameMonth(with: today))
        XCTAssertFalse(datePastYear.isDateInSameYear(with: today))
    }
    
    // MARK: Auto Layout Helper Tests
    

    func testAutoLayoutHelper() {
        #if canImport(UIKit)
        
        let wrappingView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
        let childView = UIView(frame: .zero)
        wrappingView.wrap(view: childView, edgeInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        
        wrappingView.setNeedsLayout()
        wrappingView.layoutIfNeeded()
        
        XCTAssert(childView.frame.origin.x == 1)
        XCTAssert(childView.frame.origin.y == 1)
        XCTAssert(childView.frame.maxX == wrappingView.bounds.maxX - 1)
        XCTAssert(childView.frame.maxY == wrappingView.bounds.maxY - 1)
        
        #else
        
        XCTAssertTrue(true)
        
        #endif
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
    
    // MARK: Optional Tests
        
    func testNestingWithSimpleOptional() {
        let type = Double?.self
        XCTAssertTrue(type.nestedType() == Double.self)
        XCTAssertTrue(type.wrappedType() == Double.self)
    }
    
    func testDeepOptionalNesting() {
        let type = Double?????.self
        XCTAssertTrue(type.nestedType() == Double.self)
        XCTAssertTrue(type.wrappedType() == Double????.self)
    }
        
    func testTypedValueFlattening() {
        let nestedValue = Optional(Optional(2))
        let simpleInt = nestedValue.flattenedValue(type: Int.self)
        XCTAssertTrue(type(of: simpleInt) == Int?.self)
    }
    
    func testNotTypedValueFlattening() {
        let nestedVal = Optional(Optional(2)) as Any
        let simpleValue = flattenedValue(of: nestedVal).unsafelyUnwrapped
        XCTAssertFalse(simpleValue is ExpressibleByNilLiteral)
    }
    
    func testNotNestedOptionalNilValue() {
        let nothing: Int? = nil
        XCTAssertNil(nothing.flattenedValue())
    }
    
    func testNonOptionalValueFlattening() {
        let number = 1
        let flattenedVal = flattenedValue(of: number).unsafelyUnwrapped
        XCTAssertTrue(type(of: number) == type(of: flattenedVal))
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
        ("testAutoLayoutHelper", testAutoLayoutHelper),
        ("testSemanticVersion", testSemanticVersion),
        ("testNestingWithSimpleOptional", testNestingWithSimpleOptional),
        ("testDeepOptionalNesting", testDeepOptionalNesting),
        ("testTypedValueFlattening", testTypedValueFlattening),
        ("testNotTypedValueFlattening", testNotTypedValueFlattening),
        ("testNonOptionalValueFlattening", testNonOptionalValueFlattening),
    ]
}
