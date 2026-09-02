import Foundation
import EchoButlerFFI

public struct EchoButlerConfig: Sendable {
    public var apiKey: String
    public var baseURL: String?
    public var network: StellarNetwork

    public init(
        apiKey: String,
        baseURL: String? = nil,
        network: StellarNetwork = .mainnet
    ) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.network = network
    }
}

public enum StellarNetwork: UInt8, Codable, Sendable {
    case mainnet = 0
    case testnet = 1
}

public final class EchoButler {
    public let mood: MoodClient
    public let stellar: StellarClient
    public let social: SocialClient

    public init(config: EchoButlerConfig) throws {
        self.mood = try MoodClient(config: config)
        self.stellar = try StellarClient(config: config)
        self.social = try SocialClient(config: config)
    }
}

public enum EchoButlerVersion {
    public static func current() -> String {
        guard let raw = echobutler_version() else {
            return "unknown"
        }
        defer { echobutler_free_string(raw) }
        return String(validatingUTF8: raw) ?? "unknown"
    }
}
