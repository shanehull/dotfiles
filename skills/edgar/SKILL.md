---
name: edgar
description: Fetch free long-term U.S. company financial data from the SEC EDGAR REST API — filing histories, company metadata (CIK, SIC, tickers, exchanges), and standardized XBRL financials (revenue, assets, EPS, cash flow) over many years for any U.S. filer. Use this skill when the user asks about a public company's SEC filings, fundamentals, historical financial statements, or wants to compare a metric across companies, even if they don't mention EDGAR, the SEC, or XBRL by name. No API key required.
compatibility: Requires bash, curl, jq, and internet access to data.sec.gov and www.sec.gov. `document` text mode also needs perl.
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
scripts/edgar tags <ticker|cik> [--taxonomy T]          # list every tag a company reports
scripts/edgar latest <ticker|cik> <tag>                 # most recent value of one tag
scripts/edgar frames <taxonomy> <tag> <unit> <period>   # one metric, all companies
scripts/edgar document <ticker|cik> [options]           # fetch filing content (text/html)
```

`<taxonomy>` is `us-gaap` (most financials), `dei` (entity info), `ifrs-full`, or `srt`.
Accepts a ticker or a CIK anywhere a company is expected.

## Picking the right call

- **Single metric history for one company** → `concept` (small, targeted).
- **A tidy multi-year table of one or several metrics** → `series` (filters to full-period values, dedupes restatements, aligns metrics by period end). Use `--period annual|quarterly|instant`, `--since YYYY`, `--limit N`.
- **Whole financial picture for one company** → `facts` (large; always pipe to `jq`).
- **The tag names a company actually reports** → `tags` (run this before guessing tags for `concept`/`series`; it fetches the same large file as `facts`).
- **One most-recent value** (latest balance or flow) → `latest`, rather than a nested `jq` path into `facts`.
- **Same metric across all filers for a period** (peer comparison, screening) → `frames`.
- **What/when a company filed, or its identity** → `submissions`.
- **The content of a filing** (proxy/S-4 narrative, risk factors, exhibits) → `document`.

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

To discover the exact tags a company uses, run `scripts/edgar tags <co>` (or `scripts/edgar facts <co> | jq '.facts."us-gaap" | keys'`).

## Filing content

`document` retrieves the substance of a filing, which XBRL facts never carry (proxy narrative, S-4 terms, risk factors, exhibits).

```
scripts/edgar document PASG --form S-4                  # newest S-4* primary doc, as text
scripts/edgar document AAPL --form 10-K --html          # raw HTML
scripts/edgar document PASG --accession 0001140361-26-039151
scripts/edgar document PASG --form S-4 --file ny20077915x12_ex23-1.htm
```

Default form is the newest filing of any type; `--form S-4` also matches `S-4/A`. `--accession` takes the dotted accession from `submissions` (or the dash-less form). `--file` selects any document in the filing, e.g. an exhibit named in the filing index. Text mode strips tags and renders each table row on one line with tab-separated cells (`awk -F'\t'`, `cut -f`); `--html` leaves the file intact for a parser. Text mode requires `perl`.

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
- **`series` errors on empty, rather than printing `[]`.** Exit code 3 with a message names the likely cause. The usual one: `--period annual|quarterly` filters to durations, but balance-sheet tags (Assets, Cash) are instantaneous — use `--period instant` for those; annual/quarterly are for flows (revenue, income, cash flow).
- **Filing content lives in the Archives, not the JSON API.** `document` builds `www.sec.gov/Archives/edgar/data/<cik>/<accession-no-dashes>/<doc>`; the accession is dash-less there. Only the ~1000 newest filings resolve through `submissions`; for an older accession pass `--file` with the document name from the filing index.
- **`document` text is a stripped approximation.** It keeps table rows and cells and decodes common entities, but a scanned or image-based exhibit yields little. Use `--html` when exact markup matters.
