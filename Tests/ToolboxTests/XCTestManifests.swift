import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ToolboxTests.allTests),
        testCase(UserDefaults.allTests)
    ]
}
#endif
