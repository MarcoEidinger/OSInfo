import Foundation

#if canImport(UIKit)
    import UIKit
#endif

#if os(watchOS)
    import WatchKit
#endif

/// A unified, cross-platform API to  determine OS name and version on which the app is running
public struct OS {
    /// Singleton that will return the underlying macOS version / name for a Mac Catalyst / Mac Designed for iPad application
    public static let current = OS(underlyingMacOS: true)

    private var underlyingMacOS: Bool = false

    /// Initializer
    /// - Parameter underlyingMacOS: set to true if want the underlying macOS version / name for a Mac Catalyst / Mac Designed for iPad applications. Otherwise the "iOS support version" and respective OS name is used, e.g. iPadOS 16.1
    public init(underlyingMacOS: Bool = false) {
        self.underlyingMacOS = underlyingMacOS
    }

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
        #elseif os(macOS) || os(iOS)
            if underlyingMacOS {
                if #available(iOS 13.0, macOS 10.15, *) { // Mac Catalyst || Mac Designed for iPad
                    // true when a Mac app built with Mac Catalyst or an iOS app running on Apple silicon
                    if ProcessInfo.processInfo.isMacCatalystApp {
                        return "macOS"
                    }
                }
                #if os(macOS)
                    return "macOS"
                #elseif os(iOS) // Phone (= iOS) || iPad (= iPadOS)
                    return UIDevice.current.systemName
                #endif
            } else {
                #if os(macOS)
                    return "macOS"
                #else // Phone || iPad || Mac Catalyst
                    return UIDevice.current.systemName
                #endif
            }
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

extension OperatingSystemVersion: CustomStringConvertible {
    /// SemVer string (format of "*major*.*minor*.*patch*")
    ///
    /// omits patch version number if it is zero
    ///
    /// Examples: "13.0.1", "16.1"
    public var description: String {
        var osVersion: String = "\(majorVersion).\(minorVersion)"
        if patchVersion > 0 {
            osVersion += ".\(patchVersion)"
        }
        return osVersion
    }
}

public extension OperatingSystemVersion {
    init(from versionString: String) {
        let components = versionString.components(separatedBy: ".")
        let major = Int(components.first ?? "0") ?? 0
        let minor: Int = components.count > 1 ? Int(components[1]) ?? 0 : 0
        let patch: Int = components.count == 3 ? Int(components.last!) ?? 0 : 0
        self.init(majorVersion: major, minorVersion: minor, patchVersion: patch)
    }
}
