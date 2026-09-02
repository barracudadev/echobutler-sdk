---
sidebar_position: 1
title: VS Code Extension
---

# EchoButler VS Code Extension

The EchoButler VS Code extension brings Stellar wallet tools, mood logging, and blockchain sync monitoring directly into your editor.

## Install

### From Source (Development)

```bash
cd extensions/vscode
npm install
npm run build
```

Then press `F5` in VS Code to launch the Extension Development Host, or package with `npm run package` and install the resulting `.vsix`.

### From VS Code Marketplace

_search "EchoButler SDK" in the Extensions panel (once published)._

## Features

### Status Bar — Live ECHO Balance

When `echobutler.statusBarPublicKey` is set and `echobutler.showStatusBar` is `true`, a status bar item on the right shows your live ECHO token balance. Click it to refresh.

### Log Mood (`echobutler.logMood`)

Opens a multi-step quick pick:

1. Select a mood score (1–10)
2. Optionally add a note
3. Optionally select tags (`work`, `health`, `social`, `focus`, `stress`)

The mood status bar item updates with a colored indicator (green ≥ 7, yellow ≥ 4, red < 4).

### View Streak (`echobutler.viewStreak`)

Shows your current and longest mood logging streaks in a notification.

### Check Stellar Balance (`echobutler.checkBalance`)

Fetches XLM and ECHO balances for a Stellar public key. Uses the configured `statusBarPublicKey` if set, otherwise prompts for a G-address.

### Validate Stellar Address (`echobutler.validateAddress`)

Validates that an address is a well-formed Stellar G-address (56 alphanumeric characters starting with `G`).

### Fund Testnet Account (`echobutler.fundTestnet`)

Funds a testnet account with 10,000 XLM via Friendbot. Only available when `echobutler.network` is set to `testnet`.

### Open Sync Explorer (`echobutler.openSyncExplorer`)

Opens a webview panel that streams real-time Stellar transactions for any account. The panel connects to the Stellar Horizon API for the configured network and displays transactions as they arrive.

- Pre-fills with `statusBarPublicKey` if configured
- Shows a network badge (`testnet` / `mainnet`)
- Auto-starts watching when a key is pre-filled
- Events are color-coded: green for transactions, red for errors

### Insert Mood Log Snippet (`echobutler.insertMoodLogSnippet`)

Inserts a code snippet for logging mood. Detects the active editor language:

- **Dart**: Inserts `EchoButler.instance.mood.log(...)` snippet
- **TypeScript/JavaScript**: Inserts `logMood(client, {...})` snippet

### Sign In / Sign Out (`echobutler.signIn`, `echobutler.signOut`)

Manages your EchoButler API key. The key is stored in VS Code's encrypted SecretStorage — it is never written to settings or disk in plaintext.

## Configuration

| Setting | Type | Default | Description |
|---|---|---|---|
| `echobutler.apiKey` | string | `""` | EchoButler API key (use Sign In command instead) |
| `echobutler.network` | `"mainnet"` \| `"testnet"` | `"testnet"` | Stellar network to connect to |
| `echobutler.statusBarPublicKey` | string | `""` | Public key for live ECHO balance in status bar |
| `echobutler.showStatusBar` | boolean | `true` | Show live ECHO balance in status bar |

## Snippets

The extension provides code snippets for TypeScript and JavaScript:

| Prefix | Description |
|---|---|
| `em-mood` | Log a mood entry |
| `em-streak` | Get the user's mood streak |
| `em-balance` | Get Stellar XLM and ECHO balance |
| `em-freighter` | Connect Freighter wallet |
| `em-send` | Send ECHO tokens |
| `em-provider` | Wrap app with EchoButler React Provider |
| `em-friendbot` | Fund a testnet account |
| `em-sync` | Start a blockchain sync engine |
| `echobutler-init` | Boilerplate EchoButler client setup |

## Known Limitations

- The Sync Explorer panel uses Horizon REST polling (5-second intervals), not the full SSE-based sync engine. For production sync, use `@echobutler/core` or the Rust `echobutler-sync` crate directly.
- The `echobutler.apiKey` setting in VS Code configuration is redundant — the extension reads the API key from SecretStorage only. Use the Sign In command.
- The Activity Bar sidebar views (`Blockchain Sync Explorer`, `Stellar Wallet`) are declared but not yet wired to TreeDataProviders. Use the command palette to open the Sync Explorer panel.
