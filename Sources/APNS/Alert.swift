import Foundation
/// https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/PayloadKeyReference.html#//apple_ref/doc/uid/TP40008194-CH17-SW1
public struct Alert: Codable {
    let title: String?
    let subtitle: String?
    let body: String?
    let titleLocalizationKey: String?
    let titleLocalizationArguments: [String]?
    let actionLocalizationKey: String?
    let bodyLocalizationKey: String?
    let bodyLocalizationArguments: [String]?
    let launchImage: String?

    public init(title: String? = nil,
                subtitle: String? = nil,
                body: String? = nil,
                titleLocalizationKey: String? = nil,
                titleLocalizationArguments: [String]? = nil,
                actionLocalizationKey: String? = nil,
                bodyLocalizationKey: String? = nil,
                bodyLocalizationArguments: [String]? = nil,
                launchImage: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.titleLocalizationKey = titleLocalizationKey
        self.titleLocalizationArguments = titleLocalizationArguments
        self.actionLocalizationKey = actionLocalizationKey
        self.bodyLocalizationKey = bodyLocalizationKey
        self.bodyLocalizationArguments = bodyLocalizationArguments
        self.launchImage = launchImage
    }


    private enum CodingKeys: String, CodingKey {
        case
        title,
        subtitle,
        body,
        titleLocalizationKey = "title-loc-key",
        titleLocalizationArguments = "title-loc-args",
        actionLocalizationKey = "action-loc-key",
        bodyLocalizationKey = "loc-key",
        bodyLocalizationArguments = "loc-args",
        launchImage = "launch-image"
    }
}
