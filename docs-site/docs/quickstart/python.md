---
sidebar_position: 5
---

# Python Quickstart

The native Python package exposes asynchronous mood, Stellar, and social clients through PyO3 bindings over EchoButler's Rust core.

## Install

```bash
python -m venv .venv
source .venv/bin/activate  # Windows PowerShell: .venv\Scripts\Activate.ps1
pip install echobutler-sdk
```

If a wheel is not yet available for your platform, follow the source-build instructions in the package's [Python README](https://github.com/Echo-Mirror-Butler/echobutler-sdk/tree/main/crates/echobutler-python).

## Log a mood and inspect Stellar state

```python
import asyncio
import os

from echobutler import EchoButler, StellarNetwork


async def main():
    app = EchoButler(
        api_key=os.environ["ECHOBUTLER_API_KEY"],
        network=StellarNetwork.Testnet,
    )

    entry = await app.mood.log(score=8, note="Great day", tags=["work"])
    balance = await app.stellar.get_balance(os.environ["STELLAR_PUBLIC_KEY"])
    feed = await app.social.get_global_feed(limit=10)

    print(entry.id, balance.xlm, len(feed))


asyncio.run(main())
```

All calls are `asyncio` coroutines. API failures map to typed exceptions such as `AuthError`, `NotFoundError`, and `RateLimitError`.

## Complete runnable example

The package README includes environment setup, an unsigned payment example, safe signing guidance, type-checking notes, and exact commands for running the complete [`examples/quickstart.py`](https://github.com/Echo-Mirror-Butler/echobutler-sdk/blob/main/crates/echobutler-python/examples/quickstart.py) script against the repository's deterministic contract-test fixture.

- [Python package README](https://github.com/Echo-Mirror-Butler/echobutler-sdk/tree/main/crates/echobutler-python)
- [Core Concepts](../core-concepts)
- [Rust API Reference](pathname:///api/rust/)

