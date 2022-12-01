import Foundation

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

    public init(from versionString: String) {
        let components = versionString.components(separatedBy: ".")
        let major = Int(components.first ?? "0") ?? 0
        let minor: Int = components.count > 1 ? Int(components[1]) ?? 0 : 0
        let patch: Int = components.count == 3 ? Int(components.last!) ?? 0 : 0
        self.init(majorVersion: major, minorVersion: minor, patchVersion: patch)
    }
}
