import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Ghosting_ConnectorTests.allTests),
    ]
}
#endif
