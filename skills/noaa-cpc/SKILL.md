---
name: noaa-cpc
description: Fetch climate and ENSO data from NOAA Climate Prediction Center — Niño SST anomaly indices (weekly/monthly), Oceanic Niño Index (ONI), Southern Oscillation Index (SOI), and ENSO diagnostic advisory text. Use this skill when the user asks about El Niño, La Niña, ENSO status, Pacific sea surface temperatures, Southern Oscillation, or climate patterns affecting weather, agriculture, or commodity markets, even if they don't name ENSO, NOAA, or CPC explicitly.
---

# NOAA CPC Indices

Fetch climate indices from the NOAA Climate Prediction Center — Niño SST anomalies, the Oceanic Niño Index (ONI), Southern Oscillation Index (SOI), and ENSO diagnostic advisories.

Source: https://www.cpc.ncep.noaa.gov/data/indices/

## Scripts

### `enso-indices`

Fetch weekly (OISSTv2.1) or monthly (ERSSTv5) Niño SST anomaly indices for all four Niño regions.

```
Usage:
  enso-indices [--index <name>] [--period weekly|monthly] [--json] [--months <n>]
```

| Option       | Description                                                                    |
| ------------ | ------------------------------------------------------------------------------ |
| `--index`    | Single index: nino12, nino3, nino34, nino4 (default: all)                     |
| `--period`   | weekly (OISSTv2.1) or monthly (ERSSTv5) [default: weekly]                      |
| `--json`     | Output as JSON                                                                  |
| `--months`   | Number of recent weeks/months (default: 1 weekly, 3 monthly)                    |

**Examples:**

```bash
enso-indices --index nino34
enso-indices --period monthly --months 6
enso-indices --json
```

### `enso-oni`

Fetch the Oceanic Niño Index — 3-month running mean of Niño 3.4 SST anomalies. Thresholds: El Niño ≥ +0.5°C for 5 consecutive overlapping seasons, La Niña ≤ -0.5°C.

```
Usage:
  enso-oni [--months <n>] [--json] [--threshold <t>]
```

| Option        | Description                                                |
| ------------- | ---------------------------------------------------------- |
| `--months`    | Number of recent seasons (default: 6)                       |
| `--json`      | Output as JSON                                              |
| `--threshold` | Only show seasons with \|anomaly\| >= this (e.g. 0.5)       |

**Examples:**

```bash
enso-oni --months 4
enso-oni --threshold 0.5 --months 12
```

### `enso-soi`

Fetch the Southern Oscillation Index (SOI) — standardized Tahiti minus Darwin sea level pressure. Confirms atmospheric coupling. Negative SOI → El Niño, positive SOI → La Niña.

```
Usage:
  enso-soi [--months <n>] [--json] [--standardized]
```

| Option          | Description                                    |
| --------------- | ---------------------------------------------- |
| `--months`      | Number of recent months (default: 6)            |
| `--json`        | Output as JSON                                  |
| `--standardized`| Use standardized values (default: anomalies)    |

**Examples:**

```bash
enso-soi --months 12
enso-soi --json
```

### `enso-advisory`

Fetch the latest ENSO Diagnostic Discussion and extract key fields (status, synopsis, Niño 3.4 value, probability).

```
Usage:
  enso-advisory [--text] [--json]
```

**Examples:**

```bash
enso-advisory
enso-advisory --text
```

## Workflows

### Check current ENSO status

```bash
enso-advisory
enso-indices --index nino34
enso-soi --months 3
```

### Track ENSO evolution

```bash
enso-indices --period monthly --index nino34 --months 12
enso-oni --months 8
enso-soi --months 12
```

## Gotchas

- **Weekly vs monthly base periods** — Weekly indices use OISSTv2.1 (1991–2020 base period). Monthly ERSSTv5 and ONI also use 1991–2020. ONI uses centered 30-year base periods updated every 5 years.
- **Anomaly, not absolute SST** — The anomaly (SSTA) is the departure from the 30-year average. An absolute SST of 28°C in Niño 3.4 is normal; the anomaly is what matters.
- **Niño 3.4 is the benchmark** — CPC uses Niño 3.4 (170°W–120°W, 5°N–5°S) for official ENSO classification. Niño 1+2 is the easternmost region and can spike independently.
- **ONI lags weekly data** — ONI is a 3-month running mean and smooths weekly noise. Weekly indices show the current state; ONI shows the sustained signal.
- **SOI confirms coupling** — Negative SOI (Tahiti lower pressure, Darwin higher) confirms El Niño atmospheric coupling. SST anomalies without SOI confirmation may indicate a weak or uncoupled event.
- **Weekly data has leading spaces** — The fixed-width SST file has leading spaces on data lines. Parsing must account for this.
- **SOI has two data blocks** — The SOI file contains anomaly values followed by standardized values below a `STANDARDIZED DATA` header. The script defaults to anomalies.
- **SSTA concatenation** — In the weekly data, when SSTA is negative the SST and SSTA are concatenated (e.g., `20.6-0.1`). When positive they are space-separated (`25.3 0.1`).

Base directory: file:///Users/shane/.config/opencode/skills/noaa-cpc
