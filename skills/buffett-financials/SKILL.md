---
name: buffett-financials
description: Interpret financial statements through Warren Buffett's durable competitive advantage lens — income statement, balance sheet, and cash flow analysis with the equity bond valuation framework. Use this skill when evaluating a company's financial health or screening for a long-term investment.
allowed-tools: yfinance_*, Bash, Read, qmd_*
---

# Buffett's Interpretation of Financial Statements

Framework from _Warren Buffett and the Interpretation of Financial Statements_ by Mary Buffett and David Clark (Scribner, 2008).

## Core Concept: Durable Competitive Advantage (DCA)

Warren divides businesses into two groups: those with a durable competitive advantage and those without. The DCA creates monopoly-like economics — the company can charge more or sell more than competitors. Durability (consistency over time) is the key to wealth creation.

### Three business models that produce a DCA

1. **Sells a unique product** — Coca-Cola, Wrigley, Hershey, P&G, Philip Morris
2. **Sells a unique service** — Moody's, H&R Block, American Express (institutional-specific, NOT people-specific)
3. **Low-cost buyer & seller** of a product/service the public consistently needs — Wal-Mart, Costco, Burlington Northern

---

## Income Statement

| ($ in millions)           |           |
| ------------------------- | --------- |
| Revenue                   | $10,000   |
| Cost of Goods Sold        | 3,000     |
| **Gross Profit**          | **7,000** |
| Operating Expenses        |           |
| Selling, General & Admin. | 2,100     |
| Research & Development    | 1,000     |
| Depreciation              | 700       |
| Operating Profit          | 3,200     |
| Interest Expense          | 200       |
| Gain (Loss) Sale Assets   | 1,275     |
| Other                     | 225       |
| Income Before Tax         | 1,500     |
| Income Taxes Paid         | 525       |
| **Net Earnings**          | **$975**  |

### Gross Profit Margin

**Formula:** Gross Profit ÷ Total Revenues = Gross Profit Margin

DCA examples: Coca-Cola 60%+, Moody's 73%, Burlington Northern 61%, Wrigley 51%

Non-DCA examples: United Airlines 14%, GM 21%, U.S. Steel 17%, Goodyear 20%

**Rule:** ≥ 40% → possible DCA; below 40% → competitive industry; ≤ 20% → fiercely competitive. Track 10 years for consistency.

### Selling, General & Administrative

As % of gross profit: Moody's 25%, Coca-Cola 59%, P&G 61%. Companies without DCA show wild variation (GM 28-83%, Ford 89-780%).

**Rule:** Under 30% is fantastic. 30-80% can still be DCA. Near/exceeding 100% → highly competitive.

### Research & Development

Companies that must spend heavily on R&D have an inherent flaw — patents expire, tech gets replaced.

Merck: 29% of gross profit on R&D + 49% on SGA = 78% total. Intel: ~30% on R&D. Moody's: no R&D. Coca-Cola: no R&D.

**Rule:** Heavy R&D = long-term economics at risk. Warren is not interested.

### Depreciation

Warren believes depreciation is a very real expense. DCA companies have lower depreciation as % of gross profit: Coca-Cola ~6%, Wrigley ~7%, P&G ~8%. GM: 22-57%.

**Warren on EBITDA:** "Using EBITDA, our clever Wall Street types are ignoring that eventually the printing press will wear out."

### Interest Expense

DCA companies carry little/no interest expense. P&G: 8% of operating income. Wrigley: 7%. Goodyear: 49%.

Southwest Airlines: 9% (competitive advantage in its industry) vs United 61% vs American 92%.

**Rule:** In any industry, the company with the lowest ratio of interest payments to operating income usually has the competitive advantage.

### Net Earnings

**Rule:** > 20% net earnings on total revenues → good chance of DCA. < 10% → highly competitive.

Coca-Cola: 21%, Moody's: 31%, Southwest: 7%, GM: 3%.

Exception: banks/financial companies — high ratio can mean slacking in risk management.

### Per-Share Earnings

10 years of consistent upward trend = DCA. Erratic earnings with losses = highly competitive industry prone to boom/bust.

---

## Balance Sheet

### Cash & Cash Equivalents

Lots of cash + little/no debt from _ongoing operations_ (not one-time events) → DCA. Check 7 years of balance sheets.

### Inventory

DCA products never become obsolete. Inventory and net earnings rising together → profitable growth. Wild swings → boom/bust.

### Property, Plant & Equipment

