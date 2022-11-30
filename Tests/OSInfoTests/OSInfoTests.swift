@testable import OSInfo
import XCTest

final class OSInfoTests: XCTestCase {
    func testNameAndVersion() throws {
        print("OSInfo.shared.name: \(OSInfo.shared.name)")
        print("OSInfo.shared.version: \(OSInfo.shared.version)")
        print("OSInfo().name: \(OSInfo().name)")
        print("OSInfo().version: \(OSInfo().version)")
        XCTAssertTrue(true)
    }
}
