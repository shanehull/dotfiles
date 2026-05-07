---
name: yfinance
description: Fetch stock data and financial information — quotes, price history, company financials, option chains, market sectors, institutional holders, insider transactions, and news. Use this skill when the user asks about stocks, company financials, options, or market analysis, even if they don't mention a ticker symbol or Yahoo Finance.
compatibility: Requires yfinance MCP server connection.
allowed-tools: yfinance_*
---

# Yahoo Finance

Access real-time and historical stock data, company information, and financial news.

## Gotchas

- **Interval/period compatibility** — minute intervals (`1m`, `5m`, `15m`, `30m`) only work with short periods (`1d`, `5d`). Using `1m` with `1y` returns an error.
- **Option expiration dates** — call `yfinance_get_option_dates` first to get valid dates. Passing an invalid or expired date to `yfinance_get_option_chain` silently returns empty data.
- **Missing fields** — `yfinance_get_ticker_info` field availability varies by security type. ETFs lack some fields (e.g., `pegRatio`). Check for `null` before using.
- **Sector names are exact** — `yfinance_get_top` requires exact sector names from the list below. `"Tech"` or `"finance"` won't match — use `"Technology"`, `"Financial Services"`.

## Tools

### Get Ticker Info

`yfinance_get_ticker_info(symbol="AAPL")` — Comprehensive company and trading data.

Key fields: `currentPrice`, `marketCap`, `trailingPE`, `forwardPE`, `dividendYield`, `earningsGrowth`, `profitMargins`, `sector`, `industry`, `fiftyTwoWeekHigh`, `fiftyTwoWeekLow`, `beta`, `targetMeanPrice`, `recommendationKey`.

Full output covers company profile, price, valuation, trading, dividends, financials, returns, balance sheet, and analyst ratings. See the tool's JSON response for all available fields.

## Calculated Metrics

Use these formulas with data from `yfinance_get_ticker_info` or `yfinance_get_financials`:

| Metric         | Formula                                                                                       |
| -------------- | --------------------------------------------------------------------------------------------- |
| P/B            | `priceToBook` or `currentPrice / bookValue`                                                   |
| P/TB           | `currentPrice / (tangibleBookValue / sharesOutstanding)`                                      |
| Dividend Yield | `dividendYield`                                                                               |
| FCF Yield      | `freeCashflow / marketCap`                                                                    |
| EV/EBITDA      | `enterpriseValue / ebitda`                                                                    |
| EV/FCF         | `enterpriseValue / freeCashflow`                                                              |
| Earnings Yield | `1 / trailingPE`                                                                              |
| Net Debt       | `totalDebt - totalCash`                                                                       |
| Debt/Equity    | `debtToEquity`                                                                                |
| ROIC           | `(EBIT × (1 - Tax Rate)) / Invested Capital` where Tax Rate = `Tax Provision / Pretax Income` |

### Get Financials

`yfinance_get_financials(symbol="AAPL", frequency="annual")` — Historical income statement, balance sheet, and cash flow data. Frequency: `annual`, `quarterly`, or `ttm`.

Use annual data to calculate CAGRs and multi-year averages. The tool returns `ebit`, `netIncome`, `totalRevenue`, `operatingIncome`, `ebitda`, `totalDebt`, `totalCash`, `freeCashFlow`, `capitalExpenditure`, and more.

### Get Price History

`yfinance_get_price_history(symbol="AAPL", period="1mo", interval="1d", chart_type="price_volume")` — Historical prices with optional charts.

Period: `1d`–`max`. Interval: `1m`–`1mo` (minute intervals require short periods). Chart types: `price_volume`, `vwap`, `volume_profile`.

Returns: Date, Open, High, Low, Close, Volume, Dividends, Stock Splits.

To get price history for an individual option contract, pass the full contract symbol from `yfinance_get_option_chain` (e.g., `WEAT270115C00035000`).

### Get Ticker News

`yfinance_get_ticker_news` - Recent news and press releases for a stock.

**Example**: `yfinance_get_ticker_news(symbol="TSLA")`

### Search

`yfinance_search` - Find ticker symbols by company name or keywords.

- search_type: "all", "quotes", or "news"

**Example**: `yfinance_search(query="Nvidia", search_type="quotes")`

### Get Holders

`yfinance_get_holders(symbol="AAPL", max_rows=10)` — Ownership and insider data.