DCA companies don't constantly upgrade. Wrigley builds a gum plant and uses it until it wears out. GM constantly retools.

### Long-Term Debt

**Rule:** DCA companies carry little or no long-term debt. Should be able to pay off all long-term debt within 3-4 years of net earnings.

Coca-Cola and Moody's: 1 year. Wrigley and Wash Post: 2 years. GM/Ford: couldn't pay it off with 10 years of earnings.

### Treasury Stock

Presence of treasury shares + history of buybacks = good indicator of DCA.

### Retained Earnings

Rate of growth is a good DCA indicator: Coke 7.9%, Wrigley 10.9%, Burlington Northern 15.6%, Wells Fargo 14.2%, Berkshire 23%.

### Return on Shareholders' Equity

**Formula:** Net Earnings ÷ Shareholders' Equity = ROE

DCA examples: Coca-Cola 30%, Wrigley 24%, Hershey 33%, Pepsi 34%.

Non-DCA: United (profitable year) 15%, American 4%.

**Rule:** High returns on equity → "come play." Low returns → "stay away."

### Debt to Shareholders' Equity Ratio

**Formula:** Total Liabilities ÷ Shareholders' Equity

**Problem for DCA identification:** DCA companies buy back shares, reducing equity, inflating the ratio. Moody's has negative equity.

**Solution — Treasury Share-Adjusted Ratio:** Add treasury stock back to shareholders' equity, then recalculate.

Adjusted ratios: P&G .71, Wrigley .68, Goodyear 4.35, Ford 38.0.

**Rule (non-financial):** Adjusted D/E below .80 → good chance of DCA.

### Current Ratio

DCA companies often have current ratios below 1.0. Moody's .64, Coca-Cola .95, P&G .82.

**Rule:** Of little use in identifying DCA — their earning power lets them cover liabilities easily.

### Leverage

Avoid businesses that use lots of leverage to generate earnings. Leverage can make a mediocre company _appear_ to have a competitive advantage.

---

## Cash Flow Statement

### Capital Expenditures

**Key metric:** Add total capex for 10 years and compare to total net earnings for same period.

DCA examples: Coca-Cola 19%, Moody's 5%, Wrigley 49%, Altria 20%, P&G 28%, Pepsi 36%, Amex 23%.

Non-DCA: GM 444%, Goodyear 950%.

**Rule:** ≤ 50% of net earnings for capex → good place to look for DCA. ≤ 25% → more than likely has DCA.

### Stock Buybacks

History of repurchasing shares → good DCA indicator. Look on cash flow statement under "Issuance (Retirement) of Stock, Net."

---

## Valuation: The Equity Bond

A DCA company's shares = an "equity bond" with an ever-increasing coupon.

- The "bond" = the company's shares/equity
- The "coupon" = the company's _pretax earnings_ (not dividends)
- The yield = Pretax Earnings per share ÷ Purchase Price per share

**Equity Bond Value = Pretax Earnings per share ÷ Long-Term Corporate Bond Rate**

Example (Coca-Cola 2007): Pretax $3.96 ÷ 6.5% = ~$60/share. Stock traded $45-64.

The DCA causes earnings to increase year after year. The stock market eventually revalues the shares to reflect this.

---

## When to Buy

- Lower price → better long-term return
- Buy in bear markets
- Buy when a great business confronts a one-time solvable problem
- _Stay away_ at bull market peaks with historically high P/Es

## When to Sell

1. Need money for an even better company at a better price
2. Company appears to be losing its DCA
3. P/E reaches 40+ in a raging bull market (sell and put proceeds in Treasuries; wait for next bear market)

## Quick-Reference: DCA Indicators

| Metric                      | What to Look For                             |
| --------------------------- | -------------------------------------------- |
| Gross Profit Margin         | ≥ 40%, consistent for 10 years               |
| Net Earnings / Revenue      | > 20% (non-financial)                        |
| Capex / Net Earnings        | ≤ 50%; ≤ 25% is ideal                        |
| Long-Term Debt              | Payable in 3-4 years of earnings             |
| Adjusted D/E Ratio          | < .80 (non-financial)                        |
| ROE                         | Consistently high (e.g., 20%+)               |
| R&D                         | Low or none                                  |
| Interest / Operating Income | Lowest in industry                           |
| Per-Share Earnings          | 10-year consistent upward trend              |
| Retained Earnings Growth    | Positive, consistent growth                  |
| Share Buybacks              | History of repurchasing shares               |
| Cash + Debt                 | Lots of cash, little/no debt from operations |
