---
name: asx-options
description: Fetch ASX equity option and warrant data: option chains (expiry dates, strikes, bid/ask, open interest, volume, theoretical prices) and listed warrants including Citi MINIs (long and short), rolling instalments and instalment MINIs, plus underlying quotes for Australian equities like CBA, BHP, WBC and LLC. Use this skill when the user asks about ASX options, warrants, MINIs, or a hedge or leveraged long/short view on an ASX-listed stock, even if they don't say "options" or "warrants".
compatibility: Requires bash and curl. Scripts are bash — invoke directly (e.g. `scripts/asx-options CBA`), not with python.
allowed-tools: bash
---

# ASX Options and Warrants

Fetch option chains and listed warrants for an ASX ticker. Options cover equities
(CBA, BHP, WBC) and indices (XJO); warrants (Citi MINIs and instalments) cover
equities only. Pure bash + curl, zero dependencies.

## Usage

```
scripts/asx-options SYMBOL [options]
scripts/asx-warrants SYMBOL
```

### Options

Without `--expiry`, returns the nearest expiry plus the underlying quote.

| Option              | Description                                       |
| ------------------- | ------------------------------------------------- |
| `-e, --expiry DATE` | Expiry date YYYY-MM-DD (repeatable)               |
| `--calls`           | Calls only (default: `all`)                       |
| `--puts`            | Puts only (default: `all`)                        |
| `--american`        | American-style only (default: `all`)              |
| `--european`        | European-style only                               |
| `--oi-only`         | Contracts with open interest only                 |
| `--lepo`            | Include LEPO/t+0 warrants                         |

```
scripts/asx-options CBA                              # nearest expiry + underlying
scripts/asx-options CBA -e 2026-05-21                # single expiry
scripts/asx-options CBA -e 2026-05-21 -e 2026-06-18  # multiple expiries
scripts/asx-options BHP --puts -e 2026-05-21 --oi-only
```

### Warrants

Returns JSON grouped by Calls and Puts; MINI longs sit under Calls, MINI shorts
under Puts.

```
scripts/asx-warrants LLC
scripts/asx-warrants LLC | jq -r '.data.items[].items[] | [.symbol,.name,.priceExercise,.priceLast]|@tsv'
```

## Workflow

1. **Resolve the ASX code**: confirm the ticker (CBA, BHP, WBC, XJO).
2. **Fetch options**: `scripts/asx-options SYMBOL`, or `-e DATE` for specific expiries.
3. **Fetch warrants**: `scripts/asx-warrants SYMBOL`.
4. **Present**: strikes, notable volume/OI, MINI knock-outs, or specific contracts.

## Gotchas

- **ASX ticker codes only** — use ASX codes (CBA, BHP, WBC, XJO). Use
  `yfinance_search(query="CBA.AX", search_type="quotes")` to resolve names.
- **Prices in AUD** — all prices in Australian dollars. Option contract size is
  always 100 shares.
- **Default styles=all** — returns both American and European. Use
  `--american` or `--european` to filter.
- **Theoretical prices** — `priceTheoretical` is model-generated and may diverge
  from traded prices, especially for deep ITM/OTM strikes.
- **Coverage is partial** — probe both scripts before concluding a name is
  hedgeable; many stocks list one and not the other, and some list neither.
- **Warrants are Citi only** — every contract is issued by Citigroup (CTW).
- **Warrant quotes are thin** — MINIs trade rarely and `priceLast` is often
  stale; cross-check `priceValuation` and treat the quote as indicative.
