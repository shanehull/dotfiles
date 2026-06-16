---
name: special-situations
description: Evaluate spinoffs, merger securities, post-bankruptcy orphan equities, corporate restructurings, stub stocks, recapitalizations, rights offerings, and LEAPS/warrants in extraordinary corporate events. Use this skill when the user asks about a company undergoing a corporate change, mentions a spinoff, merger consideration, post-reorg stock, going-private transaction, Dutch auction tender, rights offering, or corporate breakup, even if they don't name the event type explicitly.
---

# Special Situations

Framework from _You Can Be a Stock Market Genius_ by Joel Greenblatt.

---

## Strategy Tier List

| Tier | Strategy                            | Edge                                                                              | Rule                                                                                      |
| ---- | ----------------------------------- | --------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| S    | **Spinoffs**                        | Forced index/institutional selling; 10%/yr outperformance (Penn State 25yr study) | Wait for spinoff listing document; largest gains in year 2                                |
| S    | **Merger Securities**               | Recipients sell foreign securities without reading proxy                          | Read "Merger Consideration" section; non-cash <10% of total = near-certain forced selling |
| A    | **Post-Bankruptcy Orphan Equities** | Creditors don't want stock; outperforms by 20%+ in first 200 days                 | Only buy AFTER emergence; never common stock DURING bankruptcy                            |
| A    | **Corporate Restructurings**        | Division sale/closure unmasks hidden earnings                                     | Division must be material relative to whole                                               |
| B    | **Stub Stocks / Recaps**            | Leverage + tax shield                                                             | Rare post-1990; prefer leveraged spinoffs instead                                         |
| B    | **LEAPS**                           | Leverage + limited loss + 2.5yr runway                                            | Never >10-15% of portfolio                                                                |
| C    | **Rights Offerings**                | Complexity deters participation                                                   | Only if insiders exercise fully                                                           |
| D    | **Risk Arbitrage**                  | Spread capture                                                                    | **SKIP** — too competitive, too much monitoring                                           |
| D    | **Bankruptcy Debt**                 | Distressed debt mispricing                                                        | **SKIP** — vulture investor territory, full-time job                                      |

---

## 1. Spinoffs

### Formulas

```
Equity / Enterprise Value = Market Cap / (Market Cap + Total Debt - Cash)
Debt per Share = Total Debt / Shares Outstanding
```

Equity/EV < 0.15–0.20 = high leverage spinoff: small enterprise-value moves → large equity moves.

```
Parent post-spinoff earnings change = (Debt transferred × Interest rate) − Forgone operating income
```

If positive, the parent may _rise_ on distribution date — markets value reported EPS.

### Selection Checklist

Score 1 point each. ≥5 = compelling.

- [ ] Spinoff market cap <$100M or <20% parent size (too small for institutions)
- [ ] Different industry than parent (shareholders have no reason to hold)
- [ ] Parent in major index → spinoff excluded → forced index selling
- [ ] High debt / ugly assets on surface (deters research)
- [ ] Share price <$10 (further institutional deterrent)
- [ ] Management incentive plan >10% of spinoff shares
- [ ] CEO chose to run the spinoff (not dumped)
- [ ] Insiders forgoing cash in exchange for additional spinoff equity
- [ ] Founder/controlling shareholder retaining proportional stake in both entities
- [ ] Tax-free distribution status — signals shareholder orientation
- [ ] Regulated subsidiary being spun off — may signal parent takeover to follow
- [ ] Pro-forma earnings at low end of industry P/E range _before_ factoring hidden positives

### Valuation Screen

1. Extract pro-forma EPS from spinoff listing document.
2. Identify industry P/E range from comps (industry data services or peer data).
3. Apply **low-end P/E** to compute floor price.
4. Read "Business of the Company" section for undisclosed positives (new customer wins, market share, assets hidden by depreciation).
5. Compare floor price to actual post-distribution trading price.

### Parent Company Play

**Check if parent becomes more valuable post-spinoff:**

- Is it shedding a volatile/loss-making division?
- Will reported EPS increase? (See formula above)
- Does the simplified entity become a takeover target?

---

## 2. Merger Securities

### When to Look

Takeover consideration includes anything beyond 100% cash or 100% common stock.

### Computable Checks

```
Non-cash ratio = Value of non-cash consideration / Total consideration
```

Non-cash <10% → near-guaranteed forced selling (too small to care about).

For each security in "Merger Consideration" section of scheme documents:

- **Face value vs. expected trading price:** Compute discount to face value.
- **Warrants:** Can exercise price be paid with face value of _other_ merger securities trading at a discount? Compute: `Exercise cost = Face value needed × Market discount %`
- **CVRs:** Compute floor value = `Max(Payout, 0)` at current stock price. Compute upside if stock exceeds guarantee level.
- **Zero-strike warrants:** Free equity alongside management insider group.

### Going-Private Signal

Management buying the company — strongest insider conviction signal. Going-private scheme documents have enhanced disclosures (management projections, fairness opinions). Verify management is **keeping** (not selling) pre-transaction stake and receiving equity, not cash bonuses.

---

## 3. Post-Bankruptcy Orphan Equities

### Hard Rules

- **NEVER** buy common stock of company still in bankruptcy protection (shareholders bottom of totem pole).
- **NEVER** trade bankruptcy debt unless full-time.
- **ONLY** buy new common stock post-emergence.

### Selection Filter

**Business quality** (filter first — most fail):

- [ ] Cause was **overleverage**, not bad business (failed LBO, cyclical-timing, isolated product liability)
- [ ] Retains market niche, brand, franchise, or industry position
- [ ] Exclude: secular decline, no-moat commodity, liquidation-bound

**Valuation:**

```
Stigma discount = Industry P/E − Post-reorg P/E (normalized to same leverage)
```

