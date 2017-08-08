import Foundation

public struct APNS
 {
    let teamId: String
    let environment: Environment
    let key: AuthenticationKey
    private let session = APNSSession()

    public init(keyPath: String,
                keyId: String,
                teamId: String,
                environment: Environment = .all) throws {
        self.teamId = teamId
        self.key = try AuthenticationKey(path: keyPath, keyId: keyId, teamId: teamId)
        self.environment = environment
    }

    public init(configPath: String) throws {
        guard let dict = NSDictionary(contentsOfFile: configPath) else {
            throw APNSError.unknown
        }
        guard let keyPath = dict["KeyPath"] as? String,
            let keyId = dict["KeyId"] as? String,
            let teamId = dict["TeamId"] as? String,
            let environmentString = dict["Environment"] as? String,
            let environment = Environment(identifier: environmentString) else {
                throw APNSError.unknown
        }
        try self.init(keyPath: keyPath, keyId: keyId, teamId: teamId, environment: environment)
    }

    public func send(request: APNSRequest, deviceTokens: [DeviceToken]) throws {
        try deviceTokens.forEach {
            try send(request: request, deviceToken: $0)
        }
    }

    public func send(request: APNSRequest, deviceToken: DeviceToken) throws {
        let urlRequests = try environment.urls.map { url in
            return try createURLRequest(request: request,
                                        url: url.appendingPathComponent(deviceToken.value))
        }
        DispatchQueue.concurrentPerform(iterations: urlRequests.count) { i in
            let r = session.sendSync(request: urlRequests[i])
            print(r)
        }
    }
    private func createURLRequest(request: APNSRequest, url: URL) throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        urlRequest.addValue("bearer \(try key.getToken())",
            forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json",
                            forHTTPHeaderField: "Accept")

        let encoder = JSONEncoder()

        guard let headers = try JSONSerialization.jsonObject(with: try encoder.encode(request.header)) as? [String: Any] else {
            throw APNSError.unknown
        }
        headers.forEach {
            urlRequest.addValue(String(describing: $0.value), forHTTPHeaderField: $0.key)
        }

        let aps = try JSONSerialization.jsonObject(with: try encoder.encode(request.payload.aps))
        let payload = try { () -> Any in
            let apsPayload = ["aps": aps]
            if let custom = request.payload.custom {
                return try custom.toJSON().merging(apsPayload) { _, aps in aps }
            }
            return apsPayload
        }()
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: payload)
        return urlRequest
    }
}
