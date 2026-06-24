---
name: edgar
description: Fetch free long-term U.S. company financial data from the SEC EDGAR REST API — filing histories, company metadata (CIK, SIC, tickers, exchanges), and standardized XBRL financials (revenue, assets, EPS, cash flow) over many years for any U.S. filer. Use this skill when the user asks about a public company's SEC filings, fundamentals, historical financial statements, or wants to compare a metric across companies, even if they don't mention EDGAR, the SEC, or XBRL by name. No API key required.
compatibility: Requires bash, curl, jq, and internet access to data.sec.gov and www.sec.gov.
allowed-tools: bash
---

# SEC EDGAR

Free RESTful access to SEC company filings and standardized XBRL financial facts.
No API key. Use `scripts/edgar`; it outputs raw JSON to stdout — pipe to `jq`.

## Commands

```
scripts/edgar cik <ticker>                              # ticker -> 10-digit CIK
scripts/edgar submissions <ticker|cik>                  # filing history + metadata
scripts/edgar archive <filename>                        # older filing history (overflow)
scripts/edgar concept <ticker|cik> <taxonomy> <tag>     # one metric over time, 1 company
scripts/edgar series <ticker|cik> <tag[,tag...]>        # tidy per-period history, aligned
scripts/edgar facts <ticker|cik>                        # every XBRL fact, 1 company
scripts/edgar frames <taxonomy> <tag> <unit> <period>   # one metric, all companies
```

`<taxonomy>` is `us-gaap` (most financials), `dei` (entity info), `ifrs-full`, or `srt`.
Accepts a ticker or a CIK anywhere a company is expected.

## Picking the right call

- **Single metric history for one company** → `concept` (small, targeted).
- **A tidy multi-year table of one or several metrics** → `series` (filters to full-period values, dedupes restatements, aligns metrics by period end). Use `--period annual|quarterly|instant`, `--since YYYY`, `--limit N`.
- **Whole financial picture for one company** → `facts` (large; always pipe to `jq`).
- **Same metric across all filers for a period** (peer comparison, screening) → `frames`.
- **What/when a company filed, or its identity** → `submissions`.

## Common XBRL tags (us-gaap)

| Concept                 | Tag                                                   | Unit           |
| ----------------------- | ----------------------------------------------------- | -------------- |
| Revenue (post-2018)     | `RevenueFromContractWithCustomerExcludingAssessedTax` | USD            |
| Revenue (older/generic) | `Revenues`                                            | USD            |
| Net income              | `NetIncomeLoss`                                       | USD            |
| Total assets            | `Assets`                                              | USD            |
| Total liabilities       | `Liabilities`                                         | USD            |
| Stockholders' equity    | `StockholdersEquity`                                  | USD            |
| Cash & equivalents      | `CashAndCashEquivalentsAtCarryingValue`               | USD            |
| Operating cash flow     | `NetCashProvidedByUsedInOperatingActivities`          | USD            |
| Diluted EPS             | `EarningsPerShareDiluted`                             | USD-per-shares |
| Shares outstanding      | `dei:EntityCommonStockSharesOutstanding`              | shares         |

To discover the exact tags a company uses: `scripts/edgar facts <co> | jq '.facts."us-gaap" | keys'`.

## Gotchas

- **Set a contact User-Agent.** The SEC requires requests to carry a descriptive `User-Agent` with a contact, and limits access to ~10 requests/second. Export `EDGAR_USER_AGENT="Your Name your@email.com"` before use.
- **XBRL starts in 2009.** Standardized financial facts (`concept`/`facts`/`frames`) only exist from ~2009 onward. Filing _metadata_ via `submissions` goes back to the 1990s.
- **Old filings are in overflow files.** `submissions` returns only the latest ~1000 filings in `.filings.recent`; older history is listed in `.filings.files[].name` and must be fetched with `archive <name>`.
- **No free-cash-flow tag.** EDGAR has no FCF concept. Build it as operating cash flow minus capex: `series <co> NetCashProvidedByUsedInOperatingActivities,PaymentsToAcquirePropertyPlantAndEquipment`, then subtract. Some filers tag capex as `PaymentsToAcquireProductiveAssets` instead. A metric can be missing for some years (tag drift), leaving a `null` in that row — guard subtraction against nulls.
- **Revenue tag changed.** Many companies switched to `RevenueFromContractWithCustomerExcludingAssessedTax` after ASC 606 (~2018) and used `Revenues` or `SalesRevenueNet` before. A single tag may not span a company's full history — check both, or use `facts`.
- **Fiscal ≠ calendar year.** Facts carry `fy`/`fp` (fiscal) plus `start`/`end` dates. Microsoft's FY ends in June; Apple's in late September. `frames` periods (`CY2022Q1`) align to _calendar_ quarters and may mix fiscal periods across companies — read each fact's `end` date.
- **Frames coverage is partial.** A `frames` response includes only entities that reported that exact tag/unit for that period; thousands of filers, but not every company. Missing companies aren't an error.
- **Period codes:** `CY####` annual (~365d duration), `CY####Q#` quarterly (~91d duration), `CY####Q#I` instantaneous (balance-sheet point-in-time, the `I` suffix). Balance items (Assets, Cash) use `...I`; flow items (Revenues, NetIncomeLoss) do not.
- **Units vary.** Most values are `USD`, but EPS is `USD-per-shares`, share counts are `shares`. Foreign filers (20-F/40-F/6-K) may report in local currency under a different unit key — inspect `.units` keys before comparing across companies.
- **Duplicate facts per period.** A concept can list the same period multiple times (restatements / different filings). Each fact has `accn` (accession) and `filed` date; take the latest `filed` for the as-reported-now value.
- **Newly listed or renamed tickers may not resolve.** If `cik`/ticker lookup fails for a recent IPO or rename, pass the CIK directly.
