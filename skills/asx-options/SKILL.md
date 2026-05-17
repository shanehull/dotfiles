---
name: asx-options
description: Fetch ASX equity option data — expiry dates, option chains (calls/puts), bid/ask/last prices, open interest, volume, theoretical prices, and underlying quotes for Australian equities like CBA, BHP, WBC, and XJO.
compatibility: Requires bash and curl. Scripts are bash — invoke directly (e.g. `scripts/asx-options CBA`), not with python.
allowed-tools: bash
---

# ASX Options

Fetch ASX-listed options data via the same API the
[ASX website](https://www.asx.com.au/markets/trade-our-cash-market/asx-equity-options) uses.
Works for both equities (CBA, BHP, WBC) and indices (XJO).

**Base URL:** `https://asx.api.markitdigital.com/asx-research/1.0`

## Gotchas

- **ASX ticker codes only** — use ASX codes (CBA, BHP, WBC, XJO).
  Use `yfinance_search(query="CBA.AX", search_type="quotes")` to resolve
  company names to ASX codes if unsure.
- **Prices in AUD** — all prices in Australian dollars. Contract size is
  always 100 shares.
- **Default styles=all** — returns both American and European. Use
  `--american` or `--european` to filter.
- **Theoretical prices** — `priceTheoretical` is model-generated. May
  diverge from traded prices, especially for deep ITM/OTM strikes.

## Script

Use `scripts/asx-options` to fetch data. Pure bash + curl, zero dependencies.

### Usage

```
scripts/asx-options SYMBOL [options]
```

| Option              | Description                                                                                        |
| ------------------- | -------------------------------------------------------------------------------------------------- |
| `-e, --expiry DATE` | Expiry date YYYY-MM-DD (repeatable). Without this, uses `/options` for quick snapshot + underlying |
| `--calls`           | Calls only (default: `all`)                                                                        |
| `--puts`            | Puts only (default: `all`)                                                                         |
| `--american`        | American-style only (default: `all`)                                                               |
| `--european`        | European-style only                                                                                |
| `--oi-only`         | Contracts with open interest only                                                                  |
| `--lepo`            | Include LEPO/t+0 warrants                                                                          |

**Examples:**

```
scripts/asx-options CBA                              # quick snapshot + underlying
scripts/asx-options CBA -e 2026-05-21                # single expiry
scripts/asx-options CBA -e 2026-05-21 -e 2026-06-18  # multiple expiries
scripts/asx-options BHP --puts -e 2026-05-21 --oi-only
```

## Endpoints

Two endpoints, different behavior:

| Endpoint                 | Use case                                                               |
| ------------------------ | ---------------------------------------------------------------------- |
| `/options`               | Quick snapshot — nearest expiry + underlying quote. No date filtering. |
| `/options/expiry-groups` | Specific expiry dates. Requires `expiryDates[]`. No underlying.        |

The endpoint path is `/derivatives/equity/{symbol}` for everything — ASX uses
the same path for both equities and indices. The script auto-selects:
no `--expiry` → `/options`, with `--expiry` → `/options/expiry-groups`.

### Parameters

| Param                      | Required          | Values                        | Works on      |
| -------------------------- | ----------------- | ----------------------------- | ------------- |
| `callsPuts`                | yes               | `all`, `calls`, `puts`        | both          |
| `expiryDates[]`            | for expiry-groups | YYYY-MM-DD (repeatable)       | expiry-groups |
| `styles`                   | no                | `all`, `american`, `european` | both          |
| `showOpenInterestOnly`     | no                | `true`/`false`                | both          |
| `includeLepoToressOptions` | no                | `true`/`false`                | both          |

### Response Structure

`/options` returns `datesAvailable`, `datesIncluded`, `expiryGroups`, and `underlyingAsset`.

`/options/expiry-groups` returns `items` (array of expiry date groups).

Inside each expiry group:

```
{
  "date": "2026-05-21",
  "exerciseGroups": [
    {
      "priceExercise": 170,
      "periodicity": "Monthly",
      "call":  { ... per-contract fields ... },
      "put":   { ... per-contract fields ... }
    }
  ]
}
```

### Per-Contract Fields

| Field                   | Description                       |
| ----------------------- | --------------------------------- |
| `symbol`                | ASX option symbol (e.g. `CBAKZ8`) |
| `priceExercise`         | Strike price                      |
| `priceBid` / `priceAsk` | Bid / ask                         |
| `priceLast`             | Last traded price                 |
| `priceTheoretical`      | Model-generated price             |
| `openInterest`          | Contracts outstanding             |
| `volume`                | Trading volume                    |
| `dateExpiry`            | Expiry date                       |
| `periodicity`           | `Monthly`, `Weekly`, `Quarterly`  |
| `style`                 | `American` or `European`          |
| `contractSize`          | Always `100`                      |
| `chainType`             | `Call` or `Put`                   |
| `optionRoot`            | Root symbol                       |
| `xid`                   | Unique identifier                 |

### Underlying Asset Fields (`/options` only)

| Field                          | Description        |
| ------------------------------ | ------------------ |
| `symbol`                       | ASX code           |
| `displayName`                  | Company full name  |
| `priceLast`                    | Last traded price  |
| `priceBid` / `priceAsk`        | Bid / ask          |
| `priceChange`                  | Daily change (AUD) |
| `priceChangePercent`           | Daily change (%)   |
| `priceDayHigh` / `priceDayLow` | Day high / low     |

## Workflow

1. **Resolve the ASX code** — confirm the ticker (CBA, BHP, WBC, XJO).
2. **Fetch data** — run `scripts/asx-options SYMBOL` for a quick
   snapshot, or `scripts/asx-options SYMBOL -e DATE` for specific
   expiries.
3. **Present data** — report strikes, notable volume/OI, or extract
   specific contracts.
