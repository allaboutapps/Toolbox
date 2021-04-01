
import XCTest
import Toolbox

class UserDefaultTests: XCTestCase {
        
    @UserDefault(key: "someBool", defaultValue: false)
    var someBool: Bool
    
    @UserDefault(key: "someInt", defaultValue: 0)
    var someInt: Int
    
    @UserDefault(key: "someDouble", defaultValue: 0.0)
    var someDouble: Double
    
    @UserDefault(key: "someFloat", defaultValue: 0.0)
    var someFloat: Float
    
    @UserDefault(key: "someURL", defaultValue: URL(fileURLWithPath: "/"))
    var someURL: URL
    
    @UserDefault(key: "someDictionary")
    var someDictionary: [String: Any]?
    
    
    func testReadCoercedBool() {
        UserDefaults.standard.setValue(1, forKey: "someBool")
        XCTAssertEqual(someBool, true)
                
        UserDefaults.standard.setValue("true", forKey: "someBool")
        XCTAssertEqual(someBool, true)
    }
    
    func testReadCoercedInt() {
        UserDefaults.standard.setValue(true, forKey: "someInt")
        XCTAssertEqual(someInt, 1)
                
        UserDefaults.standard.setValue("1", forKey: "someInt")
        XCTAssertEqual(someInt, 1)
    }
    
    func testReadCoercedDouble() {
        UserDefaults.standard.setValue(true, forKey: "someDouble")
        XCTAssertEqual(someDouble, 1.0)
                
        UserDefaults.standard.setValue("1.1", forKey: "someDouble")
        XCTAssertEqual(someDouble, 1.1)
    }
    
    func testReadCoercedFloat() {
        UserDefaults.standard.setValue(true, forKey: "someFloat")
        XCTAssertEqual(someFloat, 1.0)
                
        UserDefaults.standard.setValue("1.1", forKey: "someFloat")
        XCTAssertEqual(someFloat, 1.1)
    }
    
    func testReadCoercedURL() {
        let stringURL = "file:///Users/swift/Desktop"
        UserDefaults.standard.setValue(stringURL, forKey: "someURL")
        XCTAssertEqual(someURL, URL(fileURLWithPath: stringURL))
    }
    
    func testWriteOptionalDictionary() {
        someDictionary = ["a": 1, "b": "2"]
        XCTAssertNotNil(UserDefaults.standard.object(forKey: "someDictionary"))
        
        someDictionary = nil
        XCTAssertNil(UserDefaults.standard.object(forKey: "someDictionary"))
    }
    
    
    static var allTests = [
        ("testReadCoercedBool", testReadCoercedBool),
        ("testReadCoercedInt", testReadCoercedInt),
        ("testReadCoercedDouble", testReadCoercedDouble),
        ("testReadCoercedFloat", testReadCoercedFloat),
        ("testReadCoercedURL", testReadCoercedURL),
        ("testWriteOptionalDictionary", testWriteOptionalDictionary),
    ]
}
