---
name: eia-energy
description: Fetch U.S. and international energy data from the EIA API v2 — petroleum, natural gas, electricity, coal, nuclear, renewables, state-level data (SEDS), short-term energy outlook (STEO), and country-level energy data. Use this skill when the user asks about energy prices, production, consumption, generation, reserves, storage, or any energy statistics, even if they don't name EIA directly.
compatibility: Requires an EIA API key (free, register at eia.gov/opendata)
allowed-tools: bash
---

# EIA Energy Data

Access the U.S. Energy Information Administration Open Data API (v2). Covers
all major energy categories: petroleum, natural gas, electricity, coal,
renewable energy, nuclear, CO₂ emissions, and state/projection data.

Scripts are in `scripts/`.

## Gotchas

- **API key required** — free at https://www.eia.gov/opendata/register.php.
  Set `EIA_API_KEY` in environment.
- **5000 row max** — JSON format caps at 5000 rows per request. Use `--offset`
  and paginate, or use facets/date ranges to narrow results.
- **Facets are filters** — most datasets have facets like `duoarea`, `sectorid`,
  `stateid`, `product`, `process`. Use `--facets` to filter. Discover facet
  values by querying the route metadata (omit `/data`).
- **Frequency** — each dataset has one or more periodicities: `annual`,
  `monthly`, `weekly`, `daily`. Default is the dataset's native frequency.
  Specify with `--freq`.
- **Date format** — `YYYY` (annual), `YYYY-MM` (monthly), `YYYY-MM-DD` (daily).
- **Route hierarchy** — routes form a tree: `electricity/retail-sales`,
  `natural-gas/pri/sum`, etc. Query a route node (without `/data`) to see
  sub-routes, facets, and metadata.
- **API key in URL** — passed as query parameter `api_key=YOURKEY`.
- **International route country codes** — use 3-letter ISO codes (`AUS`, `CHN`, `GBR`), not 2-letter (`AU`).
  Must also facet on `countryRegionTypeId=c` for countries. Without it, queries silently return 0 rows.
- **International route uses numeric IDs** — `productId` and `activityId` are integers, not string codes. See `references/international-ids.md`. Discover values by querying without product/activity filters and inspecting the output.
- **International route has no sub-routes** — unlike `natural-gas/pri/sum` or `electricity/retail-sales`,
  the `international` endpoint is flat. All filtering is done via facets.

## Scripts

### `eia-routes`

Query API route metadata. Outputs raw JSON with sub-routes, descriptions, and facet definitions.

Usage:

```
scripts/eia-routes [route] [options]
```

| Option  | Description                                                   |
| ------- | ------------------------------------------------------------- |
| `route` | Route path to explore (default: root, shows top-level routes) |

Examples:

```
# Show top-level routes
scripts/eia-routes

# Drill into electricity sub-routes
scripts/eia-routes electricity

# Drill deeper and see facets in the JSON
scripts/eia-routes natural-gas/pri/sum
```

### `eia-data`

Fetch time-series data from an EIA API route. Outputs raw JSON.

Usage:

```
scripts/eia-data <route> [options]
```

| Option          | Description                                                                                                                                       |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--freq FREQ`   | Frequency: `annual`, `monthly`, `weekly`, `daily`                                                                                                 |
| `--data FIELDS` | Data columns to return. Repeat for multiple: `--data sales --data price`. Defaults to `value`. Check `scripts/eia-routes ROUTE` for valid fields. |
| `--facets K=V`  | Facet filter, e.g. `--facets duoarea=SAK --facets process=PRS`                                                                                    |
| `--start DATE`  | Start date (inclusive), format depends on frequency                                                                                               |
| `--end DATE`    | End date (inclusive)                                                                                                                              |
| `--length N`    | Max rows (max: 5000)                                                                                                                              |
| `--offset N`    | Pagination offset                                                                                                                                 |
| `--sort COL`    | Sort by column (default: period)                                                                                                                  |
| `--order DIR`   | Sort direction: `asc` or `desc` (default: desc)                                                                                                   |

Examples:

```
# Natural gas prices for residential consumers in Alaska
scripts/eia-data natural-gas/pri/sum --freq monthly \
  --facets duoarea=SAK --facets process=PRS

# Electricity retail prices by state and sector
scripts/eia-data electricity/retail-sales --freq annual \
  --data price --facets stateid=CO --facets sectorid=RES

# Weekly retail gasoline prices
scripts/eia-data petroleum/pri/gnd --freq weekly \
  --facets product=EPMR --facets process=PTE \
  --start 2025-01-01

# Natural gas storage
scripts/eia-data natural-gas/stor --freq weekly \
  --facets duoarea=NUS --facets process=SNG

# Data for a specific date range
scripts/eia-data electricity/retail-sales --freq monthly \
  --data sales --facets stateid=TX --facets sectorid=IND \
  --start 2023-01 --end 2024-12

# Australian coal production (productId=7, activityId=1)
scripts/eia-data international --freq annual \
  --facets productId=7 --facets activityId=1 \
  --facets countryRegionId=AUS --facets countryRegionTypeId=c \
  --length 5

# Australian coal exports (productId=7, activityId=4)
scripts/eia-data international --freq annual \
  --facets productId=7 --facets activityId=4 \
  --facets countryRegionId=AUS --facets countryRegionTypeId=c \
  --length 5

# Chinese coal consumption (productId=7, activityId=2)
scripts/eia-data international --freq annual \
  --facets productId=7 --facets activityId=2 \
  --facets countryRegionId=CHN --facets countryRegionTypeId=c \
  --length 5

# Discover product/activity IDs by querying without filters
scripts/eia-data international --freq annual \
  --facets countryRegionId=AUS --facets countryRegionTypeId=c \
  --length 100
