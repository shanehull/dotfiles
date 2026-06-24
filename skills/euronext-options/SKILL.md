---
name: euronext-options
description: Fetch Euronext stock option chains — search for optionable instruments, discover available expiry dates, and pull full option chains (calls/puts with strikes, bids, asks, lasts, settlements) for any Euronext-listed equity option. Use this skill when the user asks about European stock options, Euronext option chains, LEAPS on European equities, or wants to scan option prices across expiries for stocks like Shell, TotalEnergies, Airbus, or Heineken, even if they don't mention Euronext by name.
compatibility: Requires curl and jq.
allowed-tools: bash
---

# Euronext Options

Fetch stock option chains from Euronext exchanges (Amsterdam, Paris, Milan, Brussels, Lisbon, Oslo).

## Usage

Run `scripts/fetch` with a symbol, exchange, and mode:

```
# Find the symbol/exchange for a company
scripts/fetch --search shell

# Nearest expiry (raw JSON — pipe to jq)
scripts/fetch RD DAMS | jq '.simple[].maturityDate'

# Discover all available expiry dates
scripts/fetch RD DAMS --discover

# Fetch specific expiry (raw HTML — the agent reads the table directly)
scripts/fetch RD DAMS --md 01-12-2030

# Multiple expiries at once
scripts/fetch RD DAMS --md 01-12-2030 --md 01-12-2028

# Underlying instrument info (name, price, ISIN — raw HTML)
scripts/fetch RD DAMS --underlying
```

## Output formats

| Mode           | Output | How to parse                            |
| -------------- | ------ | --------------------------------------- |
| `--search`     | TSV    | `symbol \t exchange` per line           |
| default        | JSON   | pipe to `jq`                            |
| `--md`         | HTML   | agent reads the `<table>` rows directly |
| `--discover`   | text   | `DD-MM-YYYY` dates, one per line        |
| `--underlying` | HTML   | agent reads key/value pairs directly    |

The `--md` HTML contains `<table>` elements with columns: C Settl, C Last, C Bid, C Ask, C link, Strike, P link, P Bid, P Ask, P Last, P Settl. Each expiry has an `<h3>` with the maturity month/year. Values of `-` mean no quote.

## Finding the symbol

If you don't know the symbol/exchange, search by company name. Filter results to `stock-options` (the script does this automatically). Common examples:

| Company       | Symbol | Exchange |
| ------------- | ------ | -------- |
| Shell         | RD     | DAMS     |
| TotalEnergies | TTE    | DPAR     |
| Airbus        | EA1    | DPAR     |
| Heineken      | HEI    | DAMS     |
| Eni           | ENI    | DMIL     |

Some underlyings have multiple option classes (American, European, cash-settled, weekly, mini). The search returns all of them.

## Exchanges

See `references/exchanges.md` for the full list of Euronext derivatives exchanges and their MIC codes.

## Gotchas

- **Maturity date format** — `--md` takes `DD-MM-YYYY` (e.g., `01-12-2030` for Dec 2030), not `MM-DD-YYYY` or `YYYY-MM-DD`.
- **Market hours** — Option prices are delayed 15 minutes. Settlement prices (`settl`) are end-of-day and available even when markets are closed.
- **Thin chains** — Far-dated LEAPS and small-cap underlyings often have no bids/asks. Only settlement prices may exist. The `settl` field is the most reliable for valuation work.
- **Symbol vs ticker** — The Euronext option class symbol (e.g., `RD` for Shell) is NOT the same as the stock ticker (e.g., `SHELL`). Always use `--search` if unsure.
- **Multiple option classes** — Some stocks have American (`1` suffix), European (`9` suffix), cash-settled (`9C`), weekly (`1`-`5` prefix), and mini (`1M` suffix) variants. They have different symbols and may have different liquidity.
- **Dublin** — No stock options listed on Euronext Dublin.
