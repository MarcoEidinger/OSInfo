# OSInfo

Cross-platform Swift Package to determine OS name and version on which the app is running

```swift
import OSVersion

print(OSInfo.shared.name) // iOS
print(OSInfo.shared.version) // 16.1
```

This package provides a unified API so that you don't need to worry about the various underlying APIs like
- UIKit's `UIDevice.current.systemName` and `.systemVersion`
- WatchKit's `WKInterfaceDevice.current().systemName` and `.systemVersion`
- Foundations's `ProcessInfo.processInfo.operatingSystemVersionString` and `.operatingSystemVersion`

Here are examples based on the destination:

| Destination                                                  | OSInfo.shared.name                          | OSInfo().name |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------- |
| iPhone                                                       | iOS                                                          | iOS           |
| iPad                                                         | iPadOS                                                       | iPadOS        |
| Mac (Designed for iPad)<br /><br />~ an iOS app running on Apple silicon | **macOS** | iPadOS        |
| Mac (Mac Catalyst)                                           | **macOS**   | iPadOS        |
| Mac                                                         | macOS                                                      | macOS         |
| TV                                                           | tvOS                                                         | tvOS          |
| Watch                                                        | watchOS                                                      | watchOS       |
| Linux                                                        | ???                                                          | ???           |
Windows                                                      | ???           | ??? | 

This package also provides an option to either get the underlying macOS version or the "iOS support version" in case of a Mac Catalyst / Mac Designed for iPad application.

Note:
- `OSInfo()` is equivalent to `OSInfo(underlyingMacOS: false)`
- `OSInfo.shared` is equivalent to `OSInfo(underlyingMacOS: true)`

If you are more interesting on how to compare versions then I recommend the article [Swift System Version Checking](https://nshipster.com/swift-system-version-checking/)
