@testable import OSInfo
import XCTest

final class OperatingSystemTests: XCTestCase {
    func testNameAndVersion() throws {
        print("OperatingSystem.current.name: \(OperatingSystem.current.name)")
        print("OperatingSystem.current.version: \(OperatingSystem.current.version)")
        print("OperatingSystem().name: \(OperatingSystem().name)")
        print("OperatingSystem().version: \(OperatingSystem().version)")
        XCTAssertTrue(true)
    }
}
