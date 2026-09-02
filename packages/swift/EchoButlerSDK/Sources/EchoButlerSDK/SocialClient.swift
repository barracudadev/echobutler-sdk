import Foundation
import EchoButlerFFI

public final class SocialClient {
    private let handle: OpaquePointer
    private let config: EchoButlerConfig

    public init(config: EchoButlerConfig) throws {
        guard let handle = config.withCStringHandles({ apiKey, baseURL in
            echobutler_social_client_new(apiKey, baseURL, config.network.rawValue)
        }) else {
            throw EchoButlerError.invalidConfig("Unable to create SocialClient")
        }

        self.handle = handle
        self.config = config
    }

    deinit {
        echobutler_social_client_free(handle)
    }

    public func profile(
        userId: String,
        cancellationHandle: CancellationHandle? = nil,
        timeoutMs: UInt32 = 0
    ) async throws -> UserProfile {
        guard !userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw EchoButlerError.invalidInput("userId cannot be empty")
        }

        let payload = try await FFIAsync.perform(
            cancellationHandle: cancellationHandle,
            timeoutMs: timeoutMs
        ) { callback, userData, cancelPtr, timeout in
            userId.withCString { userIdCString in
                echobutler_social_profile_async(
                    handle,
                    userIdCString,
                    callback,
                    userData,
                    cancelPtr,
                    timeout
                )
            }
        }

        return try FFIDecode.decode(UserProfile.self, from: payload)
    }

    /// Subscribe to real-time feed/leaderboard updates.
    ///
    /// Returns an `AsyncSequence` of live `SocialLiveEvent`s; iterate with
    /// `for await`. The underlying WebSocket reconnects with backoff and
    /// performs gap-detection/backfill on reconnect (see
    /// `SocialSubscription`). Provide `backfill` to replay `feed:new_entry`
    /// events missed while disconnected; otherwise a `connectionGap` is
    /// emitted on reconnect.
    ///
    /// - Parameters:
    ///   - transport: An injectable transport (defaults to a
    ///     `WebSocketSocialTransport`). Provide a mock in tests.
    ///   - backfill: Re-fetches feed entries published since an id, oldest first.
    public func realtime(
        transport: any SocialRealtimeTransport = WebSocketSocialTransport(),
        backfill: (@Sendable (String) async throws -> [GlobalFeedEntry])? = nil
    ) -> SocialSubscription {
        SocialSubscription(
            transport: transport,
            wsURL: Self.wsURL(for: config),
            backfill: backfill
        )
    }

    /// Derive the social WebSocket endpoint from an API base URL.
    /// `https://host/v1` → `wss://host/v1/social/ws`.
    static func wsURL(for config: EchoButlerConfig) -> URL {
        let base = config.baseURL ?? "https://api.echobutler.dev/v1"
        var host = base
        if host.hasPrefix("https://") {
            host = "wss://" + String(host.dropFirst("https://".count))
        } else if host.hasPrefix("http://") {
            host = "ws://" + String(host.dropFirst("http://".count))
        }
        let url = URL(string: host) ?? URL(string: "wss://api.echobutler.dev/v1")!
        return url.appendingPathComponent("social/ws")
    }
}