```

## Workflows

### Explore and query electricity data

```bash
scripts/eia-routes electricity
scripts/eia-routes electricity/retail-sales
scripts/eia-data electricity/retail-sales --freq annual \
  --data price --facets stateid=CO --facets sectorid=RES
```

### Get weekly gasoline prices

```bash
scripts/eia-data petroleum/pri/gnd --freq weekly --data value \
  --facets product=EPMR --facets process=PTE --length 52
```

### Natural gas storage for entire US

```bash
scripts/eia-routes natural-gas/stor
scripts/eia-data natural-gas/stor --freq weekly \
  --facets duoarea=NUS --facets process=SNG --length 10
```

### Query international country-level data

The `international` route has no sub-routes. Use facets to filter by country,
product, and activity:

```bash
# Discover available product IDs for a country
scripts/eia-data international --freq annual \
  --facets countryRegionId=AUS --facets countryRegionTypeId=c --length 500

# Australian coal production
scripts/eia-data international --freq annual \
  --facets productId=7 --facets activityId=1 \
  --facets countryRegionId=AUS --facets countryRegionTypeId=c --length 5

# Chinese coal consumption
scripts/eia-data international --freq annual \
  --facets productId=7 --facets activityId=2 \
  --facets countryRegionId=CHN --facets countryRegionTypeId=c --length 5
```

### Query petroleum inventories (global, OECD, US)

The `steo` route contains OECD and global petroleum storage data not available
in the `petroleum/stoc/wstk` route (which is US-only). Key series IDs include
inventories, draws/builds, supply, and demand by region. See
`references/steo-series-ids.md` for the full table.

Examples:

```bash
# OECD commercial crude & liquids inventories (monthly, historical)
scripts/eia-data steo --freq monthly \
  --facets seriesId=PASC_OECD_T3 --data value \
  --start 2023-01 --end 2026-12

# Global inventory change (negative = stock draws)
scripts/eia-data steo --freq monthly \
  --facets seriesId=T3_STCHANGE_WORLD --data value \
  --start 2023-01 --end 2026-12

# US crude oil inventory excluding SPR
scripts/eia-data steo --freq monthly \
  --facets seriesId=COSXPUS --data value \
  --start 2023-01 --end 2026-12
```

### Refinery crude runs (weekly)

Refinery inputs = how much crude refineries are processing, directly impacts crude draws.

```bash
scripts/eia-data petroleum/pnp/wprodrb --freq weekly \
  --facets duoarea=NUS --data value --length 52
```

### Electric generation by fuel source (monthly)

Track coal vs gas vs renewables in power generation. Key `fueltypeid` values:
`COL` (coal), `NG` (natural gas), `NUC` (nuclear), `WND` (wind), `SUN` (solar),
`HYD` (hydro).

```bash
# Coal vs gas generation
scripts/eia-data electricity/electric-power-operational-data --freq monthly \
  --facets location=US --facets sectorid=ALL \
  --facets fueltypeid=COL --facets fueltypeid=NG \
  --data generation --length 24
```

### Total energy overview (monthly)

Monthly Energy Review cross-source summaries via MSN codes.

```bash
# Discover MSN codes
scripts/eia-data total-energy --freq monthly --length 200

# Query a specific series
scripts/eia-data total-energy --freq monthly \
  --facets msn=TETXXUS1 --data value --length 24
```

### Petroleum product supplied (consumption)

Demand-side: what petroleum products are being consumed.

```bash
scripts/eia-data petroleum/cons/psup --freq monthly \
  --facets duoarea=NUS --data value --length 24
```

### Paginate large result

```bash
scripts/eia-data natural-gas/stor --freq weekly --length 5000 --offset 0
scripts/eia-data natural-gas/stor --freq weekly --length 5000 --offset 5000
```

## Reference

### Top-level routes

| Route ID            | Description                                                                                                                                                            |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `coal`              | Coal reserves, production, prices, employment                                                                                                                          |
| `crude-oil-imports` | Crude oil imports by country                                                                                                                                           |
| `electricity`       | Electricity sales, generation, operations                                                                                                                              |
| `natural-gas`       | Natural gas prices, storage, production                                                                                                                                |
| `petroleum`         | Petroleum prices, reserves, refining, consumption                                                                                                                      |
| `seds`              | State Energy Data System — all energy by state                                                                                                                         |
| `steo`              | Short Term Energy Outlook — monthly historical + 18-month projections. **Includes OECD and global petroleum inventories** (see Petroleum Storage STEO workflow below). |
| `total-energy`      | Monthly Energy Review (MER) — comprehensive                                                                                                                            |
| `densified-biomass` | Wood pellet / biomass fuel data                                                                                                                                        |
| `nuclear-outages`   | Daily nuclear plant generator outages                                                                                                                                  |
| `aeo`               | Annual Energy Outlook projections                                                                                                                                      |
| `ieo`               | International Energy Outlook projections                                                                                                                               |
| `co2-emissions`     | State CO₂ data (deprecated, use SEDS)                                                                                                                                  |
| `international`     | Country-level energy data. Uses numeric productId/activityId (see `references/international-ids.md`).                                                                  |

### Data endpoint URL structure

```
https://api.eia.gov/v2/{route}/data?api_key={key}&frequency={freq}
  &data[]={field1}&data[]={field2}
  &facets[{facetId}][]={value}
  &start={date}&end={date}
  &length={n}&offset={n}
  &sort[0][column]={col}&sort[0][direction]={dir}
```

### International route IDs

`productId` and `activityId` are numeric. See `references/international-ids.md` for the full mapping.

### Facet discovery

The `eia-routes` script returns the full API metadata as JSON, including
available routes and facet definitions at each level:

```
scripts/eia-routes natural-gas/pri/sum
```
