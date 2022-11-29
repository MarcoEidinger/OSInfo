@testable import OSInfo
import XCTest

final class OSInfoTests: XCTestCase {
    func testNameAndVersion() throws {
        print(OSInfo.shared.name)
        print(OSInfo.shared.version)
        XCTAssertTrue(true)
    }
}
