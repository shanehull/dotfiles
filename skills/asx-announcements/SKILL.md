---
name: asx-announcements
compatibility: Requires bash, curl, and awk.
description: Search and fetch ASX company announcements — latest 5 by symbol, paginated by date with symbol filter, or company directory with industry/market-cap/name filters. Use this skill when the user asks about ASX announcements, company filings, market-sensitive news, or wants to fetch or search ASX announcements for Australian listed companies, even if they don't name the ASX or Markit Digital API directly.
---

# ASX Announcements

Fetch ASX-listed company announcements via the Markit Digital API.
Uses `scripts/asx-announcements` (bash + curl + awk).

## Gotchas

- **ASX ticker codes only** — resolve names with `--directory` or `yfinance_search`.
- **Timestamps in UTC** — `--date` filter applies in Sydney timezone. Defaults to today Sydney.
- **Latest 5 only with bare SYMBOL** — any flag switches to paginated date feed. `SYMBOL alone → latest 5. SYMBOL + any flag → paginated by date, filtered by symbol. Multi-symbol or no SYMBOL → paginated by date. --directory → company directory.
- **Zero results ≠ error** — `{"data":{"items":[]}}` means the query succeeded but nothing matched. Try a different date or remove `--price-sensitive`.
- **Multi-date queries** — use `--days-back N` with `--pages`. Each day paginates per `--pages`; 90 days × 8 pages = 720 API calls, takes minutes.
- **Output format** — without symbol filter: raw JSON (`data.items[]`). With symbol filter: NDJSON (one item per line). Zero matches returns `{"data":{"items":[]}}`.

## Usage

```
scripts/asx-announcements [SYMBOL] [options]
```

| Option                     | Description                               |
| -------------------------- | ----------------------------------------- |
| `-d, --date YYYY-MM-DD`    | Sydney date (default: today).             |
| `--days-back N`            | Scan N days back (uses --pages per date). |
| `-p, --price-sensitive`    | Price-sensitive only.                     |
| `-P, --pages N`            | Pages (default: 1, 0=unlimited).          |
| `-l, --limit N`            | Max results (0=unlimited).                |
| `--pdf DOCKEY`             | Download PDF by document key.             |
| `--pdf-dir DIR`            | Directory for PDFs (default: .).          |
| `--output FILE`            | Output path for `--pdf`.                  |
| `--directory`              | List company directory.                   |
| `--name-like TEXT`         | Company name prefix (e.g. A).             |
| `--industry TEXT`          | Filter by industry (repeatable).          |
| `--market-cap-bucket TEXT` | Market cap bucket (repeatable).           |
| `--per-page N`             | Directory items per page (default: 100).  |
| `--order asc\|desc`        | Directory sort order (default: asc).      |
| `--order-by FIELD`         | Directory sort field.                     |

**Examples:**

```
scripts/asx-announcements                                       # all companies today
scripts/asx-announcements --date=2026-05-21 --price-sensitive   # price-sensitive only
scripts/asx-announcements CBA                                   # CBA latest 5
scripts/asx-announcements CBA --date=2026-05-21                 # CBA full day
scripts/asx-announcements CBA,BHP --date=2026-05-21             # multi-ticker
scripts/asx-announcements --pdf DOCKEY --output ~/ann.pdf       # PDF download
scripts/asx-announcements --directory                           # all companies A-Z
scripts/asx-announcements --directory --industry Banks          # banks only
scripts/asx-announcements --directory --name-like A --industry Banks --market-cap-bucket "Large Caps"
scripts/asx-announcements --directory --order-by marketCap --order desc
```

## Reference

see `references/industries.md` for valid `--industry` and `--market-cap-bucket` values.
