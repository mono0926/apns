import Foundation

public protocol JsonInitializable {
    init(jsonPath: String) throws
}

extension JsonInitializable where Self: Codable {
    public init(jsonPath: String) throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath))
        self = try JSONDecoder().decode(Self.self,
                                        from: data)
    }
}
