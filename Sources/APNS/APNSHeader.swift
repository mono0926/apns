/// https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingwithAPNs.html#//apple_ref/doc/uid/TP40008194-CH11-SW1
import Foundation

struct APNSHeader: Encodable {
    let topic: String
    let identifier: String?
    let expiration: Int
    let priority: Int
    let collapseIdentifier: String?

    private enum CodingKeys: String, CodingKey {
        case
        topic = "apns-topic",
        identifier = "apns-id",
        expiration = "apns-expiration",
        priority = "apns-priority",
        collapseIdentifier = "apns-collapse-id"
    }
}
