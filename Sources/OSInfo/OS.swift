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

    public var iOSFamily: Bool {
        #if os(iOS)
            return true
        #else
            return false
        #endif
    }

//    public var isIPhoneOS: Bool {
//        #if os(iOS)
//            return !isIPadOS
//        #else
//            return false
//        #endif
//    }
//
//    public var isIPadOS: Bool {
//        #if os(iOS)
//            if UIDevice.current.systemName == "iPadOS" {
//                return true
//            } else {
//                return false
//            }
//        #else
//            return false
//        #endif
//    }
//
//    public var isMacCatalyst: Bool {
//        #if targetEnvironment(macCatalyst) || os(iOS)
//            if #available(iOS 13.0, macOS 10.15, *) {
//                return ProcessInfo.processInfo.isMacCatalystApp
//            } else {
//                return true
//            }
//        #else
//            return false
//        #endif
//    }
//
//    public var isMacOS: Bool {
//        #if os(macOS)
//            return true
//        #else
//            return false
//        #endif
//    }
//
//    public var isWatchOS: Bool {
//        #if os(watchOS)
//            return true
//        #else
//            return false
//        #endif
//    }
//
//    public var isLinux: Bool {
//        #if os(Linux)
//            return true
//        #else
//            return false
//        #endif
//    }
//
//    public var isWindows: Bool {
//        #if os(Windows)
//            return true
//        #else
//            return false
//        #endif
//    }

    public var appleFamily: Bool {
        #if os(Linux) || os(Windows)
            return false
        #else
            return true
        #endif
    }

    /// Known as `operatingSystemVersionString` is human readable, localized, and is appropriate for displaying to the user. This string is not appropriate for parsing.
    public var displayVersion: String {
        return ProcessInfo.processInfo.operatingSystemVersionString
    }

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

//    /**
//     Parsable OS version string (*major*.*minor*.*optionalPatch*) for **Apple platforms**.
//
//      - Warning: For Linux and Windows you might prefer `displayVersion`
//     */
//    public var parseableVersion: String {
//        if underlyingMacOS {
//            // Mac Catalyst || Mac Designed for iPad
//            #if targetEnvironment(macCatalyst) || os(iOS)
//                if #available(iOS 13.0, macOS 10.15, *) {
//                    // true when a Mac app built with Mac Catalyst or an iOS app running on Apple silicon
//                    if ProcessInfo.processInfo.isMacCatalystApp {
//                        return operationSystemVersionFromPlist() ?? operatingSystemVersionFromProcess()
//                    }
//                }
//            #endif
//            #if os(macOS) // Mac
//                return operatingSystemVersionFromProcess()
//            #elseif os(iOS) // iPhone or iPad
//                return operatingSystemVersionFromProcess()
//            #endif
//        } else {
//            // only available on iOS and tvOS
//            #if os(iOS) // iPhone || iPad || Mac Catalyst || Mac Designed for iPad
//                return UIDevice.current.systemVersion
//            #elseif os(macOS) // Mac
//                return operatingSystemVersionFromProcess()
//            #endif
//        }
//
//        #if os(tvOS)
//            return UIDevice.current.systemVersion
//        #elseif os(watchOS)
//            return operatingSystemVersionFromProcess()
//        #elseif os(Linux) || os(Windows)
//            return operatingSystemVersionFromProcess()
//        #else
//            return operatingSystemVersionFromProcess()
//        #endif
//    }

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
