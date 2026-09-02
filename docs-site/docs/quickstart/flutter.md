---
sidebar_position: 3
---

# Flutter Quickstart

## Install

```yaml
dependencies:
  echobutler_sdk: ^0.1.0
```

## Initialize

```dart
import 'package:echobutler_sdk/echobutler_sdk.dart';

void main() async {
  await EchoButler.initialize(
    apiKey: 'your_api_key',
    network: StellarNetwork.testnet,
  );
  runApp(const MyApp());
}
```

## Query balances and mood streaks

```dart
final balance = await EchoButler.instance.stellar.getBalance(publicKey);
final streak  = await EchoButler.instance.mood.getStreak();
```

## Real-time blockchain sync

```dart
final sync = BlockchainSyncClient(EchoButler.instance.config);
sync.watch(publicKey).listen((event) {
  if (event is LedgerSyncEvent) {
    print('New ledger: ${event.ledgerSequence}');
  }
});
```

## Next steps

- [Core Concepts](../core-concepts) � how the sync engine and cursors work
- [Dart API Reference](pathname:///api/dart/) for the full API surface

