---
name: cftc-cot
description: Fetch CFTC Commitments of Traders (COT) positioning data, covering how different trader classes are positioned in futures markets. Includes producer/merchant hedgers, swap dealers, managed money (speculative funds), commercial and non-commercial traders, leveraged funds, and index/commodity index traders across US commodities, currencies, rates, equities, and energy. Use this skill when the user asks about speculative positioning, managed money, fund net length, commercial hedger positioning, open interest, or trader classifications in any futures or options market, even if they don't mention COT or CFTC by name.
allowed-tools: bash
---

# CFTC Commitments of Traders (COT)

Reports Tuesday data released Friday 3:30 pm Eastern. Weekly files cover the current week; annual compressed files cover calendar years.

Source: https://www.cftc.gov/MarketReports/CommitmentsofTraders/index.htm

## Scripts

### `cot`

Fetch COT positioning data and print it as readable text.

```
cot [--report legacy|disagg|tff|cit] [--combined] [--year YYYY] [--term STR] [--limit N] [--csv]
```

| Option       | Description                                                                          |
| ------------ | ------------------------------------------------------------------------------------ |
| `--report`   | `legacy`, `disagg` (default), `tff`, or `cit`                                        |
| `--combined` | Use futures-and-options combined file (default: futures only)                        |
| `--year`     | Fetch an annual file for a calendar year instead of the current week                 |
| `--term`     | Case-insensitive substring of the market name, e.g. `wti`, `corn`, `eurodollar`      |
| `--limit`    | With no `--term`, print at most N markets (default: 30)                              |
| `--csv`      | One machine-readable row per market/date with a header line, no thousands separators |

**Examples:**

```bash
cot --report disagg --term "WTI-PHYSICAL"
cot --report tff --term "EURO FX"
cot --report legacy --combined --term "CORN"
cot --report cit --term "WHEAT"
cot --report disagg --year 2026 --term "HENRY HUB"
cot --report tff --term "10 YEAR"
cot --report disagg --year 2026 --term "WHEAT-SRW" --csv
```

### Machine-readable history (managed money long/short per week)

The `--csv` mode emits one row per market/date with a header and raw numbers. Column order is fixed per report type; the first six are always `date,market,open_interest,<cat>_long,<cat>_short,<cat>_spread`.

disagg columns: `date,market,open_interest,producer_merc_long,producer_merc_short,swap_long,swap_short,swap_spread,managed_money_long,managed_money_short,managed_money_spread,other_reportable_long,other_reportable_short,other_reportable_spread,total_reportable_long,total_reportable_short,nonreportable_long,nonreportable_short,change_open_interest,...`

legacy columns: `date,market,open_interest,non_commercial_long,non_commercial_short,non_commercial_spread,commercial_long,commercial_short,total_reportable_long,total_reportable_short,nonreportable_long,nonreportable_short,change_open_interest,...`

tff columns: `date,market,open_interest,dealer_long,dealer_short,dealer_spread,asset_mgr_long,asset_mgr_short,asset_mgr_spread,leveraged_funds_long,leveraged_funds_short,leveraged_funds_spread,other_reportable_long,other_reportable_short,other_reportable_spread,total_reportable_long,total_reportable_short,nonreportable_long,nonreportable_short,change_open_interest,...`

cit columns: `date,market,open_interest,non_commercial_long,non_commercial_short,commercial_long,commercial_short,index_trader_long,index_trader_short,total_reportable_long,total_reportable_short,nonreportable_long,nonreportable_short,change_open_interest,...`

Extract managed money long/short by report week (disagg, columns 9 and 10):

```bash
cot --report disagg --year 2026 --term "WHEAT-SRW" --csv | awk -F, 'NR>1 {print $1, $9, $10}'
```

Read the header line (`head -1`) to confirm positions before slicing; the change columns carry a `-` for negatives and no sign for non-negatives.

## Report types

