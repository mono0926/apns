import XCTest
import APNS

struct Custom: Codable, CustomPayload {
    let test: String
}

class apnsTests: XCTestCase {
    var target: APNS!
    func testSend() throws {
        // 設定ファイルから初期化
        target = try APNS(configPath: "/Users/mono/Documents/Config.plist")

        // 普通の引数でもOK
//        target = try APNS(keyPath: "YOUR_p8_KEY_PATH",
//                          keyId: "YOUR_KEY_ID",
//                          teamId: "YOUR_TEAM_ID",
//                          environment: .sandbox, .production or .all) // environmentは省略可能

        // 全フィールド、省略可能
        let alert = Alert(title: "title",
                          subtitle: "subtitle",
                          body: "body",
                          titleLocalizationKey: nil,
                          titleLocalizationArguments: nil,
                          actionLocalizationKey: nil,
                          bodyLocalizationKey: nil,
                          bodyLocalizationArguments: nil,
                          launchImage: nil)
        let aps = Aps(alert: alert,
                      badge: nil, // 以下、省略可能
                      sound: "Default",
                      contentAvailable: nil,
                      category: nil,
                      threadId: nil)
        let payload = Payload(aps: aps,
                              custom: Custom(test: "custom-value")) // customは省略可能
        let request = APNSRequest(topic: "com.mono0926.notification.example",
                                  payload: payload,
                                  apnsIdentifier: UUID(), // 以下、省略可能
                                  priority: .immediately,
                                  expiration: Date().addingTimeInterval(3600),
                                  collapseIdentifier: "(　´･‿･｀)")
        
        try target.send(request: request,
                        deviceTokens: ["0c34a62170c1c0be603780e6458b20dc902730094805b87bef896e6f5ed9bbcb"])
    }

    func testSend_JSON() throws {
        target = try APNS(configPath: "/Users/mono/Documents/Config.plist")

        let payload = Payload(aps: try Aps(jsonPath: "/Users/mono/Documents/aps.json"),
                              custom: try Custom(jsonPath: "/Users/mono/Documents/custom.json"))

        let request = APNSRequest(topic: "com.mono0926.notification.example",
                                  payload: payload)

        try target.send(request: request,
                        deviceTokens: ["0c34a62170c1c0be603780e6458b20dc902730094805b87bef896e6f5ed9bbcb"])
    }
}
