---
name: worldbank
description: Fetch country-level development data from the World Bank — GDP, GDP growth, inflation, population, unemployment, government debt, savings, investment, poverty, health, education, energy, and thousands of other development indicators across 200+ economies, some with decades of history. Use this skill when the user asks about a country's economic or social statistics, wants a cross-country comparison, or needs a long historical series, even if they don't name the World Bank or an indicator code. No API key required.
compatibility: Requires bash, curl, jq, and internet access.
allowed-tools: bash
---

# World Bank Indicators

Country-level development indicators and economy metadata from the World Bank.
No API key. Use `scripts/wb`; it emits JSON to stdout — pipe to `jq`.

## Commands

```
scripts/wb data --indicator CODE[,CODE] [--countries LIST] [--date 2000:2025]
                [--mrv N | --mrnev N] [--per-page N] [--page N] [--raw]
scripts/wb indicator <CODE>                 # metadata for one indicator
scripts/wb indicators [--search TERM]       # browse/search the catalog (cached)
scripts/wb country <CODE>                   # metadata for one economy
scripts/wb countries [--search TERM] [--region CODE] [--income CODE]
scripts/wb sources                          # data sources
scripts/wb topics | regions | incomelevels | lendingtypes
scripts/wb download --indicator CODE [--countries LIST] [--format csv|xls]   # prints a zip URL
```

`data` prints the data rows; `indicator`/`country` print one object; the rest print arrays.
`--raw` returns the full response for `data`.
`--countries` takes ISO3 (`SWE`), ISO2 (`SE`), or aggregates (`all`, `WLD`, `EAP`, `ECS`,
`LCN`, `MEA`, `SAS`, `SSF`, `HIC`, `UMC`, `LIC`, `EUU`). Default `all`, which includes
aggregates alongside countries.

## Common indicator codes

| Metric                                    | Code                                |
| ----------------------------------------- | ----------------------------------- |
| GDP (current US$)                         | `NY.GDP.MKTP.CD`                    |
| GDP growth (annual %)                     | `NY.GDP.MKTP.KD.ZG`                 |
| GDP per capita (current US$)              | `NY.GDP.PCAP.CD`                    |
| Inflation, consumer prices (annual %)     | `FP.CPI.TOTL.ZG`                    |
| Population, total                         | `SP.POP.TOTL`                       |
| Population growth (annual %)              | `SP.POP.GROW`                       |
| Unemployment (% labour force, ILO)        | `SL.UEM.TOTL.ZS`                    |
| Gross savings (% of GDP)                  | `NY.GNS.ICTR.ZS`                    |
| Gross capital formation (% of GDP)        | `NE.GDI.TOTL.ZS`                    |
| Central government debt (% of GDP)        | `GC.DOD.TOTL.GD.ZS`                 |
| Current account balance (% of GDP)        | `BN.CAB.XOKA.GD.ZS`                 |
| Exports / imports (% of GDP)              | `NE.EXP.GNFS.ZS` / `NE.IMP.GNFS.ZS` |
| FDI, net inflows (% of GDP)               | `BX.KLT.DINV.WD.GD.ZS`              |
| Life expectancy at birth (years)          | `SP.DYN.LE00.IN`                    |
| Poverty headcount at $2.15/day (2017 PPP) | `SI.POV.DDAY`                       |
| Gini index                                | `SI.POV.GINI`                       |
| CO2 emissions (metric tons per capita)    | `EN.GHG.CO2.PC.CE.AR5`              |
| Access to electricity (% of population)   | `EG.ELC.ACCS.ZS`                    |

Find codes this table lacks with `scripts/wb indicators --search "your topic"`.

## Gotchas

- **Use commas in `--countries`, not semicolons.** A bare `;` is eaten by the shell and
  splits the command. Commas pass through cleanly.
- **Two or more indicators must come from one source.** The script selects the main
  World Development Indicators source automatically when you ask for a list.
- **A missing value is `null`, not zero.** An economy/year with no observation returns
  `"value": null`. Guard sums and averages against nulls.
- **`all` mixes aggregates with countries.** Results include regions, income groups and
  world totals (ISO3 like `WLD`, `EAP`, `HIC`) alongside real economies. Pass an explicit
  code list for a clean comparison.
- **Search covers the cached catalog.** `--search` matches indicator id and name locally;
  the first call downloads and caches a large catalog (30 days by default, `WB_CACHE_DAYS`
  to change it).
- **Large results span pages.** When more pages exist the script notes it on stderr; pass
  `--page` to fetch the next one.
- **`--mrv` vs `--mrnev`.** `--mrv N` returns the N most recent years whether or not they
  have a value; `--mrnev N` returns the N most recent years that do. Use `--mrnev` to skip
  gaps and stale tails.
- **Government debt is narrow.** `GC.DOD.TOTL.GD.ZS` is _central_ government debt only.
  It sits near zero or has gaps for several high-income economies, and general-government
  gross debt (a larger figure) is a different measure not covered here.
- **Codes are case-insensitive** (`sp.pop.totl` works) and comma-separated.
- **Latest years are estimates.** Figures lag about a year and the most recent point is
  often provisional or a forecast.
- **`download` prints a zip URL and fetches nothing.** For large pulls, fetch that URL and
  unzip it, or use `data` for smaller queries.
