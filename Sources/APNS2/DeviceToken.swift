public struct DeviceToken {
    let value: String
}

extension DeviceToken: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral value: String) {
        self.value = value
    }
}
