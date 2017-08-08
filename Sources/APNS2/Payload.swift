import Foundation

public struct Payload {
    public let aps: Aps
    public let custom: CustomPayload?

    public init(aps: Aps, custom: CustomPayload? = nil) {
        self.aps = aps
        self.custom = custom
    }
}

public protocol CustomPayload: JsonInitializable {
    func toJSON() throws -> [String: Any]
}

extension CustomPayload where Self: Encodable {
    public func toJSON() throws -> [String: Any] {
        guard let headers = try JSONSerialization.jsonObject(with: try JSONEncoder().encode(self)) as? [String: Any] else {
            throw APNSError.unknown
        }
        return headers
    }
}