| Report | Trader classifications                                                               | Focus                 |
| ------ | ------------------------------------------------------------------------------------ | --------------------- |
| disagg | Producer/Merchant, Swap Dealers, Managed Money, Other Reportables                    | Physical commodities  |
| legacy | Non-Commercial (speculative), Commercial (hedging)                                   | Simplest summary      |
| tff    | Dealer/Intermediary, Asset Manager/Institutional, Leveraged Funds, Other Reportables | Financials            |
| cit    | Non-Commercial, Commercial, Index Traders (CIT)                                      | Commodity index funds |

- **CIT** covers 13 select agricultural contracts only.
- **tff** covers currencies, US Treasuries, Eurodollars, equities, VIX.
- **disagg** covers agriculture, energy, metals. Use it for commodity speculation.
- When a commodity has seasonal crop years, the `All` positions (shown here) total across old and new crop. The `_Old`/`_Other` crop-year splits live in the raw CSV only.

## Workflows

### Speculative sentiment on a commodity (managed money)

```bash
cot --report disagg --term "CRUDE OIL"
```

Read the Managed Money row: Long vs Short shows fund net positioning; the Change row shows weekly flow. Swaps (dealers) are typically on the opposite side.

### Fund/institutional positioning in currencies or rates

```bash
cot --report tff --term "EURO FX"
cot --report tff --term "10 YEAR"
```

Leveraged Funds approximate speculators; Asset Manager/Institutional approximates long-term allocators.

### Commodity index fund flow (CIT)

```bash
cot --report cit --term "WHEAT"
```

Index Traders row shows passive index-fund length, a structural bid.

### Multiple markets by name

```bash
cot --report disagg --term "CORN"
cot --report disagg --term "SOYBEAN OIL"
cot --report disagg --term "LIVE CATTLE"
```

### Term across many markets (no filter)

```bash
cot --report disagg --term "NATURAL GAS" --year 2026
```

Annual files contain every weekly report of that year, so a term match prints each week's block, giving a full year of positioning history.

## Gotchas

- **Data is as of Tuesday noon Chicago, released Friday.** Tuesday's file appears that Friday. If the user asks for "current" positions on a Wednesday, the latest published number is last Friday's report (prior Tuesday's data).
- **Annual files are per-calendar-year.** Legacy runs 1986+, CIT 2006+, Disagg/TFF 2010+. The 2006–2009 disagg/tff years exist only in a combined 2006-2016 zip not wired into this script; a `--year` in that gap fails with "no annual file".
- **Managed Money differs from Non-Commercial.** The two are different classification systems. disagg split reports into four business purposes; legacy splits into hedging vs speculating. Do not cross-compare them as if equivalent.
- **Trader counts are suppressed for small groups.** The CFTC prints `.` when fewer than four traders would be identified. These appear as `.` in the Traders line; average-position math is meaningless there.
- **Change is week over week.** The Change rows compare to the prior Tuesday, not the last release day. A Friday 3-day gap still holds the Tuesday snapshot. In `--csv`, change columns use `-` for negatives and no sign for non-negatives; position columns are always non-negative.
- **`--csv` numbers have no thousands separators.** Readable text uses them (e.g. `1,888,960`); `--csv` emits raw integers so field slicing with `awk -F,` is exact.
- **Open interest adds up with spreads.** Long + Short + Spread for swap dealers, managed money, and other reportables equals open interest. Total Reportable plus Non-reportable reconciling to OI requires adding spreads.
- **Term filtering is substring, not regex.** `--term "oil"` matches CRUDE OIL, SOYBEAN OIL, and GULF #6 FUEL OIL CRACK. Narrow with spaces or contract names.
- **Market availability changes weekly.** Markets appear only when 20 or more large traders report positions; a market can be dropped or added week to week. A contract absent from this week's report may return later.
- **Contract units vary.** Positions are in contracts, and contract sizes differ by market (e.g. 5,000 bushels of wheat vs 40,000 lbs of lean hogs). Compare contracts within a market, not across markets.
