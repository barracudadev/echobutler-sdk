# echobutler-sdk (Python)

Official Python SDK for [EchoButler](https://echobutler.dev) — mood tracking with Stellar-powered rewards.

Native bindings (PyO3 + maturin) over the same Rust core that powers the JS and Flutter SDKs — every call is real native code and returns a proper `asyncio` coroutine, so nothing blocks the event loop.

## Install

```bash
python -m venv .venv
source .venv/bin/activate  # Windows PowerShell: .venv\Scripts\Activate.ps1
pip install echobutler-sdk
```

The package targets Python 3.9–3.12. If a wheel for your platform is not yet available, build the checkout with [maturin](https://www.maturin.rs/):

```bash
git clone https://github.com/Echo-Mirror-Butler/echobutler-sdk.git
cd echobutler-sdk/crates/echobutler-python
pip install maturin
maturin develop --release
```

## Quickstart

Set the API key issued by your EchoButler deployment, then create one client for mood, Stellar, and social operations:

```bash
export ECHOBUTLER_API_KEY="your_api_key"
# Windows PowerShell: $env:ECHOBUTLER_API_KEY = "your_api_key"
```

```python
import asyncio
import os

from echobutler import EchoButler, StellarNetwork

async def main():
    app = EchoButler(
        api_key=os.environ["ECHOBUTLER_API_KEY"],
        network=StellarNetwork.Testnet,
    )

    entry = await app.mood.log(score=8, note="Great day", tags=["work", "proud"])
    print(f"Logged mood {entry.score}/10")

    balance = await app.stellar.get_balance(os.environ["STELLAR_PUBLIC_KEY"])
    print(f"{balance.xlm} XLM • {balance.echo} ECHO")

    payment = await app.stellar.build_transfer(
        from_address=os.environ["STELLAR_PUBLIC_KEY"],
        to_address=os.environ["STELLAR_DESTINATION"],
        amount=5.0,
        memo="Great energy today",
    )
    print(f"Unsigned payment XDR ({payment.fee} stroops): {payment.xdr}")

    feed = await app.social.get_global_feed(limit=10)
    print(f"{len(feed)} entries in the global feed")

asyncio.run(main())
```

`build_transfer` deliberately returns an **unsigned** XDR. Sign it with the account owner's wallet or signer before calling `submit_transaction`; never put a secret key in source code or environment variables used by this example.

For a complete script that also demonstrates authentication, a fixture-backed payment submission, and typed error handling, see [`examples/quickstart.py`](https://github.com/Echo-Mirror-Butler/echobutler-sdk/blob/main/crates/echobutler-python/examples/quickstart.py).

## Run the complete example safely

The repository's contract-test fixture is deterministic and never broadcasts a Stellar transaction. From the repository root, start both fixture roles and run the example with one command:

```bash
python crates/echobutler-python/examples/quickstart.py --start-fixture
```

The example defaults to the fixture URLs and keys from `contract-tests/contract-spec.json`. Without `--start-fixture`, override its `ECHOBUTLER_*` and `STELLAR_*` environment variables to point at an already running fixture or another test deployment.

## Sub-clients

Each sub-client also works standalone against a shared `EchoButlerClient` — handy if you only need one slice of the API:

```python
from echobutler import EchoButlerClient, MoodClient, StellarClient, SocialClient, StellarNetwork

client = EchoButlerClient("your_api_key", network=StellarNetwork.Mainnet)
mood = MoodClient(client)
stellar = StellarClient(client)
social = SocialClient(client)
```

## Error handling

All errors inherit from `EchoButlerException`:

```python
from echobutler import AuthError, RateLimitError, NotFoundError, EchoButlerException

try:
    await app.mood.get_streak()
except AuthError:
    ...  # invalid or expired API key
except RateLimitError:
    ...  # back off and retry
except NotFoundError:
    ...
except EchoButlerException as e:
    ...  # anything else
```

HTTP 401, 404, and 429 responses map to `AuthError`, `NotFoundError`, and `RateLimitError`; transport and server failures remain catchable through `EchoButlerException`.

## Type checking

The package ships `py.typed` and type stubs. Editors using Pyright and projects running `mypy` can catch mistakes before execution—for example, `await app.mood.log(score="8")` is rejected because `score` must be an `int`.

## Testnet

```python
app = EchoButler(api_key="your_api_key", network=StellarNetwork.Testnet)
await app.stellar.fund_testnet_account("GPUBLIC_KEY")  # Friendbot: 10,000 XLM
```

## Development

```bash
pip install maturin pytest pytest-asyncio
maturin develop --release
pytest
```

## License

MIT
