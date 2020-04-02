import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TPKeyboardAvoidingSwiftTests.allTests),
    ]
}
#endif
