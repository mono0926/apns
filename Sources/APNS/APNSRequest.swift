import Foundation

public struct APNSRequest {
    let header: APNSHeader
    let payload: Payload

    public init(topic: String,
                payload: Payload,
                apnsIdentifier: UUID? = nil,
                priority: Priority = .immediately,
                expiration: Date? = nil,
                collapseIdentifier: String? = nil) {
        self.payload = payload
        self.header = APNSHeader(topic: topic,
                                 identifier: apnsIdentifier?.uuidString,
                                 expiration: Int(expiration?.timeIntervalSince1970.rounded() ?? 0),
                                 priority: priority.rawValue,
                                 collapseIdentifier: collapseIdentifier)
    }
}
