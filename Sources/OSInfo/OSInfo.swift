import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if os(watchOS)
import WatchKit
#endif

public struct OSInfo {
    public private(set) var text = "Hello, World!"

    private var targetAware: Bool = false
    
    public init(targetAware: Bool = false) {
        self.targetAware = targetAware
    }
}

// MARK: OS Info
public extension OSInfo {
    var oSVersion: String {
        if targetAware {
            if #available(iOS 13.0, macOS 10.15, watchOS 6.0, *) {
                // true when a Mac app built with Mac Catalyst or an iOS app running on Apple silicon
                if ProcessInfo.processInfo.isMacCatalystApp {
                    return operatingSystemVersionFromProcess()
                }
            } else {
                () // ProcessInfo.processInfo.isMacCatalystApp might not be available or running app might be native macOS or on a complete different platform so lets continue
            }
            #if os(macOS) || targetEnvironment(macCatalyst)
            return operatingSystemVersionFromProcess()
            #elseif os(iOS)
            return UIDevice.current.systemVersion
            #elseif os(tvOS)
            return UIDevice.current.systemVersion
            #elseif os(watchOS)
            return WKInterfaceDevice.current().systemVersion
            #elseif os(Linux) || os(Windows)
            return operatingSystemVersionFromProcess()
            //return ProcessInfo.processInfo.operatingSystemVersionString
            #else
            return DeviceDataValue.unknown
            #endif
        } else  {
            // only available on iOS and tvOS
            #if os(iOS)
            return UIDevice.current.systemVersion
            #elseif os(tvOS)
            return UIDevice.current.systemVersion
            #elseif os(watchOS)
            return WKInterfaceDevice.current().systemVersion
            #elseif os(Linux) || os(Windows)
            return operatingSystemVersionFromProcess()
            //return ProcessInfo.processInfo.operatingSystemVersionString
            #else
            fatalError("not supported")
            #endif
        }

    }

    var oSName: String {
        if targetAware {
            #if os(macOS) || targetEnvironment(macCatalyst)
            return "macOS"
            #elseif os(iOS)
            return UIDevice.current.systemName
            #elseif os(tvOS)
            return UIDevice.current.systemName
            #elseif os(watchOS)
            return WKInterfaceDevice.current().systemName
            #elseif os(Linux)
            return "Linux"
            #elseif os(Windows)
            return "Windows"
            #else
            fatalError("not supported")
            #endif
        } else {
            // only available on iOS and tvOS
            #if os(iOS)
            return UIDevice.current.systemName
            #elseif os(tvOS)
            return UIDevice.current.systemName
            #elseif os(watchOS)
            return WKInterfaceDevice.current().systemName
            #elseif os(OSX)
            return "macOS"
            #elseif os(Linux)
            return "Linux"
            #elseif os(Windows)
            return "Windows"
            #else
            fatalError("not supported")
            #endif
        }
    }
    
    private func operatingSystemVersionFromProcess() -> String {
        var osVersion: String = "\(ProcessInfo.processInfo.operatingSystemVersion.majorVersion).\(ProcessInfo.processInfo.operatingSystemVersion.minorVersion)"
        if ProcessInfo.processInfo.operatingSystemVersion.patchVersion > 0 {
            osVersion += ".\(ProcessInfo.processInfo.operatingSystemVersion.patchVersion)"
        }
        return osVersion
    }
}
