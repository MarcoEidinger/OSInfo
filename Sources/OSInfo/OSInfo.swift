import Foundation

#if canImport(UIKit)
    import UIKit
#endif

#if os(watchOS)
    import WatchKit
#endif

public struct OSInfo {
    public static let shared = OSInfo(underlyingMacOS: true)

    private var underlyingMacOS: Bool = false

    public init(underlyingMacOS: Bool = false) {
        self.underlyingMacOS = underlyingMacOS
    }

    public var version: String {
        if underlyingMacOS {
            // Mac Catalyst || Mac Designed for iPad
            #if targetEnvironment(macCatalyst) || os(iOS)
                if #available(iOS 13.0, macOS 10.15, *) {
                    // true when a Mac app built with Mac Catalyst or an iOS app running on Apple silicon
                    if ProcessInfo.processInfo.isMacCatalystApp {
                        return operationSystemVersionFromPlist() ?? operatingSystemVersionFromProcess()
                    }
                } else {
                    () // might be a native macOS app so lets continue
                }
            #endif
            #if os(macOS) // Mac
                return operatingSystemVersionFromProcess()
            #elseif os(iOS) // iPhone or iPad
            return operatingSystemVersionFromProcess()
                //return UIDevice.current.systemVersion
            #endif
        } else {
            // only available on iOS and tvOS
            #if os(iOS) // iPhone || iPad || Mac Catalyst || Mac Designed for iPad
                return UIDevice.current.systemVersion
            #elseif os(macOS) // Mac
                return operatingSystemVersionFromProcess()
            #endif
        }

        #if os(tvOS)
            return UIDevice.current.systemVersion
        #elseif os(watchOS)
            return WKInterfaceDevice.current().systemVersion
        #elseif os(Linux) || os(Windows)
            return ProcessInfo.processInfo.operatingSystemVersionString
        #else
            fatalError("not supported")
        #endif
    }

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
                } else {
                    () // might be native macOS so lets continue
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
            fatalError("not supported")
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
