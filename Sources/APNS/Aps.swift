import Foundation
/// https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/PayloadKeyReference.html#//apple_ref/doc/uid/TP40008194-CH17-SW1
public struct Aps: Codable, JsonInitializable {
    let alert: Alert?
    let badge: Int?
    let sound: String?
    let contentAvailable: Int?
    let category: String?
    let threadId: String?

    public init(alert: Alert?,
         badge: Int? = nil,
         sound: String? = nil,
         contentAvailable: Int? = nil,
         category: String? = nil,
         threadId: String? = nil) {
        self.alert = alert
        self.badge = badge
        self.sound = sound
        self.contentAvailable = contentAvailable
        self.category = category
        self.threadId = threadId
    }

    private enum CodingKeys: String, CodingKey {
        case
        alert,
        badge,
        sound,
        contentAvailable = "content-available",
        category,
        threadId = "thread-id"
    }
}
