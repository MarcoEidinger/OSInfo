# OSInfo

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FMarcoEidinger%2FOSInfo%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/MarcoEidinger/OSInfo)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FMarcoEidinger%2FOSInfo%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/MarcoEidinger/OSInfo)

Cross-platform Swift Package to report the operating system `name` and `version` on which the app is running

Key Aspects:
- a **cross-platform** API that works for iOS, iPadOS, watchOS, tvOS, visionOS, macOS, Mac Catalyst, Linux and Windows
- a **universal** API so that you don't need to worry about the various underlying APIs (`UIDevice` vs. `WKInterfaceDevice` vs. `ProcessInfo`)
- Dealing with the fact that iOS Apps on Mac and Mac Catalyst deal with two versions, the macOS version the app is running on (or targeting) and the iOS (support) version that macOS version corresponds with.
  - The package **default behavior** is to obtain the **underlying macOS version** while still having the option to get the "iOS support version" if desired.

```swift
import OSInfo

// Example for running on iPhone
print(OS.current.name) // "iOS"
print(OS.current.version) // OperatingSystemVersion(majorVersion:16, minorVersion:1,patchVersion:0)
print(OS.current.version.description) // "16.1"
print(OS.current.displayVersion) // "Version 16.1 (Build 20B72)"

// Example for running on iPad
print(OS.current.name) // "iPadOS"
print(OS.current.version.description) // "16.1"
print(OS.current.displayVersion) // "Version 16.1 (Build 20B72)"
print(OS.current.iOSFamily) // true

// Example for running on Apple Watch
print(OS.current.name) // "watchOS"
print(OS.current.version.description) // "9.1"
print(OS.current.displayVersion) // "Version 9.1 (Build 20S75)"

// Example for running on Apple Vision (natively)
print(OS.current.name) // "visionOS"
print(OS.current.version.description) // "1.0"
print(OS.current.displayVersion) // "Version 9.1 (Build 20S75)"

// Example for running on Apple Vision (natively)
print(OS.current.name) // "visionOS"
print(OS.current.version.description) // "1.0"
print(OS.current.displayVersion) // "Version 1.0 (Build 21N5165g)"
print(OS.current.iOSFamily) // true

// Example for running on Apple Vision (Designed with iPad) with SDK "iOS"
print(OS.current.name) // "iPadOS"
print(OS.current.version.description) // "1.0"
print(OS().version.description) // "17.0"
print(OS.current.displayVersion) // "Version 1.0 (Build 21N5165g)"
print(OS.current.iOSFamily) // true

// Example for running on Mac
print(OS.current.name) // "macOS"
print(OS.current.version.description) // "13.0.1"
print(OS.current.displayVersion) // "Version 1.0 (Build 21N5165g)"
print(OS.current.appleFamily) // true

// Example for running as Mac Catalyst (or unmodified iOS app) on Mac
print(OS.current.name) // "macOS"
print(OS.current.version.description) // "13.0.1"
// -- alternative
print(OS(underlyingMacOS: false).name) // "iPadOS"
print(OS(underlyingMacOS: false).version.description) // "16.1"

print(OS.current.displayVersion) // "Version 13.0.1 (Build 22A400)"

// Example for running on Linux
print(OS.current.name) // Linux
print(OS.current.version) // 5.15
print(OS.current.displayVersion) // Ubuntu 22.04.1 LTS
print(OS.current.appleFamily) // false
```

Note:
- `OS.current` is equivalent to `OS(underlyingMacOS: true)`
- `OS()` is equivalent to `OS(underlyingMacOS: false)`
