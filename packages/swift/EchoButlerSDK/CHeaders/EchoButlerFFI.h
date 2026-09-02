#ifndef ECHOBUTLER_FFI_H
#define ECHOBUTLER_FFI_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum EchoButlerFfiErrorCode {
    ECHOBUTLER_ERROR_OK = 0,
    ECHOBUTLER_ERROR_NULL_POINTER = 1,
    ECHOBUTLER_ERROR_INVALID_UTF8 = 2,
    ECHOBUTLER_ERROR_INVALID_CONFIG = 3,
    ECHOBUTLER_ERROR_INVALID_INPUT = 4,
    ECHOBUTLER_ERROR_RUNTIME = 5,
    ECHOBUTLER_ERROR_NETWORK = 6,
    ECHOBUTLER_ERROR_SERIALIZATION = 7,
    ECHOBUTLER_ERROR_CANCELLED = 8,
    ECHOBUTLER_ERROR_TIMEOUT = 9,
} EchoButlerFfiErrorCode;

typedef void (*EchoButlerAsyncCallback)(void *user_data, int32_t code, char *payload);

// Fully opaque (no body) — Swift imports a pointer to these as `OpaquePointer`,
// which is exactly what MoodClient.swift/StellarClient.swift/SocialClient.swift expect.
typedef struct EchoButlerMoodClient EchoButlerMoodClient;
typedef struct EchoButlerStellarClient EchoButlerStellarClient;
typedef struct EchoButlerSocialClient EchoButlerSocialClient;

// This one needs a (placeholder, never read/written) body: CancellationHandle's
// Swift code holds it as `UnsafeMutablePointer<EchoButlerCancellationHandle>`,
// not `OpaquePointer`, and Swift's ClangImporter only exposes a nominal type
// name for *complete* C structs — a bare forward declaration like the three
// above imports fine as `OpaquePointer` but can't be named directly.
typedef struct EchoButlerCancellationHandle {
    uint8_t _opaque;
} EchoButlerCancellationHandle;

void echobutler_free_string(char *ptr);
char *echobutler_version(void);

uint8_t echobutler_verify_mood_score(uint8_t score);
char *echobutler_hash_public_key(const char *public_key);
uint8_t echobutler_is_valid_stellar_address(const char *address);
char *echobutler_serialize_cursor(
    uint32_t ledger_sequence,
    const char *paging_token,
    uint64_t total_processed
);

// Cancellation handle
EchoButlerCancellationHandle *echobutler_cancellation_new(void);
void echobutler_cancellation_cancel(EchoButlerCancellationHandle *handle);
uint8_t echobutler_cancellation_is_cancelled(const EchoButlerCancellationHandle *handle);
void echobutler_cancellation_free(EchoButlerCancellationHandle *handle);

EchoButlerMoodClient *echobutler_mood_client_new(
    const char *api_key,
    const char *base_url,
    uint8_t network
);
void echobutler_mood_client_free(EchoButlerMoodClient *client);
int32_t echobutler_mood_log_async(
    const EchoButlerMoodClient *client,
    const char *user_id,
    uint8_t score,
    const char *note,
    const char *tags_json,
    EchoButlerAsyncCallback callback,
    void *user_data,
    const EchoButlerCancellationHandle *cancellation_handle,
    uint32_t timeout_ms
);

EchoButlerStellarClient *echobutler_stellar_client_new(
    const char *api_key,
    const char *base_url,
    uint8_t network
);
void echobutler_stellar_client_free(EchoButlerStellarClient *client);
int32_t echobutler_stellar_get_balance_async(
    const EchoButlerStellarClient *client,
    const char *public_key,
    EchoButlerAsyncCallback callback,
    void *user_data,
    const EchoButlerCancellationHandle *cancellation_handle,
    uint32_t timeout_ms
);

EchoButlerSocialClient *echobutler_social_client_new(
    const char *api_key,
    const char *base_url,
    uint8_t network
);
void echobutler_social_client_free(EchoButlerSocialClient *client);
int32_t echobutler_social_profile_async(
    const EchoButlerSocialClient *client,
    const char *user_id,
    EchoButlerAsyncCallback callback,
    void *user_data,
    const EchoButlerCancellationHandle *cancellation_handle,
    uint32_t timeout_ms
);

#ifdef __cplusplus
}
#endif

#endif
