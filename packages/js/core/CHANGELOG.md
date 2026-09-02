# @echobutler/core

## 0.1.0 — 2026-08-19

### Added

- Initial release of `@echobutler/core`
- `EchoButlerClient` with API key and JWT auth, configurable base URL and network (`testnet` / `mainnet`)
- `EchoButlerConfig` builder with `testnet()` / `mainnet()` convenience constructors
- Shared TypeScript types: `MoodEntry`, `StellarBalance`, `EchoUser`, `ApiResponse`, `EchoButlerError`
- `setAuthToken` / `clearAuthToken` for runtime JWT management
- Full ESM + CJS dual-build via `tsconfig`
