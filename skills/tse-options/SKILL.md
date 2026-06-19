---
name: tse-options
description: Fetch Japanese stock option chain data from the Osaka Exchange via JPX. Use this skill when the user wants to see option prices, implied volatility, or strikes for a listed Japanese company — including evaluating protective puts, covered calls, or hedging strategies for TSE stocks. Accepts a 4-digit security code (e.g., 6146 for Disco Corp, 7203 for Toyota). Supports both the nearest and subsequent monthly expiries.
compatibility: Requires curl, sed, awk, grep. No external dependencies.
allowed-tools: bash
---

# TSE Options

Fetch and parse Japanese listed equity options from the Osaka Exchange.

Quick start:

```
scripts/fetch 6146        # Disco Corp, next expiry (default: month 1)
scripts/fetch 6146 0      # nearest expiry
scripts/fetch 7203        # Toyota
scripts/fetch 9984 0      # SoftBank Group, nearest expiry
scripts/fetch 6146 --raw  # raw HTML dump
```

## Output Format

**Header block** — `key=value` pairs:

| Key | Description |
|-----|-------------|
| `code` | 4-digit security code |
| `month` | Expiry index (0=nearest) |
| `expiry` | Expiry month label |
| `underlying_price` | Last price in JPY |
| `underlying_date` | Quote timestamp |
| `trading_date` | Current trading date |
| `last_trading_day` | Option expiry date |
| `hv` | Historical volatility (%) |
| `lot_size` | Shares per contract |

**Option chain** — pipe-delimited rows following the header line `strike|atm|call_bid|call_ask|call_iv|put_bid|put_ask|put_iv`:

| Column | Description |
|--------|-------------|
| `strike` | Strike price (JPY) |
| `atm` | 1 if at-the-money |
| `call_bid` | Call bid (empty if no quote) |
| `call_ask` | Call ask |
| `call_iv` | Call IV (%) |
| `put_bid` | Put bid (empty if no quote) |
| `put_ask` | Put ask |
| `put_iv` | Put IV (%) |

## Data Source

The script fetches the option chain from the Osaka Exchange. Month 1 is the next expiry, month 0 is the front-month.

## Finding Security Codes

The 4-digit code is the TSE stock code. Common examples:

- 6146 — Disco Corporation
- 7203 — Toyota Motor Corporation
- 9984 — SoftBank Group Corp.
- 8035 — Tokyo Electron Ltd.
- 6758 — Sony Group Corporation
- 8306 — Mitsubishi UFJ Financial Group

Not all TSE stocks have listed options. An empty or single-row chain means no options or no active quotes.

## Gotchas

- **Lot sizes** — typically 100 shares per contract. Multiply premium by lot size for total contract cost.
- **No mid price** — the chain shows bid and ask separately. Use the midpoint for fair value.
- **Thin liquidity** — many TSE options have no bid/ask populated. The chain will still show the strike rows but with empty quote fields. Only trade when both sides are filled.
