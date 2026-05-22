# Pink Sheet Excel Structure

## Sheets

| Sheet | Name            | Rows  | Description                           |
| ----- | --------------- | ----- | ------------------------------------- |
| 1     | (AFOSHEET)      | 0     | Empty — ignore                        |
| 2     | Monthly Prices  | ~800  | Commodity prices in nominal USD       |
| 3     | Monthly Indices | ~1360 | Price indices (2010=100), nominal USD |
| 4     | Description     | ~400  | Series descriptions by category       |
| 5     | Index Weights   | ~92   | Index weight breakdowns               |

## Sheet 2 — Monthly Prices

### Row layout (1-indexed)

| Rows | Content                                                                                                                                     |
| ---- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| 1    | Title: "World Bank Commodity Price Data (The Pink Sheet)"                                                                                   |
| 2    | Description: "monthly prices in nominal US dollars, 1960 to present"                                                                        |
| 3    | Note on data availability                                                                                                                   |
| 4    | Update date: "Updated on Month DD, YYYY"                                                                                                    |
| 5    | Commodity group / sub-group headers. Merged cells — the hierarchy flows like Energy → Crude Oil, Coal, Natural Gas → then Agriculture, etc. |
| 6    | Units (e.g. `($/bbl)`, `($/mt)`, `($/mmbtu)`). A "(quarterly)" marker means that series is updated quarterly.                               |
| 7    | **Series codes** — short machine-friendly IDs (e.g. `CRUDE_PETRO`, `COAL_AUS`, `NGAS_US`). Use these to select a specific series.           |
| 8+   | **Data rows**. Column A = date (`YYYY-MM` format, e.g. `1960M01`), columns B+ = prices. Missing values are `...`.                           |

### Verifying the layout

```bash
unzip -p CMO-Historical-Data-Monthly.xlsx xl/worksheets/sheet2.xml | \
  grep -o '<row r="[0-9]*"' | sort -t\" -k2 -n
```

### Series codes

Column A is always the date. Columns B+ have series codes in row 7 (71 series total).

Common codes:

| Code           | Commodity                        | Code            | Commodity                 |
| -------------- | -------------------------------- | --------------- | ------------------------- |
| `CRUDE_PETRO`  | Crude oil, avg (Brent/Dubai/WTI) | `CRUDE_BRENT`   | Crude oil, Brent          |
| `CRUDE_DUBAI`  | Crude oil, Dubai                 | `CRUDE_WTI`     | Crude oil, WTI            |
| `COAL_AUS`     | Coal, Australian                 | `COAL_SAFRICA`  | Coal, South African       |
| `NGAS_US`      | Natural gas, US (Henry Hub)      | `NGAS_EUR`      | Natural gas, Europe (TTF) |
| `NGAS_JP`      | LNG, Japan                       | `ALUMINUM`      | Aluminum                  |
| `COPPER`       | Copper                           | `IRON_ORE`      | Iron ore                  |
| `GOLD`         | Gold                             | `SILVER`        | Silver                    |
| `WHEAT_US_HRW` | Wheat, US HRW                    | `WHEAT_US_SRW`  | Wheat, US SRW             |
| `MAIZE`        | Maize/corn                       | `RICE_05`       | Rice, Thai 5%             |
| `SOYBEANS`     | Soybeans                         | `SOYBEAN_OIL`   | Soybean oil               |
| `SUGAR_WLD`    | Sugar, world                     | `BEEF`          | Beef                      |
| `TEA_AVG`      | Tea, average                     | `COFFEE_ARABIC` | Coffee, Arabica           |
| `COCOA`        | Cocoa                            | `COTTON_A_INDX` | Cotton A Index            |
| `RUBBER_TSR20` | Rubber, TSR20                    | `LOGS_CMR`      | Logs, Cameroon            |
| `UREA_EE_BULK` | Urea, EE bulk                    | `DAP`           | DAP fertilizer            |
| `POTASH`       | Potash                           | `PHOSROCK`      | Phosphate rock            |

### Date format

Column A format: `YYYY-MM` for monthly (e.g. `2024-01`), `YYYY` for annual.
Data starts at `1960M01` and extends to present.

### Header hierarchy (rows 4–5)

Rows 4–5 have merged cells for commodity groups. Column order varies slightly between releases, but the general layout is:

- **Column A**: date
- **Energy** (crude oil average → Brent → Dubai → WTI, coal Australian → South African, natural gas US → Europe → Japan)
- **Agriculture** → Beverages, Food (Oils & Meals, Grains, Other Food), Raw Materials (Timber, Other Raw Materials)
- **Fertilizers**
- **Metals & Minerals** → Base Metals, Precious Metals

## Sheet 3 — Monthly Indices

Indices are 2010=100. Row layout mirrors the prices sheet with a hierarchical category structure:

```
Total Index (TOTAL)
├── Energy (NRG)
│   ├── Coal (COAL)
│   ├── Crude oil (CRUDE)
│   └── Natural gas (NGAS)
└── Non-Energy (NONNRG)
    ├── Agriculture (AGRI)
    │   ├── Beverages (BEV)
    │   ├── Food (FOOD)
    │   │   ├── Oils & Meals (OILM)
    │   │   ├── Grains (GRAIN)
    │   │   └── Other Food (OTHFOOD)
    │   └── Raw Materials (RAWMAT)
    │       ├── Timber (TIMBER)
    │       └── Other Raw Materials (OTHRAW)
    ├── Fertilizers (FERT)
    └── Metals & Minerals (METMIN)
        ├── Base Metals (BASEM)
        └── Precious Metals (PRECM)
```

## Sheet 4 — Description

Three columns: category, series code, and detailed description of each series including specifications, sources, and methodology change notes.

## Sheet 5 — Index Weights

Weight table for the index calculation, based on developing countries' export values. Has percentage weights per commodity group.

## Extracting data to CSV

Use the `pink` script. It reads the XLSX directly using python3 stdlib.

```bash
# List all series codes
scripts/pink CMO-Historical-Data-Monthly.xlsx --series

# Extract all data as tab-separated
scripts/pink CMO-Historical-Data-Monthly.xlsx --all > pink-data.tsv

# Extract specific commodities
scripts/pink CMO-Historical-Data-Monthly.xlsx \
  --data CRUDE_PETRO --data GOLD --recent 6
```

### Verifying the layout with stock tools

```bash
unzip -p CMO-Historical-Data-Monthly.xlsx xl/sharedStrings.xml > /tmp/ss.xml
unzip -p CMO-Historical-Data-Monthly.xlsx xl/worksheets/sheet2.xml > /tmp/sheet.xml
python3 -c "
import xml.etree.ElementTree as ET
ns = {'s': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
tree = ET.parse('/tmp/sheet.xml')
for row in tree.findall('.//s:row', ns):
    print(f'  Row {row.get(\"r\")}', end='')
    for c in row.findall('s:c', ns):
        print(f' [{c.get(\"r\")}]', end='')
    print()
" 2>/dev/null | head -10
```

### Parsing rules

- **Skip rows 1–6** (title, description, date, group headers, units)
- **Read row 7** as column headers (series codes)
- **Data starts at row 8**
- Column A = date, format `YYYY-MM` or `YYYY`
- Missing values are `...`
- Some columns contain `..` (double dot) for unavailable data
