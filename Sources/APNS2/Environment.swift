import Foundation

public struct Environment: OptionSet {
    public let rawValue: UInt8

    public static let sandbox = Environment(rawValue: 0b01)
    public static let production = Environment(rawValue: 0b01)
    public static let all = Environment(rawValue: 0b11)

    var urls: [URL] {
        var r = [String]()
        if self.contains(.sandbox) {
            r.append("https://api.development.push.apple.com")
        }
        if self.contains(.production) {
            r.append("https://api.push.apple.com")
        }
        return r.map { URL(string: "\($0)/3/device/")! }
    }

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    public init?(identifier: String) {
        let lowercased = identifier.lowercased()
        if lowercased == "sandbox" {
            self = .sandbox
        } else if lowercased == "production" {
            self = .production
        } else if lowercased == "all" {
            self = .all
        } else {
            return nil
        }
    }
}
