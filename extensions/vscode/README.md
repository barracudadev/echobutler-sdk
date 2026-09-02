# EchoButler SDK for VS Code

EchoButler SDK developer tools — Stellar address validation, mood log snippets, blockchain sync explorer, and live ECHO balance in the status bar.

## Features

- **Check Stellar Balance** — view live XLM / ECHO balance for any account
- **Validate Stellar Address** — quick G-address validation
- **Fund Testnet Account** — top up a testnet account via Friendbot
- **Log Mood** — log mood entries to EchoButler and track streaks
- **Sync Explorer** — watch real-time Stellar transactions in a webview
- **Code Snippets** — TypeScript / JavaScript and Dart boilerplate for the EchoButler SDK

## Usage

Run any command from the Command Palette (`Cmd/Ctrl+Shift+P`) prefixed with `EchoButler:`.

Configure keys under **Settings → Extensions → EchoButler SDK**:

| Setting | Description |
| --- | --- |
| `echobutler.apiKey` | Your EchoButler API key (echobutler.dev/developers) |
| `echobutler.network` | Stellar network: `mainnet` or `testnet` |
| `echobutler.statusBarPublicKey` | Public key for the live status-bar ECHO balance |
| `echobutler.showStatusBar` | Toggle the live status-bar balance |

To persist your key securely, use the **EchoButler: Sign In** command (stores it in VS Code's secret storage).

## Release Notes

See the [CHANGELOG](../../../CHANGELOG.md).

## License

MIT