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

//    func testParseableVersion() throws {
//        let version = OS(underlyingMacOS: false).parseableVersion
//
//        #if os(watchOS)
//            XCTAssertEqual(version, WKInterfaceDevice.current().systemVersion)
//        #elseif os(tvOS)
//            XCTAssertEqual(version, UIDevice.current.systemVersion)
//        #elseif os(Linux)
//            XCTAssertEqual(version, ProcessInfo.processInfo.operatingSystemVersion.description)
//        #elseif os(Windows)
//            XCTAssertEqual(version, ProcessInfo.processInfo.operatingSystemVersion.description)
//        #elseif os(macOS)
//            XCTAssertEqual(version, ProcessInfo.processInfo.operatingSystemVersion.description)
//        #elseif os(iOS)
//            XCTAssertEqual(version, UIDevice.current.systemVersion)
//        #else
//            XCTFail("Not supported")
//        #endif
//
//        let underlyingVersion = OS(underlyingMacOS: true).parseableVersion
//        #if targetEnvironment(macCatalyst)
//            XCTAssertNotEqual(version, underlyingVersion)
//        #endif
//    }

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

    func testFakeAndRatherObserveLogs() throws {
        print("OS.current.name: \(OS.current.name)")
        print("OS.current.version: \(OS.current.version.description)")
//        print("OS.current.parseableVersion: \(OS.current.parseableVersion)")
        print("OS.current.displayVersion: \(OS.current.displayVersion)")

        print("OS().name: \(OS().name)")
        print("OS().version: \(OS().version.description)")
//        print("OS().parseableVersion: \(OS().parseableVersion)")
        print("OS.().displayVersion: \(OS().displayVersion)")
        XCTAssertTrue(true)
    }
}
