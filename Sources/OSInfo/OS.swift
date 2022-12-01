import Foundation

#if canImport(UIKit)
    import UIKit
#endif

#if os(watchOS)
    import WatchKit
#endif

/// A unified, cross-platform API to  determine OS name and version on which the app is running
public struct OS {
    // MARK: public variables

    /// Singleton that will return the underlying macOS version / name for a running Mac Catalyst / Mac Designed for iPad application
    public static let current = OS(underlyingMacOS: true)

    public private(set) var underlyingMacOS: Bool = false

    /**
     Known as `operatingSystemVersionString` is human readable, localized, and is appropriate for displaying to the user. This string is not appropriate for parsing.

      - Warning: does not take `underlyingMacOS=false` into consideration and will return macOS information for a Mac Catalyst app
     */
    public var displayVersion: String {
        return ProcessInfo.processInfo.operatingSystemVersionString
    }

    /// Parseable version of the currently executing operating system (including major, minor, and patch version numbers).
    public var version: OperatingSystemVersion {
        if underlyingMacOS {
            // Mac Catalyst || Mac Designed for iPad
            #if targetEnvironment(macCatalyst) || os(iOS)
                if #available(iOS 13.0, macOS 10.15, *) {
                    // true when a Mac app built with Mac Catalyst or an iOS app running on Apple silicon
                    if ProcessInfo.processInfo.isMacCatalystApp {
                        if let versionString = operationSystemVersionFromPlist() {
                            return OperatingSystemVersion(from: versionString)
                        }
                    }
                }
            #endif
        } else {
            #if targetEnvironment(macCatalyst) || os(iOS)
                let versionString = UIDevice.current.systemVersion
                return OperatingSystemVersion(from: versionString)
            #endif
        }

        return ProcessInfo.processInfo.operatingSystemVersion
    }

    /// Platform-specific string, e.g. "iOS", "iPadOS", "macOS", "watchOS", "tvOS", "Linux", "Windows"
    public var name: String {
        #if os(tvOS)
            return UIDevice.current.systemName
        #elseif os(watchOS)
            return WKInterfaceDevice.current().systemName
        #elseif os(Linux)
            return "Linux"
        #elseif os(Windows)
            return "Windows"
        #elseif os(macOS)
            return "macOS"
        #elseif os(iOS)
            if underlyingMacOS {
                if #available(iOS 13.0, macOS 10.15, *) { // Mac Catalyst || Mac Designed for iPad
                    // true when a Mac app built with Mac Catalyst or an iOS app running on Apple silicon
                    if ProcessInfo.processInfo.isMacCatalystApp {
                        return "macOS"
                    }
                }
            }
            return UIDevice.current.systemName
        #else
            return "Unknown"
        #endif
    }

    /// True for compilation condition `os(iOS)`
    public var iOSFamily: Bool {
        #if os(iOS)
            return true
        #else
            return false
        #endif
    }

    /// False for compilation condition `os(Linux)` or  `os(Windows)`
    public var appleFamily: Bool {
        #if os(Linux) || os(Windows)
            return false
        #else
            return true
        #endif
    }

    // MARK: public functions

    /// Initializer
    /// - Parameter underlyingMacOS: set to true if want the underlying macOS version / name for a Mac Catalyst / Mac Designed for iPad applications. Otherwise the "iOS support version" and respective OS name is used, e.g. iPadOS 16.1
    public init(underlyingMacOS: Bool = false) {
        self.underlyingMacOS = underlyingMacOS
    }

    // MARK: private functions

    /// returns `ProductVersion` from `/System/Library/CoreServices/.SystemVersionPlatform.plist`
    ///
    /// useful as  `ProcessInfo` will return iOS support version for "Mac Designed for iPad" destination which might not be desired
    private func operationSystemVersionFromPlist() -> String? {
        let sv = NSDictionary(contentsOfFile: "/System/Library/CoreServices/.SystemVersionPlatform.plist")
        let versionString = sv?.object(forKey: "ProductVersion") as? String
        return versionString
    }

    private func operatingSystemVersionFromProcess() -> String {
        var osVersion: String = "\(ProcessInfo.processInfo.operatingSystemVersion.majorVersion).\(ProcessInfo.processInfo.operatingSystemVersion.minorVersion)"
        if ProcessInfo.processInfo.operatingSystemVersion.patchVersion > 0 {
            osVersion += ".\(ProcessInfo.processInfo.operatingSystemVersion.patchVersion)"
        }
        return osVersion
    }
}
