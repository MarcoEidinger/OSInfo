#if os(OSX)
#else
import UIKit
#endif
import Foundation

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
            #if os(macOS) || targetEnvironment(macCatalyst)
            return "\(ProcessInfo.processInfo.operatingSystemVersion.majorVersion).\(ProcessInfo.processInfo.operatingSystemVersion.minorVersion).\(ProcessInfo.processInfo.operatingSystemVersion.patchVersion)"
            #elseif os(iOS)
            return UIDevice.current.systemVersion
            #elseif os(tvOS)
            return UIDevice.current.systemVersion
            #elseif os(watchOS)
            return WKInterfaceDevice.current().systemVersion
            #elseif os(OSX)
            return "\(ProcessInfo.processInfo.operatingSystemVersion.majorVersion).\(ProcessInfo.processInfo.operatingSystemVersion.minorVersion).\(ProcessInfo.processInfo.operatingSystemVersion.patchVersion)"
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
            #elseif os(OSX)
            return "\(ProcessInfo.processInfo.operatingSystemVersion.majorVersion).\(ProcessInfo.processInfo.operatingSystemVersion.minorVersion).\(ProcessInfo.processInfo.operatingSystemVersion.patchVersion)"
            //return ProcessInfo.processInfo.operatingSystemVersionString
            #else
            return DeviceDataValue.unknown
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
            #else
            return DeviceDataValue.unknown
            #endif
        } else {
            // only available on iOS and tvOS
            #if os(iOS)
            return UIDevice.current.systemName
            #elseif os(tvOS)
            return UIDevice.current.systemName
            #elseif os(OSX)
            return "macOS"
            #else
            return DeviceDataValue.unknown
            #endif
        }

    }
}
