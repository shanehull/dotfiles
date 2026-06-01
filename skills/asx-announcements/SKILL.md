---
name: asx-announcements
compatibility: Requires bash, curl, awk, and jq.
description: Use this skill when the user asks about ASX company announcements, filings, or market-sensitive news for Australian listed companies. Fetches latest 5 by ticker, scans broadly with date and ticker filters, or browses the company directory.
---

# ASX Announcements

Fetch ASX-listed company announcements.

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
scripts/asx-announcements CBA,BHP --date=2026-05-21             # multi-ticker
scripts/asx-announcements --pdf DOCKEY --output ~/ann.pdf       # PDF download
scripts/asx-announcements --directory                           # all companies A-Z
scripts/asx-announcements --directory --industry Banks          # banks only
scripts/asx-announcements --directory --name-like A --industry Banks --market-cap-bucket "Large Caps"
scripts/asx-announcements --directory --order-by marketCap --order desc
```

## Gotchas

- **ASX ticker codes only** — resolve names with `--directory` or `yfinance_search`.
- **`--date`** defaults to today in Sydney timezone.
- **Single company** → latest 5 as JSON. Only `--price-sensitive` does anything: filters the results to price-sensitive announcements only.
- **Multiple companies or no company** → scans broadly. Supports `--date`, `--pages`, `--limit`, `--days-back`, `--price-sensitive`. May miss some announcements.
- **`--days-back N`** scans N days. Slow: 30 days = 30+ requests, takes minutes.
- **Output** — single company: JSON. Multiple/no company: raw JSON or one result per line.
- **Zero results** — `{"data":{"items":[]}}` means nothing matched.

## Reference

see `references/industries.md` for valid `--industry` and `--market-cap-bucket` values.
