import Foundation
import JWT
import CLibreSSL

extension JWT {
    private func time(with key: String) -> Date? {
        guard let interval = payload[key]?.double else { return nil }
        return Date(timeIntervalSince1970: interval)
    }
    var issuedAtTime: Date? { return time(with: "iat") }
}

class AuthenticationKey {
    let privateKey: String
    let publicKey: String
    let keyId: String
    let teamId: String
    private var cache: (jwt: JWT, token: String)?
    func getToken() throws -> String {
        let now = Date()
        if let cache = cache, let issuedAtTime = cache.jwt.issuedAtTime, issuedAtTime > now.addingTimeInterval(-60*55) {
            return cache.token
        }
        let jwt = try JWT(additionalHeaders: [KeyID(keyId)],
                          payload: JSON(.object(["iss":.string(teamId), "iat": .number(.int(Int(now.timeIntervalSince1970.rounded())))])),
                          signer: ES256(key: privateKey.bytes.base64Decoded))
        let token = try jwt.createToken()
        let jwtToVerify = try JWT(token: token)
        try jwtToVerify.verifySignature(using: ES256(key: publicKey.bytes.base64Decoded))
        self.cache = (jwt, token)
        return token
    }

    init(path: String, keyId: String, teamId: String) throws {
        (self.privateKey, self.publicKey) = try AuthenticationKey.extractKeys(from: path)
        self.keyId = keyId
        self.teamId = teamId
    }

    private static func extractKeys(from path: String) throws -> (privateKey: String, publicKey: String) {
        guard FileManager.default.fileExists(atPath: path) else {
            throw APNSError.unknown
        }

        var pKey = EVP_PKEY_new()
        let fp = fopen(path, "r")
        PEM_read_PrivateKey(fp, &pKey, nil, nil)
        fclose(fp)

        guard let ecKey = EVP_PKEY_get1_EC_KEY(pKey) else {
            throw APNSError.unknown
        }

        EC_KEY_set_conv_form(ecKey, POINT_CONVERSION_UNCOMPRESSED)

        var _pub: UnsafeMutablePointer<UInt8>? = nil
        let pubLen = i2o_ECPublicKey(ecKey, &_pub)
        guard let pub = _pub else {
            throw APNSError.unknown
        }

        guard let priKeyHex = BN_bn2hex(EC_KEY_get0_private_key(ecKey)), let priKeyHexString = String(validatingUTF8:priKeyHex) else {
            throw APNSError.unknown
        }
        let pubKeyHexString = Data(bytes: Bytes((0..<Int(pubLen)).map { Byte(pub[$0]) })).hexString

        let priBase64String = String(bytes: Data(hex: "00\(priKeyHexString)").base64Encoded)
        let pubBase64String = String(bytes: Data(hex: pubKeyHexString).base64Encoded)

        return (priBase64String, pubBase64String)
    }
}

struct KeyID: Header {
    static let name = "kid"
    var node: Node
    init(_ keyID: String) {
        node = Node(keyID)
    }
}

