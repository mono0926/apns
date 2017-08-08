import XCTest
import APNS

class APNSTests: XCTestCase {
    var target: APNS!
    private let deviceToken: DeviceToken = "0c34a62170c1c0be603780e6458b20dc902730094805b87bef896e6f5ed9bbcb"

    func testSend_Code() throws {
        // Initialize from the config file
        target = try APNS(configPath: "/Users/mono/Documents/Config.plist")

        // Or from each argument
//        target = try APNS(keyPath: "YOUR_p8_KEY_PATH",
//                          keyId: "YOUR_KEY_ID",
//                          teamId: "YOUR_TEAM_ID",
//                          environment: .sandbox, .production or .all) // environmentは省略可能

        // All fields can be amitted
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
                      badge: nil, // Can be omitted below
                      sound: "Default",
                      contentAvailable: nil,
                      category: nil,
                      threadId: nil)
        let payload = Payload(aps: aps,
                              custom: Custom(test: "custom-value")) //  Can be omitted
        let request = APNSRequest(topic: "com.mono0926.notification.example",
                                  payload: payload,
                                  apnsIdentifier: UUID(), // Can be omitted below
                                  priority: .immediately,
                                  expiration: Date().addingTimeInterval(3600),
                                  collapseIdentifier: "collapse-identifier")
        
        let results = try target.send(request: request,
                        deviceTokens: [deviceToken])
        results.forEach { print($0) }
    }

    func testSend_JSON() throws {
        target = try APNS(configPath: "/Users/mono/Documents/Config.plist")

        let payload = Payload(aps: try Aps(jsonPath: "/Users/mono/Documents/aps.json"),
                              custom: try Custom(jsonPath: "/Users/mono/Documents/custom.json"))

        let request = APNSRequest(topic: "com.mono0926.notification.example",
                                  payload: payload)

        let results = try target.send(request: request,
                                      deviceTokens: [deviceToken])
        results.forEach { print($0) }
    }
}

struct Custom: Codable, CustomPayload {
    let test: String
}
