"""EchoButler Python SDK.

Async Python bindings for the EchoButler API — mood tracking, Stellar wallet
operations, and social features — powered by native Rust (PyO3) bindings over
the same `echobutler-core` / `echobutler-stellar` crates used by the Rust,
JS, and Flutter SDKs.

Quickstart:

    import asyncio
    from echobutler import EchoButler, StellarNetwork

    async def main():
        app = EchoButler(api_key="your_api_key", network=StellarNetwork.Testnet)
        entry = await app.mood.log(score=8, note="Great day", tags=["work"])
        print(entry.id, entry.score)

    asyncio.run(main())
"""

from ._echobutler import (
    AiReflection,
    AuthError,
    ConfigError,
    EchoButler,
    EchoButlerClient,
    EchoButlerException,
    GlobalFeedEntry,
    LeaderboardEntry,
    MoodClient,
    MoodEntry,
    MoodHistoryPage,
    MoodStreak,
    MoodSummary,
    NetworkError,
    NotFoundError,
    RateLimitError,
    SocialClient,
    StellarBalance,
    StellarClient,
    StellarNetwork,
    StellarTransaction,
    TransactionHistoryPage,
    UnsignedTransaction,
    UserProfile,
    __version__,
)

__all__ = [
    "AiReflection",
    "AuthError",
    "ConfigError",
    "EchoButler",
    "EchoButlerClient",
    "EchoButlerException",
    "GlobalFeedEntry",
    "LeaderboardEntry",
    "MoodClient",
    "MoodEntry",
    "MoodHistoryPage",
    "MoodStreak",
    "MoodSummary",
    "NetworkError",
    "NotFoundError",
    "RateLimitError",
    "SocialClient",
    "StellarBalance",
    "StellarClient",
    "StellarNetwork",
    "StellarTransaction",
    "TransactionHistoryPage",
    "UnsignedTransaction",
    "UserProfile",
    "__version__",
]
