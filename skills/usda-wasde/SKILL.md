---
name: usda-wasde
description: Fetch USDA WASDE data — production, supply, and demand forecasts for agricultural commodities via the FAS PSD API or historical WASDE CSV snapshots. Use this skill when the user asks about crop reports, commodity supply/demand, WASDE reports, or any agricultural data, even if they don't name USDA or WASDE directly.
compatibility: Requires network access and a free USDA API key (https://api.data.gov/signup/) exported as USDA_FAS_API_KEY.
---

# USDA WASDE Data

This skill provides access to the USDA World Agricultural Supply and Demand
Estimates (WASDE) through two data sources:

1. **FAS PSD API** — Production, Supply & Distribution REST API at
   `api.fas.usda.gov`. Requires a free API key from
   [api.data.gov/signup](https://api.data.gov/signup/). Pass via the
   `X-Api-Key` header.

2. **Historical WASDE CSV** — Monthly report snapshots published at
   `usda.gov/sites/default/files/documents/oce-wasde-report-data-YYYY-MM.csv`.
   No API key needed. Goes back to 2010.

## Reference — API Host

```
Base: https://api.fas.usda.gov/api
Host: api.fas.usda.gov
Auth: Header X-Api-Key (free from https://api.data.gov/signup/)
```

## Reference — PSD Endpoints

| Endpoint | Description |
|----------|-------------|
| `GET /psd/commodities` | All commodities with codes (e.g. Corn=0440000) |
| `GET /psd/countries` | All countries with region codes |
| `GET /psd/regions` | Region codes and names |
| `GET /psd/commodityAttributes` | Attribute names (e.g. Production, Ending Stocks) |
| `GET /psd/unitsOfMeasure` | Unit descriptions (e.g. 1000 MT) |
| `GET /psd/commodity/{commodityCode}/dataReleaseDates` | Latest release dates per commodity |
| `GET /psd/commodity/{commodityCode}/world/year/{marketYear}` | World-level data for a commodity/year |
| `GET /psd/commodity/{commodityCode}/country/all/year/{marketYear}` | All countries, commodity/year |
| `GET /psd/commodity/{commodityCode}/country/{countryCode}/year/{marketYear}` | Single country, commodity/year |

## Reference — Key Commodity Codes

| Code    | Commodity     |
|---------|---------------|
| 0440000 | Corn          |
| 0410000 | Wheat         |
| 2222000 | Soybeans      |
| 2224000 | Soybean Meal  |
| 2226000 | Soybean Oil   |
| 0422110 | Rice, Milled  |
| 0430000 | Barley        |
| 0422110 | Rice          |
| 0611000 | Cotton        |

## Reference — Historical WASDE CSV

Format: `https://www.usda.gov/sites/default/files/documents/oce-wasde-report-data-YYYY-MM.csv`

Latest 2026 releases:
- January through May available (May V2)

Year snapshots available back to April 2010. Before 2021, data is in ZIP files
(2010-2015 and 2016-2020).

## Reference — PSD Data Fields

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

## Gotchas

- **API key required** — The PSD API returns 403 without a valid `X-Api-Key`
  header. Get one free at https://api.data.gov/signup/. The header name is
  `X-Api-Key` (not `API_KEY`).
- **Host is `api.fas.usda.gov`** — Not `apps.fas.usda.gov`. The V1 swagger
  at `apps.fas.usda.gov/OpenData` uses a now-deprecated host with an
  `/OpenData` base path. The current API is `api.fas.usda.gov` with no base
  path prefix (endpoints start at `/api/psd/...`).
- **API key source** — Get your key from https://api.data.gov/signup/. The same
  key works across all api.data.gov-backed USDA APIs.
- **Marketing years** — Market years are numeric (e.g. 2026 for the
  2025/2026 season). May use the later calendar year as the key.
- **PSD vs WASDE CSV** — The PSD API returns current (revised) data. The
  WASDE CSV downloads are as-published snapshots (not revised). These are
  different datasets and may differ for the same month/year.
- **No WASDE report date filter** — The PSD API doesn't allow filtering by
  WASDE report release date/month. Parameter is `marketYear` only.
- **Historical coverage** — PSD API has data back to ~1960. WASDE CSVs go
  back to April 2010.
- **WASDE CSV naming** — Files follow the pattern
  `oce-wasde-report-data-{YYYY}-{MM}.csv`. May have a `-V2` suffix for
  revised versions. No CSV exists for a month before it's published.
