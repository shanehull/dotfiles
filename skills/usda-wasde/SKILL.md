---
name: usda-wasde
description: Fetch USDA WASDE data — production, supply, and demand forecasts for agricultural commodities via the FAS PSD API or historical WASDE reports (text, XML, CSV). Use this skill when the user asks about crop reports, commodity supply/demand, WASDE reports, or any agricultural data, even if they don't name USDA or WASDE directly.
compatibility: Requires network access and a free USDA API key (https://api.data.gov/signup/) exported as USDA_FAS_API_KEY.
allowed-tools: bash
---

# USDA WASDE Data

Access USDA World Agricultural Supply and Demand Estimates (WASDE) and
Production, Supply & Distribution (PSD) data through two sources:

1. **FAS PSD API** — REST API at `api.fas.usda.gov`. Requires a free API key
   from [api.data.gov/signup](https://api.data.gov/signup/) set as
   `USDA_FAS_API_KEY` in environment.

2. **Historical WASDE reports** — Monthly report snapshots in text, XML, or CSV
   format downloaded from `usda.gov`. No API key needed. Goes back to 2010.



## Gotchas

- **API key required for PSD** — The PSD API returns 403 without
  `USDA_FAS_API_KEY` set. Get one free at https://api.data.gov/signup/.
- **PSD vs WASDE** — The PSD API returns current (revised) data. WASDE
  reports are as-published snapshots (not revised).
- **CSV path may fail** — The CSV lives on a different CDN path
  (`sites/default/files/documents/`) that can be slow or unreachable on some
  networks. Text and XML formats (on `oce/commodity/wasde/`) are preferred.
- **No WASDE report date filter** — The PSD API doesn't allow filtering by
  WASDE report release date/month. Parameter is `marketYear` only.
- **Marketing years** — Market years are numeric (e.g. 2026 for the
  2025/2026 season). Use the later calendar year as the key.
- **Historical coverage** — PSD API has data back to ~1960. WASDE reports go
  back to April 2010.

## Scripts

### `wasde`

Download a WASDE report from usda.gov. No API key needed. Defaults to
readable text format; pass `--csv` for legacy CSV or `--xml` for structured
XML. Tries standard URL first, then v2--v9 revisions.

Usage:

```
scripts/wasde [--raw] [--csv|--xml] <year> <month>
```

| Option        | Description                        |
| ------------- | ---------------------------------- |
| `--raw`       | Print full content                 |
| `--csv`       | Legacy CSV format                  |
| `--xml`       | Structured XML format              |
| `-h`/`--help` | Show help                          |

Examples:

```
# Preview the May 2026 WASDE report (text)
scripts/wasde 2026 05

# Full text output
scripts/wasde --raw 2026 05 > wasde-2026-05.txt

# XML format for parsing
scripts/wasde --xml --raw 2026 05
```

### `psd-commodities`

List all PSD commodities with codes and descriptions. Requires `USDA_FAS_API_KEY`.

Usage:

```
scripts/psd-commodities
```

### `psd-data`

Fetch PSD supply/demand data for a commodity and year. Requires `USDA_FAS_API_KEY`.

Usage:

```
scripts/psd-data [--country <code>|all] <commodityCode> <marketYear>
```

| Option             | Description                                    |
| ------------------ | ---------------------------------------------- |
| `--country <code>` | Country code (e.g. BR, AR, US) or "all".       |
|                    | Default: world aggregate.                      |
| `-h/--help`        | Show help                                      |

Examples:

```
# World corn supply/demand for 2026
scripts/psd-data 0440000 2026

# All countries, soybeans, 2025
scripts/psd-data --country all 2222000 2025

# Brazil corn, 2026
scripts/psd-data --country BR 0440000 2026

# US wheat, 2025
scripts/psd-data --country US 0410000 2025
```

### `psd-request`

Generic PSD API request. Prepends base URL and auth header. Requires `USDA_FAS_API_KEY`.

Usage:

```
scripts/psd-request <path>
```

`path` is the endpoint path after `/api/psd/` (e.g. `commodities`, `countries`, `commodityAttributes`).

Examples:

```
scripts/psd-request commodities
scripts/psd-request countries
scripts/psd-request regions
scripts/psd-request unitsOfMeasure
scripts/psd-request commodity/0440000/dataReleaseDates
```

## Workflows

### Get latest WASDE report

```bash
scripts/wasde --raw 2026 05
```

### Explore available commodities

```bash
scripts/psd-commodities
```

### Fetch world-level supply/demand for a commodity

```bash
scripts/psd-data 0440000 2026    # Corn
scripts/psd-data 2222000 2025    # Soybeans
```

### Compare country-level data

```bash
scripts/psd-data --country BR 0440000 2026    # Brazil corn
scripts/psd-data --country US 0440000 2026    # US corn
scripts/psd-data --country AR 2222000 2025    # Argentina soybeans
```

### List all countries for a commodity across all years

```bash
scripts/psd-data --country all 0410000 2025   # Wheat, all countries
```

### Discover API metadata

```bash
scripts/psd-request commodities
scripts/psd-request countries
scripts/psd-request commodityAttributes
scripts/psd-request unitsOfMeasure
```

## Reference

### API Host

```
Base: https://api.fas.usda.gov/api/psd/
Host: api.fas.usda.gov
Auth: Header X-Api-Key (free from https://api.data.gov/signup/)
```

### Key Commodity Codes

| Code    | Commodity     |
|---------|---------------|
| 0440000 | Corn          |
| 0410000 | Wheat         |
| 2222000 | Soybeans      |
| 2224000 | Soybean Meal  |
| 2226000 | Soybean Oil   |
| 0422110 | Rice, Milled  |
| 0430000 | Barley        |
| 0611000 | Cotton        |

### PSD Data Fields

PSD records contain:
- `commodityCode` — string code (e.g. `0440000`)
- `countryCode` — country code
- `marketYear` — marketing year (integer)
- `calendarYear` — calendar year
- `attributeId` — numeric attribute ID (map via `/psd/commodityAttributes`)
- `unitId` — unit of measure ID (map via `/psd/unitsOfMeasure`)
- `value` — forecast value

Common attribute IDs:
- 01 = Beginning Stocks
- 02 = Production
- 03 = Imports
- 04 = Total Supply
- 05 = Exports
- 06 = Feed & Residual
- 07 = Food, Seed & Industrial
- 08 = Total Domestic Use
- 09 = Ending Stocks
