import Foundation
import EchoButlerFFI

public final class StellarClient {
    private let handle: OpaquePointer

    public init(config: EchoButlerConfig) throws {
        guard let handle = config.withCStringHandles({ apiKey, baseURL in
            echobutler_stellar_client_new(apiKey, baseURL, config.network.rawValue)
        }) else {
            throw EchoButlerError.invalidConfig("Unable to create StellarClient")
        }

        self.handle = handle
    }

    deinit {
        echobutler_stellar_client_free(handle)
    }

    public func isValidAddress(_ address: String) -> Bool {
        address.withCString { echobutler_is_valid_stellar_address($0) == 1 }
    }

    public func hashPublicKey(_ publicKey: String) -> String? {
        publicKey.withCString { rawPublicKey in
            guard let raw = echobutler_hash_public_key(rawPublicKey) else {
                return nil
            }
            defer { echobutler_free_string(raw) }
            return String(validatingUTF8: raw)
        }
    }

    public func getBalance(
        publicKey: String,
        cancellationHandle: CancellationHandle? = nil,
        timeoutMs: UInt32 = 0
    ) async throws -> StellarBalance {
        guard isValidAddress(publicKey) else {
            throw EchoButlerError.invalidInput("Expected a Stellar public G-address")
        }

        let payload = try await FFIAsync.perform(
            cancellationHandle: cancellationHandle,
            timeoutMs: timeoutMs
        ) { callback, userData, cancelPtr, timeout in
            publicKey.withCString { publicKeyCString in
                echobutler_stellar_get_balance_async(
                    handle,
                    publicKeyCString,
                    callback,
                    userData,
                    cancelPtr,
                    timeout
                )
            }
        }

        return try FFIDecode.decode(StellarBalance.self, from: payload)
    }
}
