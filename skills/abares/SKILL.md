---
name: abares
description: Fetch Australian agricultural data from ABARES (DAFF) — commodity outlook tables, crop reports, annual commodity statistics, and weekly price data. Use this skill when the user asks about Australian crop production, livestock, grain prices, commodity forecasts, agricultural statistics, or the ABARES Agricultural Commodities report, even if they don't name ABARES or DAFF directly.
allowed-tools: bash
---

# ABARES

Fetch data from the Australian Bureau of Agricultural and Resource Economics
and Sciences (ABARES), the research arm of DAFF. Covers quarterly commodity
forecasts, crop reports, annual historical statistics, and weekly prices.

## Scripts

### `abares`

```
scripts/abares <command> [args...]
```

| Command                        | Description                                         |
| ------------------------------ | --------------------------------------------------- |
| `discover`                     | List all available reports with IDs and file types. |
| `commodities`                  | Download latest outlook and statistical tables.     |
| `crops`                        | Download latest national crop and state data.       |
| `annual-stats [--commodity C]` | Download annual commodity statistics by commodity.  |
| `weekly-prices`                | Current weekly price table as TSV.                  |
| `fetch <asset-id> <index>`     | Download a specific file by ID and file index.      |

**Options:**

| Option               | Applies to     | Description                                       |
| -------------------- | -------------- | ------------------------------------------------- |
| `--commodity <name>` | `annual-stats` | Commodity to fetch (substring, e.g. wheat, beef). |
| `--list`             | `annual-stats` | Print all available commodities and exit.         |

**Examples:**

```bash
scripts/abares discover

scripts/abares commodities
scripts/abares crops

scripts/abares annual-stats --list
scripts/abares annual-stats --commodity wheat
scripts/abares annual-stats --commodity beef

scripts/abares weekly-prices

scripts/abares fetch 1038003 2
```

### `parse-xlsx`

Parse downloaded XLSX files to TSV. Uses Python stdlib only — no pip packages.

```
scripts/parse-xlsx <file.xlsx> [sheet] [--max-rows N] [--max-cols N]
```

| Option         | Description                                         |
| -------------- | --------------------------------------------------- |
| `sheet`        | Sheet index (0-based) or name. Omit to list sheets. |
| `--max-rows N` | Limit output rows (default: all).                   |
| `--max-cols N` | Limit output columns (default: all).                |

**Examples:**

```bash
scripts/parse-xlsx report.xlsx                         # list sheets
scripts/parse-xlsx report.xlsx 0                       # first sheet, all rows
scripts/parse-xlsx report.xlsx 0 --max-rows 20         # first 20 rows
scripts/parse-xlsx report.xlsx 1 --max-cols 6          # second sheet, first 6 cols
scripts/parse-xlsx report.xlsx "Crops" --max-rows 10   # sheet by name
```

## Workflows

### Fetch and inspect latest commodities forecast

```bash
scripts/abares commodities
scripts/parse-xlsx /tmp/abares-*/2
```

### Get current grain and livestock prices

```bash
scripts/abares weekly-prices
```

### Get historical wheat statistics

```bash
scripts/abares annual-stats --commodity wheat
scripts/parse-xlsx /tmp/abares-*/20
```

### Browse available reports, then download one

```bash
scripts/abares discover
scripts/abares fetch 1038221 2
scripts/parse-xlsx /tmp/abares-*/2  0 --max-rows 50
```

## Gotchas

- **IDs are not predictable** — each report gets a new asset ID. Always use `discover` or the convenience commands to find the latest. Never guess IDs.
- **Landing page may lag** — the online catalogue is updated manually and may trail report publication by days. The June 2026 report (ID 1038221) appeared before the landing page was updated from March 2026 (ID 1038003). Use `fetch` with a known ID if you have one.
- **File indexes vary over time** — older reports (pre-2023) sometimes use different indexes for the same file type (e.g. index 1 instead of 2 for outlook tables). The `discover` command reflects actual indexes for each report.
- **Sheet 0 is a table of contents** — `parse-xlsx` sheet lists show "Index" as the first sheet. This sheet contains only the report title and links, not data. Real data starts at sheet 1 ("Key macro", "Major indicators", etc.).
- **XLSX only** — all downloadable data tables are multi-sheet Excel files. Use `parse-xlsx` to convert to TSV.
- **Historical forecast database** is a separate static asset (ID 1031941, covering 2000–2019), not automatically discovered. Fetch with: `scripts/abares fetch 1031941 0`.

## Release schedule

| Report                            | Frequency                      |
| --------------------------------- | ------------------------------ |
| Agricultural Commodities          | Quarterly (Mar, Jun, Sep, Dec) |
| Australian Crop Report            | Quarterly (Mar, Jun, Sep, Dec) |
| Agricultural Commodity Statistics | Annual (Apr–May)               |
| Weekly prices                     | Every Thursday                 |

## Annual commodity statistics index

```
scripts/abares annual-stats --list
```

| Index | Commodity                   |
| ----- | --------------------------- |
| 0     | Australian economy overview |
| 1     | Macroeconomic indicators    |
| 2     | Farm sector                 |
| 3     | Coarse grains               |
| 4     | Cotton                      |
| 5     | Dairy                       |
| 6     | Farm inputs                 |
| 7     | Fisheries                   |
| 8     | Food                        |
| 9     | Forestry                    |
| 10    | Horticulture                |
| 11    | Meat — general              |
| 12    | Beef and veal               |
| 13    | Pigs and poultry            |
| 14    | Sheep                       |
| 15    | Oilseeds                    |
| 16    | Pulses                      |
| 17    | Rice                        |
| 18    | Sugar                       |
| 19    | Wool                        |
| 20    | Wheat                       |
| 21    | Wine                        |