Returns: `major_holders` (insider/institutional %), `institutional_holders` (top investors by shares), `mutualfund_holders`, `insider_transactions` (recent trades), `insider_purchases` (6-month summary), `insider_roster` (known insiders by position).

Use for: insider ownership %, institutional concentration, insider trading patterns.

### Get Top (Sector Data)

`yfinance_get_top` - Top-ranked entities within a sector:

- top_etfs: Popular ETFs for a sector
- top_mutual_funds: Popular mutual funds
- top_companies: Largest by market cap
- top_growth_companies: Fastest revenue/earnings growth
- top_performing_companies: Best stock price performance

**Example**: `yfinance_get_top(sector="Technology", top_type="top_companies", top_n=10)`

Valid sectors: Basic Materials, Communication Services, Consumer Cyclical, Consumer Defensive, Energy, Financial Services, Healthcare, Industrials, Real Estate, Technology, Utilities

### Get Option Dates

`yfinance_get_option_dates` - Available expiration dates for a stock's options.

**Example**: `yfinance_get_option_dates(symbol="AAPL")`

Returns: Array of expiration dates in YYYY-MM-DD format.

### Get Option Chain

`yfinance_get_option_chain(symbol="AAPL", expiration_date="2025-05-16", option_type="calls")` — Calls and puts with strikes and pricing.

Returns per contract: `strike`, `lastPrice`, `bid`, `ask`, `volume`, `openInterest`, `impliedVolatility`, `inTheMoney`.

**Workflow**: Use `yfinance_get_option_dates` first to find valid dates, then `yfinance_get_option_chain` for the full chain.

## Options Formulas

Use data from `yfinance_get_option_chain`. Both formulas share the same algebra; they differ in derivation and robustness.

```
d1 = (ln(S/K) + (r + σ²/2)T) / (σ√T)
d2 = d1 - σ√T

Call = S·N(d1) - K·e^(-rT)·N(d2)
Put = K·e^(-rT)·N(-d2) - S·N(-d1)
```

Where: S = stock price, K = strike, T = years to expiry, r = risk-free rate (~5%), σ = IV from option chain (decimal), N() = std normal CDF.

### Black-Scholes-Merton

Derived via continuous dynamic hedging in a Gaussian world. Assumes one constant σ for all strikes. The hedge argument removes drift; all moments must be finite. Fragile to fat tails. Historically never used by traders as intended (Haug & Taleb, 2008).

### Bachelier-Thorp (per Taleb/Haug: strike-specific IV, realized vol)

**Same formula, same math, same computation.** Do not substitute a different formula. Do not use the Bachelier (1900) arithmetic Brownian motion model — that is a different thing entirely.

The only change: use σ at each strike from the option chain (the "volatility smile") rather than a single σ for all strikes. Removes drift via put-call parity, no distributional assumption, no dynamic hedging required. σ is a quoting convention, not an estimate. Works under fat tails, jumps, any distribution.

Realized volatility from `yfinance_get_price_history`:

```
log_returns = ln(close_t / close_{t-1})
σ_realized = std(log_returns) * sqrt(252)
```

Substitute σ_realized for market-implied σ to get a model-free price from historical data. Annualize with `sqrt(periods)` for other sampling frequencies.

### The Greeks

```
Delta = N(d1) (call) or N(d1) - 1 (put)
Gamma = N'(d1) / (S·σ·√T)
Theta = -[S·N'(d1)·σ / (2√T)] - r·K·e^(-rT)·N(d2) (call)
       or -[S·N'(d1)·σ / (2√T)] + r·K·e^(-rT)·N(-d2) (put)
Vega  = S·√T·N'(d1)
Rho   = K·T·e^(-rT)·N(d2) (call) or -K·T·e^(-rT)·N(-d2) (put)
```

### Put-Call Parity

```
Call - Put = S - K·e^(-rT)
```

### Quick Estimates

| From                   | Formula                   |
| ---------------------- | ------------------------- |
| Break-even (call)      | strike + premium paid     |
| Break-even (put)       | strike - premium paid     |
| Intrinsic value (call) | max(0, S - K)             |
| Intrinsic value (put)  | max(0, K - S)             |
| Time value             | premium - intrinsic value |

See `references/ticker-suffixes.md` for complete ticker suffix reference by exchange.
