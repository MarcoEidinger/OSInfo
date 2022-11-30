# OSInfo

Cross-platform Swift Package to determine the operating system `name` and `version` on which the app is running

```swift
import OSInfo

// example for running on iPhone
print(OS.current.name) // "iOS"
print(OS.current.version) // OperatingSystemVersion(majorVersion:16, minorVersion:1,patchVersion:0)
print(OS.current.version.description) // "16.1"
print(OS.current.displayVersion) // "Version 16.1 (Build 20B72)"

// example for running on Apple Watch
print(OS.current.name) // "watchOS"
print(OS.current.version.description) // "9.1"
print(OS.current.displayVersion) // "Version 9.1 (Build 20S75)"

// example for running on Mac
print(OS.current.name) // "macOS"
print(OS.current.version.description) // "13.0.1"
print(OS.current.displayVersion) // "Version 13.0.1 (Build 22A400)"

// example for running on Mac Catalyst
print(OS.current.name) // "macOS"
print(OS.current.version.description) // "13.0.1"
print(OS.current.displayVersion) // "Version 13.0.1 (Build 22A400)"

// -- alternative

print(OS(underlyingMacOS: false).name) // "iPadOS"
print(OS(underlyingMacOS: false).version.description) // "16.1"

// example for running on Linux
print(OS.current.name) // Linux
print(OS.current.version) // 5.15
print(OS.current.displayVersion) // Ubuntu 22.04.1 LTS
```

This package provides a unified API so that you don't need to worry about the various underlying APIs like
- UIKit's `UIDevice.current.systemName` and `.systemVersion`
- WatchKit's `WKInterfaceDevice.current().systemName` and `.systemVersion`
- Foundations's `ProcessInfo.processInfo.operatingSystemVersionString` and `.operatingSystemVersion`

Here are `name` examples based on the destination. One key aspect of this package is that it provides an option for Mac Catalyst / Mac Designed for iPad applications to get either the "iOS support version" or the underlying macOS version.

| Destination                                                  | OS.shared.name                          | OS().name |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- |
| iPhone                                                       | iOS                                                          | iOS           |
| iPad                                                         | iPadOS                                                       | iPadOS        |
| Mac (Designed for iPad)<br /><br />~ an iOS app running on Apple silicon | **macOS** | iPadOS        |
| Mac (Mac Catalyst)                                           | **macOS**   | iPadOS        |
| Mac                                                         | macOS                                                      | macOS         |
| TV                                                           | tvOS                                                         | tvOS          |
| Watch                                                        | watchOS                                                      | watchOS       |
| Linux                                                        | Linux                                                          | Linux           |
Windows                                                      | Windows           | Windows | 

Note:
- `OS.current` is equivalent to `OS(underlyingMacOS: true)`
- `OS()` is equivalent to `OS(underlyingMacOS: false)`
