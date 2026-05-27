---
name: wb-pink-sheet
description: Fetch World Bank Pink Sheet commodity price data — monthly and annual historical prices for energy, agriculture, fertilizers, and metals. Use this skill when the user asks about commodity prices, World Bank commodity data, the Pink Sheet, CMO data, or historical commodity price trends, even if they don't mention the Pink Sheet or World Bank by name.
allowed-tools: bash
---

# World Bank Pink Sheet Commodity Prices

Monthly and annual historical commodity price data published by the World Bank
Prospects Group (the "Pink Sheet"). Covers energy, agriculture, fertilizers,
metals & minerals, and precious metals — nominal and real price indices plus
individual commodity series.

Scripts are in `scripts/`.

## Scripts

### `pink`

Download the latest Pink Sheet data files (monthly Excel, annual Excel, or
current month's PDF).

Usage:

```
scripts/pink [options]
```

| Option         | Description                                              |
| -------------- | -------------------------------------------------------- |
| `--type TYPE`  | File type: `monthly` (default), `annual`, `pdf`          |
| `--output DIR` | Output directory (default: current dir)                  |
| `--doc-id ID`  | Explicit document ID (skip scraping)                     |
| `--month MON`  | PDF month name, e.g. `May` (default: current month)      |
| `--year YR`    | PDF year (default: current year)                         |
| `--latest`     | Fetch the latest PDF by trying current and recent months |
| `--raw`        | Print the download URL instead of downloading            |
| `--series`     | List series codes (downloads to /tmp if not cached)      |
| `--find TEXT`  | Search series codes (downloads to /tmp if not cached)    |
| `--data CODE`  | Extract specific series (repeatable, downloads to /tmp)  |
| `--recent N`   | Show last N rows (default: 5, implies --data)            |
| `--all`        | Extract all data rows (downloads to /tmp if not cached)  |

Without `--doc-id`, the script fetches the commodity markets page and extracts
the current doc ID from the Monthly prices link.

Download-only examples:

```
# Download the monthly historical data Excel
scripts/pink

# Download to ~/data/
scripts/pink --output ~/data

# Download the annual historical data
scripts/pink --type annual

# Get the current download URL without downloading
scripts/pink --raw

# Download a specific month's PDF
scripts/pink --type pdf --month April --year 2026
```

Extraction examples (auto-downloads/caches monthly xlsx in /tmp):

```
# List all series
scripts/pink --series

# Search for oil-related series
scripts/pink --find crude

# Get recent crude oil and gold prices
scripts/pink --data CRUDE_PETRO --data GOLD

# Get last 12 months of corn prices
scripts/pink --data MAIZE --recent 12

# Full export
scripts/pink --all > pink.csv
```

## Workflows

### Get the latest monthly commodity prices

```bash
scripts/pink
ls CMO-Historical-Data-Monthly.xlsx
```

### Find a series code and extract its data

```bash
# Search for available series codes (downloads xlsx to /tmp if not cached)
scripts/pink --find crude
scripts/pink --find natural

# Extract data for the codes found
scripts/pink --data CRUDE_BRENT --data NGAS_US --recent 24
```

### Download and extract all data to CSV

```bash
scripts/pink --all > pink-data.csv
```

### Get latest prices for specific commodities

```bash
scripts/pink --data CRUDE_PETRO --data NGAS_US --data GOLD --recent 12
```

### Find the current doc ID manually

Visit https://www.worldbank.org/en/research/commodity-markets
Look for "Monthly prices" link — the doc ID is the UUID in the URL path.

## Gotchas

- **No official REST API for the data** — the data is published as Excel files
  (.xlsx) on thedocs.worldbank.org, linked from the commodity markets page.
- **Doc ID changes periodically** — the URL includes a document ID that is
  updated each year. The `pink` script scrapes the current ID from the
  commodity markets page, or you can pass it explicitly with `--doc-id`.
- **XLSX format** — the data is in Excel format with specific row/column layout.
  Read `references/excel-format.md` for the exact structure (sheets, row layout,
  series codes, header hierarchy, date format).
- **Monthly vs Annual** — the monthly file (~1.5MB) is the most current. The
  annual file has yearly averages. Both are updated monthly.

## Reference

### Key URLs

| Resource                   | URL                                                                                       |
| -------------------------- | ----------------------------------------------------------------------------------------- |
| Commodity Markets homepage | `https://www.worldbank.org/en/research/commodity-markets`                                 |
| Monthly data (current doc) | `https://thedocs.worldbank.org/en/doc/{DOC_ID}/related/CMO-Historical-Data-Monthly.xlsx`  |
| Annual data                | `https://thedocs.worldbank.org/en/doc/{DOC_ID}/related/CMO-Historical-Data-Annual.xlsx`   |
| Monthly PDF                | `https://thedocs.worldbank.org/en/doc/{DOC_ID}/related/CMO-Pink-Sheet-{Month}-{Year}.pdf` |

### Data format

Read `references/excel-format.md` for the complete sheet layout, series codes,
header hierarchy, date format, and extraction examples.

### No API key required

The data files are publicly accessible. No registration or API key needed.
