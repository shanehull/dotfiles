---
name: netnet-worksheet
description: Perform net-net / deep value analysis on a specific stock using a structured Investment Appraisal worksheet. Use this when evaluating a company's margin of safety, calculating net current asset value (NCAV), or running a structured balance-sheet-driven valuation on a potential investment.
---

Worksheet style adapted from Peter Cundill's investment appraisal form.

## Qualifying Criteria

Meet most before proceeding:

- [ ] Price < book value (ideally < net working capital less long-term debt)
- [ ] Price < half of 52-week high, preferably near all-time low
- [ ] P/FCF < 10 or < inverse of long bond rate (whichever is lower)
- [ ] FCF positive; preferably rising over 5 years
- [ ] Pays dividends or buys back stock; preferably with history of increases
- [ ] Debt is moderate; room to expand borrowing if needed

## Worksheet

Five years of data across seven sections.

### 1. Company Header

| Field         | Entry                                          |
| ------------- | ---------------------------------------------- |
| Analyst       | Who prepared this                              |
| Source        | How the idea surfaced                          |
| Company       | Legal name                                     |
| Ticker        | Identifier                                     |
| Business      | One-line description                           |
| Currency      | Reporting currency                             |
| Current Price | Latest share price                             |
| Market Cap    | Current capitalisation                         |
| Shares Out    | Count; note dual-class / registered structures |
| Major Holders | Who controls, what %                           |
| Year End      | Fiscal year-end                                |
| EPS (5yr)     | Each year                                      |

### 2. Profit & Loss (in reporting currency)

| Line                            | 5yr       |
| ------------------------------- | --------- |
| Revenue                         |           |
| Income before exceptional items |           |
| Net income                      |           |
| EPS (normalised)                |           |
| EPS (reported)                  |           |
| Dividend per share              |           |
| Price range (high / low)        | each year |

### 3. Balance Sheet & NNWC

**Net Net Working Capital** formula:

```
NNWC = Cash & Securities
     + Other Current Assets (discounted)
     - Current Liabilities
     - Long-Term Debt
     - Pension & Other Obligations
     + Equity Investments (at cost)
     + Other Investments (at cost)
```

| Line                              | 5yr               |
| --------------------------------- | ----------------- |
| Cash & securities                 |                   |
| Other current assets              |                   |
| Current liabilities               |                   |
| **= Working Capital**             |                   |
| Less: Long-term debt              |                   |
| Less: Pension / other liabilities |                   |
| Add: Equity investments (cost)    |                   |
| Add: Other investments            |                   |
| **= NNWC**                        |                   |
| **NNWC per share**                | NNWC ÷ shares out |

### 4. Fixed Assets & Equity

| Line                                       | 5yr |
| ------------------------------------------ | --- |
| Net fixed assets                           |     |
| Intangible assets (incl. deferred charges) |     |
| Other assets                               |     |
| Less: Deferred tax                         |     |
| Less: Minority interest                    |     |
| Less: Provisions                           |     |
| **= Shareholders' Equity**                 |     |
| **Book value per share**                   |     |

### 5. Cash Flow

| Line                        | 5yr |
| --------------------------- | --- |
| Net profit                  |     |
| Depreciation & amortisation |     |
| Other non-cash items        |     |
| **= Gross cash flow**       |     |
| CAPEX                       |     |
| **= Free cash flow**        |     |
| **FCF per share**           |     |

### 6. Ratios & Other Data

| Metric               | Formula                      |
| -------------------- | ---------------------------- |
| Debt / Equity        | Total liabilities ÷ equity   |
| FCF Yield            | FCF per share ÷ price        |
| P/FCF                | Price ÷ FCF per share        |
| Return on Equity     | Net income ÷ equity          |
| Return on Price Paid | FCF ÷ (shares × entry price) |
| Dividend Yield       | Dividend ÷ price             |
| Employees            | Headcount                    |
| Shareholders         | Count                        |

### 7. Supplemental

- **Insurance value** — Market vs. carrying cost
- **Pension funded status** — Assets vs. benefit obligations
- **NOL** — Tax loss carryforwards (total and per share)
- **Days inventory / receivables** — Efficiency
- **Voting restrictions** — Limits on transfer or voting
- **Dividend restrictions** — Constraints on payouts

## Margin of Safety

All must hold:

1. **Price < NNWC per share**
2. **Conservative adjustments hold** — re-run NNWC with extra haircuts on receivables and inventory
3. **Positive FCF** — or trending toward it; cash burn erodes margin
4. **Hidden assets** — real estate at cost, brands, investment portfolios, subsidiaries
5. **Plausible catalysts** — buyback, activist, spin-off, sector recovery, management change

## Gotchas

- **Chinese VIE structures**: Listed entity may be a shell — operating company is separate via contractual arrangements. Ownership and liquidation value are not what the balance sheet suggests. Check the VIE agreement terms.
- **Korean circular shareholding**: Chaebol cross-holdings inflate book value. Unwind circular stakes to find real equity.
- **Japanese cross-shareholdings** (JGAAP): Equity stakes in affiliates carried at cost, often at huge discounts to market. Check footnotes for hidden assets.
- **US GAAP LIFO**: LIFO inventory accounting understates book value. Add back LIFO reserve to get true NWC.
- **Australian franking credits**: Tax credits attached to dividends are refundable by the ATO. They survive liquidation as a receivable. Add discounted NPV to NNWC for Australian stocks.
- **Brazilian JCP**: Interest on equity is tax-deductible, treated as an expense. Net income is understated vs. dividend-only peers. Add back JCP to normalise earnings quality.
- **Off-balance sheet liabilities**: Operating leases, pension shortfalls, environmental liabilities. Adjust NNWC.
- **Cash burn erodes NNWC**: A net-net that loses cash will see its margin of safety shrink over time. FCF must turn positive or the thesis breaks.
