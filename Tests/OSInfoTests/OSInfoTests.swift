import XCTest
@testable import OSInfo

final class OSInfoTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        print(OSInfo(targetAware: true).oSName)
        print(OSInfo(targetAware: true).oSVersion)
        XCTAssertEqual(OSInfo().text, "Hello, World!")
    }
}
