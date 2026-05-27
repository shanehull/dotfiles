---
name: owid
description: Fetch data and charts from Our World in Data — search for charts/pages, download CSV datasets, retrieve metadata and chart configurations, and get filtered data by country and time range. Use this skill when the user wants global development data (GDP, CO2, life expectancy, population, etc.) or asks about data-driven topics like climate, health, poverty, energy, or education, even if they don't mention Our World in Data by name.
compatibility: jq required for owid-indicators TSV output
allowed-tools: bash
---

# Our World in Data (OWID)

Access data from Our World in Data's public APIs. Three scripts, three APIs:

| Script                    | API                          | Purpose                                    |
| ------------------------- | ---------------------------- | ------------------------------------------ |
| `scripts/owid-search`     | Search API                   | Find charts and pages by keyword           |
| `scripts/owid-data`       | Grapher Chart API            | Download chart data as CSV, metadata, etc. |
| `scripts/owid-indicators` | Indicators + Semantic Search | Find and fetch raw indicator data by ID    |

All data is CC BY 4.0 licensed.

## Choosing the right approach

- **Don't know the slug or indicator ID?** Start with `owid-search "query"` (charts) or `owid-indicators --search "query"` (indicators).
- **Want a specific chart's data as CSV?** Use `owid-data <slug>`.
- **Want raw variable data with entity/time filtering?** Use `owid-indicators <id>`. This is the most powerful approach — semantic search finds the indicator, then you get TSV (requires jq) or JSON with entity names, years, and values.

## owid-indicators

Semantic search for indicators and direct data fetching. This is the most flexible data access method.

### Search

```
owid-indicators --search "<query>" [--limit N] [--min-popularity 0.5]
```

Returns raw JSON with query, total_results, and results array (indicator_id, title, snippet, score, n_charts, catalog_path). Use `--min-popularity` to filter out low-relevance indicators (0-1 scale).

### Fetch data

```
owid-indicators <id>                           # full TSV: entity, year, value (requires jq)
owid-indicators <id> --entity NAME             # filter by entity (case-insensitive substring)
owid-indicators <id> --time 2000..2020          # filter by year range
owid-indicators <id> --time latest              # latest value per entity
owid-indicators <id> --entity France --time 2000..2020  # combined filters
owid-indicators <id> -f metadata                # indicator metadata (name, unit, timespan, dimensions)
owid-indicators <id> -f json                    # raw data.json
```

### APIs used

| Endpoint                                                          | Used for        |
| ----------------------------------------------------------------- | --------------- |
| `https://search.owid.io/indicators?q=...`                         | Semantic search |
| `https://api.ourworldindata.org/v1/indicators/{id}.data.json`     | Data values     |
| `https://api.ourworldindata.org/v1/indicators/{id}.metadata.json` | Metadata        |

### Semantic search result fields

| Field          | Description                               |
| -------------- | ----------------------------------------- |
| `indicator_id` | Numeric ID — use with data/metadata fetch |
| `title`        | Indicator name                            |
| `snippet`      | Description snippet                       |
| `score`        | Semantic relevance 0-1                    |
| `n_charts`     | Number of charts using this indicator     |
| `catalog_path` | Internal dataset path                     |

## owid-search

```
owid-search <query> [options]
```

| Option                   | Description                              |
| ------------------------ | ---------------------------------------- |
| `--type charts \| pages` | Content type (default: charts)           |
| `--page N`               | Page number, 0-indexed (default: 0)      |
| `--hits N`               | Results per page, 1-100 (default: 20)    |
| `--countries u~CN`       | Countries separated by `~` (charts only) |
| `--topics TOPIC`         | Topic filter (charts only)               |
| `--require-all`          | Only charts containing ALL countries     |

Output is raw JSON with query, nbHits, results array (title, slug, url, type, variantName).

