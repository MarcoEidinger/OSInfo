@testable import OSInfo
import XCTest

final class OSInfoTests: XCTestCase {
    func testNameAndVersion() throws {
        print(OSInfo.shared.oSName)
        print(OSInfo.shared.oSVersion)
        XCTAssertTrue(true)
    }
}
