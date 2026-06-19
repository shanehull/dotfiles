---
name: sqm-research
description: Fetch Australian property listing data from SQM Research — stock on market, rental listings, asking prices, and vacancy rates by postcode. Use this skill when the user wants listing volumes, supply trends, stale listing ratios, or postcode-level property market health, even if they don't name SQM Research.
compatibility: Requires bash, curl, jq.
---

# SQM Research

Fetch postcode-level Australian property market data from SQM Research. Parses embedded chart data from their public pages. Uses `scripts/sqm` (bash + curl + python3). Outputs raw JSON — pipe to `jq` for extraction.

No API key or authentication needed.

## Usage

```
scripts/sqm <command> [args...]
```

| Command               | Description                                |
| --------------------- | ------------------------------------------ |
| `listings <postcode>` | Stock on market (total property listings). |
| `rentals <postcode>`  | Rental listings count.                     |
| `asking <postcode>`   | Asking property prices.                    |
| `vacancy <postcode>`  | Vacancy rates.                             |

All commands accept `--months N` (default: 6).

**Examples:**

```
scripts/sqm listings 3095                      # Eltham stock on market, last 6 months
scripts/sqm listings 3095 --months 12          # Eltham, last 12 months
scripts/sqm listings 3095 | jq '.data[-1]'     # Latest month only
scripts/sqm listings 3095 | jq '.comparison'   # YoY change summary
scripts/sqm listings 3095 | jq '[.data[] | {month: "\(.year)-\(.month)", total, r30, stale: .r180p}]'
```

## Output Fields (listings)

Each data entry has year, month, and listing-age buckets:

| Field   | Meaning                       |
| ------- | ----------------------------- |
| `r30`   | Listed within 30 days (fresh) |
| `r60`   | Listed 30-60 days ago         |
| `r90`   | Listed 60-90 days ago         |
| `r180`  | Listed 90-180 days ago        |
| `r180p` | Listed 180+ days ago (stale)  |
| `total` | Computed sum of all buckets   |

The `comparison` object (when 12+ months available) has `latest_total`, `year_ago_total`, `yoy_change`, `yoy_pct`.

## Gotchas

- **Listing-age buckets are cumulative by listing age, not time-on-market** — `r180p` is properties listed 180+ days ago, not properties that have spent 180+ days on the market (though in practice these are highly correlated).
- **Postcodes only, not suburbs** — use numeric postcodes (e.g., `3095` not `Eltham`). SQM resolves by postcode.
- **Asking prices and vacancy rates may have different JSON structures** — the script attempts the same extraction pattern but field names vary by page type.
