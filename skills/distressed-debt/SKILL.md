---
name: distressed-debt
description: Analyze distressed and bankrupt companies from a creditor's point of view, covering the fulcrum security, distressed investing strategies, bankruptcy mechanics (DIP financing, 363 sales, credit bidding, valuation fights, avoidance actions), subordination, liability management, and liquidation and recovery analysis. Use this skill when the user asks about a company in or near bankruptcy, a debt restructuring, recovery or waterfall analysis, priority and subordination of claims, impaired loans or bonds, creditor-on-creditor disputes, or opportunistic trades in troubled debt, even if they don't say "distressed" or "bankruptcy."
---

# Distressed Debt

Framework from _The Credit Investor's Handbook: Leveraged Loans, High Yield, and Distressed Debt_ by Michael Gatto (Wiley, 2024).

The seven-step credit process (see the `credit-analysis` skill) is a prerequisite. Distressed returns also depend on legal arguments, reading other parties' motivations and constraints, and negotiating good deals. Distressed investing is often a zero-sum fight over a company worth less than the claims against it.

---

## What Distressed Debt Is

There is no strict definition; a common screen is floating-rate debt below 85% of face or a bond yielding over 1,000 basis points over Treasuries. The practical test: the investor believes the company will restructure or face a liquidity crisis.

Why opportunities exist: positions build over time, so a fund can profit even if it is outbid; there is usually no strategic buyer, because competitors cannot trade the debt; original holders are often forced sellers (ratings-driven mandates, collateralized loan obligation CCC limits, redemptions, defaulted-debt restrictions); and a bankruptcy filing is a sell trigger for "par" holders. Idiosyncratic triggers include self-inflicted wounds, a worsening competitive landscape, secular business model shifts, and over-leverage built for growth that never came.

Credit is cyclical (expansion, downturn, recovery, repair). The best opportunities come in dislocations such as 2008 and early 2020, when forced selling is greatest and buyers are paralyzed.

---

## The Fulcrum Security

The fulcrum is the class entitled to some but not full recovery, where value runs out, typically converted into the reorganized company's equity ("reorg equity"). Distressed-for-control investors accumulate it. Identifying the fulcrum depends entirely on the plan value.

---

## Eight Strategies

| Strategy                     | Description                                                                                                                                                                     |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| New financing                | Emergency financing for a turnaround, debtor-in-possession (DIP) loans, and exit financing                                                                                      |
| Spread tightening            | Buy debt trading too cheap relative to underlying risk, expecting spread to retrace toward peers                                                                                |
| Distressed for control       | Accumulate the fulcrum security, then convert debt into equity                                                                                                                  |
| Fundamental value            | Long or short where the analyst's valuation differs from the market                                                                                                             |
| Capital structure arbitrage  | Long one instrument, short another in the same capital structure (secured versus unsecured, short versus long maturity, differing legal protections, guarantees, or collateral) |
| Trade claims and vendor puts | Buy pre-petition trade claims, often below pari passu bonds, or write puts giving vendors credit insurance                                                                      |
| Liquidations                 | Companies that will cease to exist; the market often assumes the worst, which can create upside                                                                                 |
| Special situations           | Idiosyncratic, often avoided situations (for example, sovereign claims)                                                                                                         |

Spread tightening: model the price after the expected spread retracement, then compute internal rate of return and multiple of money for upside and downside scenarios.

Capital structure arbitrage: downside on the short debt leg is bounded because debt cannot exceed par plus a call premium. Shorting equity alongside the debt is not true arbitrage, because equity has no cap.

---

## Bankruptcy Essentials

Chapter 7 liquidates; Chapter 11 reorganizes. Filings are prepackaged (fully negotiated, 45 to 90 days), prearranged (partially negotiated), or traditional "freefall" (1.5 to 3+ years). Debtors usually file in Delaware, the Southern District of New York, or the Southern District of Texas. Three reasons to file: a liquidity crisis, an unsustainable capital structure ("upside down"), or the need to resolve litigation.

Claim priority, highest to lowest:

1. Administrative (post-petition, including professional fees and post-petition vendors; paid in full in cash to exit).
2. Other priority (wages, vacation, severance up to limits).
3. Secured (principal and pre- and post-petition interest up to collateral value; any shortfall is a general unsecured deficiency claim).
4. General unsecured (pre-petition trade, accrued liabilities, underfunded pensions, unsecured debt; no post-petition interest unless the estate is solvent or through subordination turnover).
5. Equity (preferred, then common; usually wiped out).

A class accepts when at least two-thirds in amount and one-half in number of voters approve. A dissenting class can be crammed down if at least one impaired class accepted and the plan is fair and equitable under the absolute priority rule (no class beneath a crammed-down class recovers). Junior classes often receive a small "tip" to consent.

Mechanics:

