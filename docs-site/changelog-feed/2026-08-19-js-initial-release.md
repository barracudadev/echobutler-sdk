---
title: "EchoButler SDK — Initial JS package releases (v0.1.0 / v0.2.0)"
date: 2026-08-19
authors: [echobutler]
tags: [release, js, npm, stellar, mood, analytics, wasm, react, social]
description: >
  First wave of EchoButler SDK JavaScript packages published to npm:
  @echobutler/core, mood, react, social, analytics, wasm (v0.1.0) and
  @echobutler/stellar (v0.2.0).
---

The first wave of EchoButler SDK JavaScript / TypeScript packages are now
available on npm. All packages follow [Semantic Versioning](https://semver.org).

{/* truncate */}

## What shipped

| Package | Version | Highlights |
|---|---|---|
| `@echobutler/core` | 0.1.0 | API client, JWT auth, shared types |
| `@echobutler/mood` | 0.1.0 | Mood logging, streaks, AI reflections |
| `@echobutler/stellar` | **0.2.0** | Multi-wallet (Freighter/Albedo/xBull), ECHO payments, typed errors |
| `@echobutler/react` | 0.1.0 | Provider, hooks (`useMoodStreak`, `useStellarBalance`) |
| `@echobutler/social` | 0.1.0 | Global feed, leaderboard, real-time SSE updates |
| `@echobutler/analytics` | 0.1.0 | Privacy-safe UX event tracking, client-side aggregation |
| `@echobutler/wasm` | 0.1.0 | Rust-compiled WASM — dual browser + Node.js target |

## Install

```bash
npm install @echobutler/core @echobutler/mood @echobutler/stellar
```

## Full changelog

See the [aggregated changelog](/docs/changelog) for detailed per-package
release notes, or subscribe to the generated RSS and Atom files under the
release-feed route to be notified of future releases.