If stigma discount >20% of industry comp and business quality passes → attractive.

**Disclosure Statement:** Contains management projections (more informative than IPO prospectus). Discount projections 25–40%. Compare discounted EPS to post-reorg stock price.

### Selling Heuristic

**Bad business + bargain purchase → Trade it** (sell when coverage starts / story is out).  
**Good business + bargain purchase → Invest** (hold long-term).

---

## 4. Corporate Restructurings

### Hidden Earnings Formula

```
Revealed EPS = (Profitable segment earnings + Loss-making segment losses reversed) / Shares outstanding
```

If a division with $X loss is sold/closed at no net cost:

```
Post-restructuring EPS = Reported EPS + |X|/Shares
Implicit Pre-Restructuring P/E = Price / Reported EPS
Post-Restructuring Price (same P/E) = Post-Restructuring EPS × Implicit P/E
```

Plus: sale proceeds → special dividend or debt reduction → additional value.

### Agent Check

From annual report segment reporting, extract each segment's operating income. Compute:

```
Hidden earnings = |Sum of loss-making segment operating incomes| / Shares outstanding
```

The gap between revealed EPS and reported EPS is unmasked value.

### Dutch Auction Tender Signal

- Management tendering **zero** shares → bullish
- Shares repurchased >20% of outstanding → high conviction
- Accretion check: `(Intrinsic value − Buyback price) × Shares repurchased / Remaining shares`

---

## 5. Leveraged Equities

### Recapitalization Math

```
Value created = StubPrice + DebtDistributed − OriginalPrice

Pre-recap:  After-tax EPS = Pretax × (1 − TaxRate), Price = EPS × P/E_pre
Post-recap: After-tax EPS = (Pretax − Interest) × (1 − TaxRate), StubPrice = EPS × P/E_post
            P/E_post < P/E_pre (higher risk, typically 8–9 vs. 12)
```

Gain driver: interest is tax-deductible; dividends are not. Tax shield creates ~$4 per $100 of debt distributed at 10% interest, 40% tax rate.

### Stub Leverage Computation

```
Equity multiplier = 1 / (Equity / EV)
```

1% EV change ≈ Equity multiplier × 1% stub change.

### LEAPS Risk/Reward Test

```
Upside   = (TargetPrice − Strike − Premium) / Premium
Downside = 1.0 (lose entire premium)
Require: Upside ≥ 3.0
```

**When LEAPS beat common stock:** Binary outcome with catalyst within expiration window; high-conviction idea where you want to limit downside.

### Options on Corporate Events

Option pricing models use **historical** volatility. Corporate events (spinoff distribution dates, merger closes) create **future** volatility models miss.

**Spinoff option play:** Buy parent calls expiring **after** spinoff distribution date. Both entities trade independently post-distribution; parent may re-rate as simplified company.

**Merger option play:** Buy acquirer calls expiring 1–2 months **after** merger close. Risk-arb short-selling pressure lifts after close.

---

## Free Cash Flow

Greenblatt's default valuation metric when amortization charges are large.

```
FCF = Net Income + Depreciation + Amortization − Capital Expenditures
FCF Yield = FCF per Share / Stock Price
```

**Use FCF over P/E when:**

- Amortization >10% of net income (broadcasters, cable, serial acquirers)
- Depreciation consistently overstates/understates maintenance capex
- 3yr average FCF > 3yr average NI → value on FCF multiple instead

---

## Portfolio Rules

- 5–8 positions sufficient — diversification beyond ~10 stocks doesn't meaningfully reduce annual volatility
- Diversify across asset classes (cash, bonds, real estate), not within equity portfolio
- Never allocate money needed within 2–3 years
- LEAPS never >10–15% of portfolio
- No margin debt without substantial experience

---

## Regulatory Filing Map

Key documents to locate for each event type (jurisdiction-specific names vary):

| Event                | Document                                                                                                     | Contents                                                                               |
| -------------------- | ------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------- |
| Spinoff              | **Listing document / information statement** (US: Form 10, AU: Information Memorandum, UK: Class 1 circular) | Pro-forma financials, business description, reasons, incentive plan, capital structure |
| Merger               | **Scheme booklet / merger proxy** (US: S-4, AU: Scheme Booklet, UK: Scheme Document)                         | Merger consideration, fairness opinion, projections                                    |
| Going Private        | **Going-private circular + independent expert report** (US: 13E-3)                                           | Enhanced disclosures, management projections, conflicts                                |
| Self-Tender          | **Buyback offer document** (US: 13E-4)                                                                       | Strategy, management participation disclosure                                          |
| Activist             | **Substantial shareholder notice** (US: 13D, AU: Substantial Holder Notice, UK: TR-1)                        | Stake %, purpose, plans                                                                |
| Bankruptcy Emergence | **Reorganisation plan / disclosure statement**                                                               | Reorg plan, new cap structure, projections                                             |

Spinoff listing documents: the summary section (first 5–10 pages after contents) covers key points. Read "Reasons for the Distribution" and incentive plan disclosures first.

---

## Quick-Reference Scorecard

### Red Flags (automatic skip)

- Common stock of company still in bankruptcy protection
- Risk arbitrage spread <5%
- Spinoff with no management stock incentive plan
- Post-bankruptcy company in secular decline
- LEAPS >15% of portfolio on any single idea

### Green Flags (highest-probability setups)

- Major-index parent spinoff with management incentive plan >10%
- Merger security <10% of total consideration
- Good business in bankruptcy due to overleverage, not bad operations
- Dutch auction where management tenders zero shares
- Parent EPS **increases** after spinoff (debt interest shifted > forgone income)
- LEAPS upside:downside ≥3:1 with catalyst inside expiration window
