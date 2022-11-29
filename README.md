# OSInfo
Cross-platform Swift Package to determine OS name and version on which the app is running

| Destination                                                  | OSInfo.oSName | OSInfo(targetAware: true).oSName                             |
| ------------------------------------------------------------ | ------------- | ------------------------------------------------------------ |
| iPhone                                                       | iOS           | iOS                                                          |
| iPad                                                         | iPadOS        | iPadOS                                                       |                                                    |
| Mac (Designed for iPad)<br /><br />this might be a Mac app built with Mac Catalyst  or an iOS app running on Apple silicon. | iPadOS        | **macOS** |
| Mac (Mac Catalyst)                                           | iPadOS        | **macOS**   
| Mac                                                         | macOS         | macOS                                                      |
| TV                                                           | tvOS          | tvOS                                                         |
| Watch                                                        | watchOS       | watchOS                                                      |
| Linux                                                        | ???           | ???                                                          |

https://github.com/jonathanwong/teal-swift/blob/992c185423d907ed86aa3148e0939aca11b96ae1/tealium/core/devicedata/DeviceDataOSInfo.swift

```swift
#if os(OSX)
#else
import UIKit
#endif
import Foundation

#if os(watchOS)
import WatchKit
#endif

// MARK: OS Info
public extension DeviceData {
    class var oSBuild: String {
        guard let build = Bundle.main.infoDictionary?["DTSDKBuild"] as? String else {
            return DeviceDataValue.unknown
        }
        return build

    }

    class var oSVersion: String {
        // only available on iOS and tvOS
        #if os(iOS)
        return UIDevice.current.systemVersion
        #elseif os(tvOS)
        return UIDevice.current.systemVersion
        #elseif os(watchOS)
        return WKInterfaceDevice.current().systemVersion
        #elseif os(OSX)
        return ProcessInfo.processInfo.operatingSystemVersionString
        #else
        return DeviceDataValue.unknown
        #endif
    }

    class var oSName: String {
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
```

Alternative https://github.com/lidongx/Adapty/blob/01ef0c4d6f9147cf62d19b312a1107818209f9df/Classes/UserProperties.swift

```swift
    static var OS: String {
        #if os(macOS) || targetEnvironment(macCatalyst)
        return "macOS \(ProcessInfo().operatingSystemVersionString)"
        #else
        return "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        #endif
    }
    
    static var platform: String {
        #if os(macOS) || targetEnvironment(macCatalyst)
        return "macOS"
        #else
        return UIDevice.current.systemName
        #endif
    }
```

General Info: https://nshipster.com/swift-system-version-checking/

To be tested on
- iPhone / iOS
- iPad / iPadOS
- MacCatalyst
- Mac
- Linux
- tvOS
- watchOS


P.S.: PLCrashReporter handles it like this (https://github.com/microsoft/plcrashreporter/blob/b1a342da19ed9b3af61ea2efa7656c2af30aeb7c/Source/PLCrashLogWriter.m#L459)

```swift
#if TARGET_OS_IPHONE || TARGET_OS_MAC
    /* iOS, tvOS, macOS and Mac Catalyst */
    {
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        NSOperatingSystemVersion systemVersion = processInfo.operatingSystemVersion;
        NSString *systemVersionString = [NSString stringWithFormat:@"%ld.%ld", (long)systemVersion.majorVersion, (long)systemVersion.minorVersion];
        if (systemVersion.patchVersion > 0) {
            systemVersionString = [systemVersionString stringByAppendingFormat:@".%ld", (long)systemVersion.patchVersion];
        }
        plprotobuf_cbinary_data_nsstring_init(&writer->system_info.version, systemVersionString);
    }
#else
#error Unsupported Platform
#endif
```
