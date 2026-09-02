import Foundation
import EchoButlerFFI

public final class MoodClient {
    private let handle: OpaquePointer

    public init(config: EchoButlerConfig) throws {
        guard let handle = config.withCStringHandles({ apiKey, baseURL in
            echobutler_mood_client_new(apiKey, baseURL, config.network.rawValue)
        }) else {
            throw EchoButlerError.invalidConfig("Unable to create MoodClient")
        }

        self.handle = handle
    }

    deinit {
        echobutler_mood_client_free(handle)
    }

    public func isValidScore(_ score: UInt8) -> Bool {
        echobutler_verify_mood_score(score) == 1
    }

    public func logMood(
        userId: String,
        score: UInt8,
        note: String? = nil,
        tags: [String] = [],
        cancellationHandle: CancellationHandle? = nil,
        timeoutMs: UInt32 = 0
    ) async throws -> MoodEntry {
        guard isValidScore(score) else {
            throw EchoButlerError.invalidInput("Mood score must be between 1 and 10")
        }

        let tagsData = try JSONEncoder().encode(tags)
        let tagsJSON = String(decoding: tagsData, as: UTF8.self)

        let payload = try await FFIAsync.perform(
            cancellationHandle: cancellationHandle,
            timeoutMs: timeoutMs
        ) { callback, userData, cancelPtr, timeout in
            userId.withCString { userIdCString in
                tagsJSON.withCString { tagsCString in
                    if let note {
                        return note.withCString { noteCString in
                            echobutler_mood_log_async(
                                handle,
                                userIdCString,
                                score,
                                noteCString,
                                tagsCString,
                                callback,
                                userData,
                                cancelPtr,
                                timeout
                            )
                        }
                    }

                    return echobutler_mood_log_async(
                        handle,
                        userIdCString,
                        score,
                        nil,
                        tagsCString,
                        callback,
                        userData,
                        cancelPtr,
                        timeout
                    )
                }
            }
        }

        return try FFIDecode.decode(MoodEntry.self, from: payload)
    }
}