Available topics: [tags database](https://datasette-public.owid.io/owid/tags?slug__notnull=1&_sort=createdAt).

Each chart result includes: `title`, `slug`, `subtitle`, `variantName`, `availableEntities`, `availableTabs`, `url`.

## owid-data

```
owid-data <slug>[.format] [options]
```

| Option                        | Description                                                                                                                   |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `-f, --format FMT`            | csv, metadata, config, readme, zip, values, png, svg (default: csv)                                                           |
| `-o, --out PATH`              | Save output to file (required for png/svg)                                                                                    |
| `--csv-type full \| filtered` | full = all data, filtered = chart subset (default: full)                                                                      |
| `--country ENTITY`            | Filter by entity. `~OWID_WRL` for World. (repeatable)                                                                         |
| `--time RANGE`                | year, `2000..2020`, `latest`, `earliest`                                                                                      |
| `--tab TAB`                   | Active tab: table, map, chart, line, scatter, stacked-area, discrete-bar, stacked-discrete-bar, slope, stacked-bar, marimekko |
| `--short-names`               | Compact column names (no spaces)                                                                                              |

### Image options (`--format png|svg`)

| Option               | Description                                         |
| -------------------- | --------------------------------------------------- |
| `--im-type TYPE`     | Preset: twitter, og, thumbnail, square, uncaptioned |
| `--im-width N`       | Width in pixels                                     |
| `--im-height N`      | Height in pixels                                    |
| `--im-minimal`       | Minimal mode (no title/source line)                 |
| `--im-font-size N`   | Font size                                           |
| `--im-square-size N` | Size for square images                              |

### Format details

| Format   | Returns                                                 |
| -------- | ------------------------------------------------------- |
| csv      | Time series data (Entity, Code, Year/Day, data columns) |
| metadata | Chart title, subtitle, citation, column metadata        |
| config   | Raw grapher configuration (dimensions, axes, colors)    |
| readme   | Markdown README describing the dataset                  |
| zip      | ZIP containing csv + metadata.json + readme.md          |
| values   | JSON data values filtered by entity/time                |
| png      | Chart as PNG image (requires `-o` path)                 |
| svg      | Chart as SVG image (requires `-o` path)                 |

### Metadata fields (columns in `.metadata.json`)

Each column object includes: `titleShort`, `titleLong`, `descriptionShort`, `descriptionKey`, `shortUnit`, `unit`, `timespan`, `type`, `owidVariableId`, `shortName`, `citationShort`, `citationLong`. The `owidVariableId` can be used directly with `owid-indicators`.

## Workflows

### Find and fetch indicator data (recommended)

```
1. owid-indicators --search "wine consumption"     → find indicator IDs
2. owid-indicators 1203983 --entity France --time 2000..2020  → filtered TSV
```

### Find and download chart data

```
1. owid-search "co2 emissions per capita"          → find chart slugs
2. owid-data co2-emissions -f metadata              → inspect metadata (units, owidVariableId)
3. owid-data co2-emissions --country USA --time 2000..2020  → filtered CSV
```

### Explore by topic

```
owid-search "emissions" --topics "Energy" --hits 5
```

### Export chart image for notes

```
owid-data life-expectancy -f png --country France --time 2000..2020 -o ~/secondbrain/assets/life-expectancy-france.png
owid-data co2-emissions -f svg --tab map --time latest -o ~/secondbrain/assets/co2-map.svg
```

## Gotchas

- **Chart slugs are exact** — always search first to confirm the slug before fetching data.
- **Indicator IDs are numeric** — use `owid-indicators --search` to find them, then pass the ID.
- **Country names use full names** — `United States` not `USA`. Use `~` (tilde) to separate multiple countries in the chart/search APIs.
- **Entities in indicators** use a different ID system. Always use `--entity` with the indicator script; it resolves names to IDs automatically via metadata.
- **Time ranges** use `..` — `2000..2020`, `latest`, `earliest`, or a single year `2020`.
- **CSV column names** default to long human-readable names. Use `--short-names` for machine-readable headers.
- **`filtered` csvType** returns only visible chart data (selected entities and time range). `full` returns everything.
- **403 on certain datasets** — some charts have non-redistributable data. The API returns 403. Use search to find alternative charts.
- **`--tab` only affects values, png, and svg** — the CSV endpoint ignores the tab parameter.
- **Image export requires `-o PATH`** — png/svg are binary; always specify an output file.
- **Popularity filter is aggressive** — `--min-popularity 0.9` may return zero results. Start with 0.5 and adjust.
- **Indicators API returns parallel arrays** — `values`, `years`, `entities` are zipped by index. The script handles this automatically.
