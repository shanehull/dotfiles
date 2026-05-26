---
name: silo-weather
description: Fetch interpolated Australian weather data — daily rainfall, max/min temperature, evaporation, radiation, and vapour pressure for any lat/lon. Use this skill when tracking rainfall or temperature for Australian agriculture, crop monitoring, drought and fire risk assessment, or any Australian weather analysis, even if the user doesn't mention "SILO" by name.
allowed-tools: bash
---

# SILO Weather

Fetch interpolated daily weather data for any location in Australia, with records back to 1889.

## Gotchas

- **First data row is a dummy** — raw output includes a `19970526` sentinel row. Skip it in parsing. Use `/^[0-9]/` to match data rows and verify the year.
- **Lat/lon grid is 0.05° resolution** — coordinates are rounded to the nearest 0.05°. Use increments of 0.05 for predictable results.
- **Missing values are -99.9 or -999** — filter with `>= 0` or `!= -99.9`.
- **Dates are YYYYMMDD** — no separators (e.g., `20260401`).
- **Raw output is space-delimited** — not CSV. Each field separated by one or more spaces.
- **CC BY 4.0 licence** — attribute SILO as the data source if publishing externally.
- **Interpolation accuracy varies** — mountainous or coastal locations are less reliable than flat inland terrain.

## Scripts

### `scripts/silo-fetch`

Fetches daily weather data for a point location.

```
Usage:
  silo-fetch --lat <lat> --lon <lon> --start <YYYYMMDD> --finish <YYYYMMDD> [--variable <name>]

Options:
  --lat <float>        Latitude (decimal degrees, negative for South)
  --lon <float>        Longitude (decimal degrees, positive for East)
  --start <YYYYMMDD>   Start date
  --finish <YYYYMMDD>  End date (inclusive)
  --variable <name>    Extract single column: rain, tmax, tmin, evap, radn, vp, rhmaxt, rhmint
                       Omit for full raw output (all columns).
```

**Examples:**

```bash
# Full raw data for a location, April 2026
silo-fetch --lat -29.46 --lon 149.84 --start 20260401 --finish 20260430

# Just rainfall values (one per line)
silo-fetch --lat -35.11 --lon 147.36 --start 20260101 --finish 20260525 --variable rain

# Sum rainfall, filtering out missing values
silo-fetch --lat -29.46 --lon 149.84 --start 20260401 --finish 20260430 --variable rain \
  | awk '$1>=0 {t+=$1; d++} END {printf "%.1fmm over %d days\n",t,d}'
```

## Workflows

### Rainfall check at a specific location

```bash
silo-fetch --lat -29.46 --lon 149.84 --start 20260401 --finish 20260430 --variable rain \
  | awk '$1>=0 {t+=$1; d++} END {printf "Total: %.1fmm Rain days: %d\n",t,d}'
```

### Compare current period against long-term average (LTA)

```bash
# Current period
CURRENT=$(silo-fetch --lat -29.46 --lon 149.84 --start 20260401 --finish 20260430 --variable rain | awk '$1>=0{t+=$1}END{printf "%.1f",t}')

# LTA: fetch same calendar month over 20+ years, divide by year count
LTA=$(silo-fetch --lat -29.46 --lon 149.84 --start 20000401 --finish 20240430 --variable rain \
  | awk '/^[0-9]/ {t+=$1} END{printf "%.1f",t/25}')

echo "April 2026: ${CURRENT}mm vs LTA: ${LTA}mm"
```

### Batch multiple locations for a region

Read `references/locations.md` for pre-verified coordinates across Australian grain belts and capital cities. Batch pattern:

```bash
for loc in "-29.46:149.84:Moree" "-35.11:147.36:Wagga" "-36.71:142.20:Horsham"; do
  IFS=':' read -r lat lon name <<< "$loc"
  rain=$(silo-fetch --lat "$lat" --lon "$lon" --start 20260401 --finish 20260430 --variable rain \
    | awk '$1>=0{t+=$1}END{printf "%.1f",t}')
  echo "${name}: ${rain}mm"
done
```

### Temperature analysis

```bash
# Average max temp for a period
silo-fetch --lat -33.87 --lon 151.21 --start 20260101 --finish 20260131 --variable tmax \
  | awk '$1!=-99.9 {t+=$1; d++} END {printf "Avg max: %.1f°C (%d days)\n",t/d,d}'

# Days above threshold
silo-fetch --lat -29.46 --lon 149.84 --start 20260101 --finish 20260131 --variable tmax \
  | awk '$1!=-99.9 && $1>35 {hot++} END {printf "Days >35°C: %d\n",hot}'
```
