@testable import OSInfo
import XCTest

final class OSTests: XCTestCase {
    func testNameAndVersion() throws {
        print("OS.current.name: \(OS.current.name)")
        print("OS.current.version: \(OS.current.version)")
        print("OS().name: \(OS().name)")
        print("OS().version: \(OS().version)")
        XCTAssertTrue(true)
    }
}
