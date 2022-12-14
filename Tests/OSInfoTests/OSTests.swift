@testable import OSInfo
import XCTest

final class OSTests: XCTestCase {
    func testName() throws {
        let name = OS(underlyingMacOS: false).name

        #if os(watchOS)
            XCTAssertEqual(name, "watchOS")
        #elseif os(tvOS)
            XCTAssertEqual(name, "tvOS")
        #elseif os(Linux)
            XCTAssertEqual(name, "Linux")
        #elseif os(Windows)
            XCTAssertEqual(name, "Windows")
        #elseif os(macOS)
            XCTAssertEqual(name, "macOS")
        #elseif os(iOS)
            XCTAssertEqual(name, UIDevice.current.systemName)
        #else
            XCTFail("Not supported")
        #endif

        let underlyingName = OS(underlyingMacOS: true).name
        #if targetEnvironment(macCatalyst)
            XCTAssertEqual(underlyingName, "macOS")
        #endif
    }

    func testVersion() throws {
        let version = OS(underlyingMacOS: false).version

        XCTAssertGreaterThan(version.majorVersion, 0)

        let underlyingVersion = OS(underlyingMacOS: true).version
        #if targetEnvironment(macCatalyst)
            XCTAssertNotEqual(version.description, underlyingVersion.description)
        #endif
    }

    func testDisplayVersion() {
        let version = OS(underlyingMacOS: false).displayVersion

        XCTAssertEqual(version, ProcessInfo.processInfo.operatingSystemVersionString)

        let underlyingVersion = OS(underlyingMacOS: true).displayVersion
        #if targetEnvironment(macCatalyst)
            XCTAssertEqual(version, underlyingVersion)
        #endif
    }

    func testIOSFamily() {
        let isAppleFamily = OS.current.iOSFamily
        #if os(iOS)
            XCTAssertTrue(isAppleFamily)
        #else
            XCTAssertFalse(isAppleFamily)
        #endif
    }

    func testAppleFamily() {
        let isAppleFamily = OS.current.appleFamily
        #if os(Linux) || os(Windows)
            XCTAssertFalse(isAppleFamily)
        #else
            XCTAssertTrue(isAppleFamily)
        #endif
    }

    func testManualVerification() throws {
        print("OS.current.name: \(OS.current.name)")
        print("OS.current.version: \(OS.current.version.description)")
        print("OS.current.displayVersion: \(OS.current.displayVersion)")

        print("OS().name: \(OS().name)")
        print("OS().version: \(OS().version.description)")
        print("OS.().displayVersion: \(OS().displayVersion)")
    }
}
