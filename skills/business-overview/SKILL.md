---
name: business-overview
description: Create detailed business overviews for investment research — deep-dive through business model, management, financials, valuation, risks and tracking. Use this skill when the user wants to write up a company analysis, evaluate an investment, or document due diligence on a stock, even if they don't explicitly say "business overview" or mention the template. Also use when the user says "write up notes on [ticker]" or "help me understand this company."
compatibility: Works alongside buffett-financials and yfinance for financial data.
allowed-tools: yfinance_*, ibkr_*, fred_*, qmd_*, Read, Bash
---

# Business Overview

## CRITICAL RULE (Never Breach)

**Never save a business overview** until EVERY heading below has been researched and discussed back-and-forth with the user. This is the entire purpose of the skill — the agent must not shortcut to writing. If the user tries to rush, push back and continue the discussion.

## Adapt the Approach

The business type determines the starting point — deep value starts with balance sheet and downside floor, high-ROIC stable growth starts with FCF and returns. Stable cash flows are always relevant regardless of type. Let the back-and-forth discussion surface what matters; do not impose a fixed checklist of metrics.

## Workflow

Before diving into each heading, briefly state what you're looking for and why given the business type. This makes assumptions visible and lets the user correct course early.

Before moving on from any heading, ask the user if they want to explore further. Only tick the heading when the user signals they're satisfied. Never assume a heading is done without explicit user confirmation.

- [ ] **The Business** — What does the company do? Moat? Revenue model? Economic environment? Capital cycle?
- [ ] **The Management** — Track record, insider ownership, incentives, skin in the game.
- [ ] **The Numbers** — Key metrics tailored to the business type. Always probe for stable cash flows.
- [ ] **Valuation** — Conservative assumptions. Upside and expected return. If it cannot be valued on the back of a napkin, move on.
- [ ] **Risks** — Key threats: competition, cyclicality, balance sheet, execution. Probability and magnitude.
- [ ] **Tracking** — What confirms the thesis? What invalidates it? Concrete thresholds and kill criteria.
- [ ] **Conclusion** — 2-3 sentences synthesising the discussion.
- [ ] **Save** — Only after every heading above is confirmed by the user.

## Core Tenets

Evaluate each section through these lenses:

1. **Value** — Undervalued relative to cash flows, assets, or replacement cost.
2. **Time Horizon** — Longer horizon = less competition. Keep it simple.
3. **Skin in the Game** — Favor owners/operators with significant skin in the game and rational incentives.
4. **Capital Cycle** — Target capital starved industries or businesses that defy the cycle through superior allocation.

## Valuation Models

The user works with two approaches depending on business type:

- **DCF and reverse DCF** — for high-ROIC stable growth businesses. Use reverse DCF to let the market tell you what assumptions are priced in, then debate whether they're too optimistic or pessimistic.
- **Balance sheet deep-dive** — for deep value. Focus on net cash, receivable recovery, inventory liquidation, PP&E recovery, goodwill write-offs, off-balance-sheet items (operating leases, pensions, contingencies), and the user's own recovery estimates per asset class. Determine the hard downside floor before looking at earnings power.

## Output Template

Use this structure when saving to the vault:

```md
#### The Business

What the company does, its moat, and revenue model. Assess capital cycle — is the industry starved or over-supplied?

#### The Management

Track record, insider ownership, and incentives. Are they owner-operators with skin in the game?

#### The Numbers

Key metrics, tailored to the business: revenue growth, margins, ROIC, debt, goodwill, etc. Focus on cash flows, returns on capital, and balance sheet strength.

#### Valuation

Conservative assumptions (growth rate, exit multiple, margin of safety). Quantify upside and expected return. If it cannot be valued on the back of a napkin, move on.

#### Risks

Key threats to the thesis: competition, cyclicality, balance sheet, management execution. Consider probability and magnitude.

#### Tracking

Metrics to monitor. What confirms the thesis? What invalidates it? Use concrete thresholds.

#### Conclusion

2–3 sentences: why attractive at today's price, long-term outlook.
```

## Gotchas

- **Back-and-forth is the engine.** One message per heading is never enough. Probe, challenge, adapt — do not arrive with a fixed question list.
- **Source everything.** Cite the actual document ("Annual Report FY2025," "Q2 earnings call transcript"), not the tool used to fetch it. If data is missing (segment detail, off-balance-sheet items, insider specifics), ask the user if they have the source. Do not make assumptions to fill gaps.
- **Do not fill the template during discussion.** Only populate at the end after all headings are exhausted.
- **Third person only.** Analysis, not personal opinion.