- DIP financing: a post-petition loan with super-priority status that primes pre-petition secured lenders. It may prime a lender only if that lender is over-collateralized. Often the pre-petition lenders provide it.
- Section 363 asset sales: sell the business free and clear of liens and claims without a creditor vote. Section 363(k) lets secured creditors credit bid at face value, giving them a large edge over cash bidders. A stalking horse sets the floor and typically gets a 2% to 5% break-up fee.
- Valuation fights: the plan value sets the fulcrum. Senior classes argue for a low value to capture equity; junior classes argue for a high value to preserve recovery. There is no bright line; the judge may decide.
- Avoidance actions: preferences (recover payments made in the 90 days before filing; one year for insiders) and fraudulent conveyances (transfer for less than fair value while insolvent). Defenses are ordinary course of business and new value.
- Equitable subordination: a court may lower a claim's priority for inequitable conduct that injured other creditors or conferred an unfair advantage. Board seats create "alter ego" risk.
- Lender liability: the borrower may sue a lender for breach of contract or wrongful conduct; damages can exceed the loan.

---

## Subordination

Time subordination: outside bankruptcy, near-term maturities are repaid before longer debt. Modern secured loans use a springing maturity that accelerates to before a junior maturity if the junior debt is not refinanced.

Contractual subordination: subordinated bondholders turn over recovery to senior debt until it is paid in full. Read the exact wording; subordination often runs only to bonds and bank debt, not trade claims, and sometimes only to specific senior instruments. Such distinctions create arbitrage.

Structural subordination: debt at a holding company (HoldCo) is junior to debt at the operating company (OpCo), because HoldCo owns only OpCo equity and is paid after OpCo claims. An upstream guarantee from OpCo removes this but can be challenged as a fraudulent conveyance.

Substantive consolidation ("sub con"): the court treats separate entities as one, eliminating intercompany claims and making all unsecured claims pari passu. It helps HoldCo claims and hurts OpCo claims, and it is rare absent fraud.

Double dip claims: a finance subsidiary issues guaranteed bonds and lends the proceeds to the parent, giving bondholders two claims against the parent (the intercompany loan and the guarantee), capped at the amount lent. Lehman Brothers Treasury is the classic example; substantive consolidation eliminates the double dip.

---

## Liability Management and Creditor-on-Creditor Violence

Weak documentation lets borrowers and some creditors disadvantage others.

- Asset stripping ("getting J. Screwed"): moving pledged assets, such as intellectual property, to an unrestricted subsidiary through broadly worded permitted investment baskets, removing them from the collateral pool. J. Crew moved its trademarks.
- Uptiering ("getting Serta'd"): a majority of lenders consent to a new priming loan and exchange their own debt into it, cutting ahead of non-consenting lenders who shared the same security.

Read the documents and retain outside counsel when these baskets exist.

---

## Liquidation and Recovery Analysis

Steps: list every asset; estimate orderly-sale value less wind-down costs; estimate claims and their priority; distribute value by priority.

Retail recovery ranges: inventory 70% to 100% of book (get liquidator input); receivables 90%+ for consumer receivables; owned real estate (replacement cost, comparable sales per square foot, or net operating income / cap rate); in-the-money leases (present value of rent savings; bankruptcy voids non-assignability); brands zero to very high; other fixtures 0% to 20%.

Lease rejection claim: capped at the greater of one year of rent or 15% of the remaining payments, up to three years.

Waterfall, subtract in order: liquidation value, current DIP balance, wind-down costs, other administrative and priority claims, secured pre-petition claims, then split the remainder across general unsecured claims pro rata.

---

## Gotchas

- Fulcrum identification drives recoveries; the plan value decides. A low value favors senior classes, a high value favors junior classes.
- Debt above par is capped by call protection; short debt downside is bounded, short equity is not.
- Guarantees without consideration can be voided as fraudulent conveyances.
- Post-petition interest goes to secured creditors within collateral value; unsecured creditors generally get none unless the estate is solvent or through turnover.
- A DIP primes a secured lender only if that lender is over-collateralized.
- Credit bidding uses face value, so it can shut out junior classes.
- Substantive consolidation destroys guarantee and double dip value.
- Board seats and dictating advisors create equitable subordination risk; keep a clean paper trail.

---

## Quick-Reference

```text
Recovery    = distributable value to a class / that class's claim
Equity value (reorg) = plan enterprise value - net debt
Fulcrum     = class where value runs out
Double dip  = intercompany loan claim + parent guarantee claim
```

- Finish the seven-step credit analysis first.
- Set the plan value range and identify the fulcrum.
- Build the waterfall and compute recovery per class.
- Check time, contractual, structural, and substantive consolidation effects, guarantees, and double dip.
- Review documents for stripping baskets, uptiering exposure, and pro rata sharing.
- For a liquidation, value assets, subtract costs and priority claims, and compute general unsecured recovery.
- For a trade, define scenarios, expected return, cost of carry, and probability-weighted profit and loss.
