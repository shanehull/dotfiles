---
name: cotality
description: Use this skill when the user asks about Australian property auction results, house prices, recent sales, clearance rates, home value indices, or Cotality/CoreLogic market data — fetches auction clearance rates, home value indices, property sales records, and postcode-level market statistics, even if they don't name Cotality or the API directly.
compatibility: Requires bash and curl.
---

# Cotality

Fetch Australian property market data via Cotality's internal APIs. Uses `scripts/cotality` (bash + curl). Outputs raw JSON — pipe to `jq` for extraction.

The API key is extracted automatically at runtime from `www.cotality.com/au/our-data/auction-results` — no setup needed.

## Usage

```
scripts/cotality <command> [args...]
```

| Command              | Description                                |
| -------------------- | ------------------------------------------ |
| `auctions <state>`   | Weekly auction results (4 weeks back).     |
| `indices`            | Daily/monthly home value indices (public). |
| `suggest <postcode>` | Resolve postcode to numeric locationId.    |
| `stats <locationId>` | Market statistics for a location.          |
| `sales <postcode>`   | Recent property sales in a postcode.       |

**Examples:**

```
scripts/cotality auctions vic                             # VIC auction results
scripts/cotality auctions nsw                             # NSW auction results
scripts/cotality indices                                  # all index data (public)
scripts/cotality indices | jq '.daily[] | {city: .location, value, change, yearlyChangePercent}'
scripts/cotality indices | jq '.monthly[] | {city: .location, houses: .houseValue, units: .unitValue}'
scripts/cotality suggest 2000                             # find locationId for postcode
scripts/cotality suggest 2000 | jq '.suggestions[0].postcodeId'
scripts/cotality stats 101812                             # % stock on market for postcode 2000
scripts/cotality stats 101812 64                          # total listings for postcode 2000
scripts/cotality sales 2000                               # recent sales in 2000
scripts/cotality sales 2000 | jq '.data[].properties[] | {price: .salesLastSoldPrice, address: .addressFirstLine, suburb: .addressSuburb, beds: .bedrooms}'
```

## Gotchas

- **Stats use numeric metric IDs** — `58` = % Stock on Market (12mo), `64` = Total Listings (12mo).
- **`suggest` returns `postcodeId`** — use that as the `locationId` for `stats`, not the postcode string.
