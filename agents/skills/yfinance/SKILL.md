---
name: yfinance
description: Get stock data, financial information, price history, and market news via Yahoo Finance. Use when user asks for stock quotes, company financials, ticker info, or market data.
compatibility: Requires yfinance MCP server connection.
allowed-tools: yfinance_*
---

# Yahoo Finance

Access real-time and historical stock data, company information, and financial news.

## Tools

### Get Ticker Info

`yfinance_get_ticker_info(symbol="AAPL")` - Comprehensive stock data.

**Company**: symbol, longName, shortName, sector, industry, country, city, website, fullTimeEmployees, longBusinessSummary

**Price**: currentPrice, previousClose, open, dayLow, dayHigh, fiftyTwoWeekLow, fiftyTwoWeekHigh, fiftyDayAverage, twoHundredDayAverage, regularMarketChange, regularMarketChangePercent

**Valuation**: marketCap, enterpriseValue, trailingPE, forwardPE, priceToBook, priceToSalesTrailing12Months, pegRatio

**Trading**: volume, averageVolume, averageVolume10days, bid, ask, exchange, tradeable

**Dividends**: dividendRate, dividendYield, exDividendDate, payoutRatio, fiveYearAvgDividendYield, lastDividendValue, lastDividendDate

**Financials**: totalRevenue, revenuePerShare, revenueGrowth, grossProfits, grossMargins, ebitda, ebitdaMargins, operatingMargins, profitMargins, netIncomeToCommon, earningsGrowth

**Returns**: returnOnAssets, returnOnEquity

**Per Share**: bookValue, totalCashPerShare, trailingEps, forwardEps, epsTrailingTwelveMonths, epsForward

**Balance Sheet**: totalCash, totalDebt, quickRatio, currentRatio, debtToEquity

**Analyst**: targetHighPrice, targetLowPrice, targetMeanPrice, targetMedianPrice, recommendationMean, recommendationKey, numberOfAnalystOpinions, averageAnalystRating

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

`yfinance_get_financials` - Historical financial statements:

- frequency: "annual" (yearly), "quarterly" (quarterly), or "ttm" (trailing twelve months)

Returns income statement, balance sheet, and cash flow data across periods.

**Income Statement**: EBIT, Net Income, Tax Provision, Pretax Income, Total Revenue, Operating Income, EBITDA
**Balance Sheet**: Stockholders Equity, Total Debt, Cash, Invested Capital, Net Debt, Total Assets
**Cash Flow**: Operating Cash Flow, Free Cash Flow, Capital Expenditure

**Use annual data**: Calculate CAGRs or averages for any field across years.

### Get Price History

`yfinance_get_price_history` - Historical price data with optional charts:

- Period: 1d, 5d, 1mo, 3mo, 6mo, 1y, 2y, 5y, 10y, ytd, max
- Interval: 1m, 5m, 15m, 30m, 1h, 1d, 1wk, 1mo (minute intervals require 1d/5d period)
- Chart types: price_volume, vwap, volume_profile

Returns: Date, Open, High, Low, Close, Volume, Dividends, Stock Splits (as markdown table or chart image)

**Individual option contracts**: Pass the full contract symbol from `yfinance_get_option_chain` (e.g., `WEAT270115C00035000`) to get the price history for a particular contract — useful for computing its lifetime range and typical trading range at different underlying levels.

### Get Ticker News

`yfinance_get_ticker_news` - Recent news and press releases for a stock.

**Example**: `yfinance_get_ticker_news(symbol="TSLA")`

### Search

`yfinance_search` - Find ticker symbols by company name or keywords.

- search_type: "all", "quotes", or "news"

**Example**: `yfinance_search(query="Nvidia", search_type="quotes")`

### Get Holders

`yfinance_get_holders` - Ownership data including institutional investors, mutual funds, and insider activity.

**Example**: `yfinance_get_holders(symbol="AAPL")`

Returns six sections:

- **`major_holders`**: Each row has an `index` label (`insidersPercentHeld`, `institutionsPercentHeld`, `institutionsFloatPercentHeld`, `institutionsCount`) and a `Value`.
- **`institutional_holders`**: Top institutional investors with `Holder`, `Shares`, `Value`, `pctChange`, `pctHeld`, `Date Reported`.
- **`mutualfund_holders`**: Same fields as institutional holders.
- **`insider_transactions`**: Recent insider trades with `Insider`, `Transaction`, `Shares`, `Value`, `Start Date`, `Ownership`, `Position`.
- **`insider_purchases`**: Six-month summary where each row is a category (`Purchases`, `Sales`, `Net Shares Purchased (Sold)`, `Total Insider Shares Held`) with `Insider Purchases Last 6m`, `Shares`, `Trans`.
- **`insider_roster`**: Known insiders with `Name`, `Position`, `Shares Owned Directly`, `Most Recent Transaction`, `Latest Transaction Date`.

**Use for**: Insider ownership %, institutional concentration, insider trading patterns, ownership analysis.

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

`yfinance_get_option_chain` - Full option chain with strikes and pricing:

- symbol: Stock ticker (e.g., "AAPL", "GOOGL", "MSFT")
- expiration_date: YYYY-MM-DD (optional, fetches all if omitted)
- option_type: "calls", "puts", or "all" (default: "all")

**Returns for each expiration date**:

- contractSymbol: Option contract identifier
- strike: Strike price
- lastPrice: Last traded price
- bid/ask: Bid and ask prices
- volume: Trading volume
- openInterest: Open interest
- impliedVolatility: IV
- inTheMoney: Whether option is ITM
- contractSize: Contract size (REGULAR)
- currency: Currency (USD)

**Example**: `yfinance_get_option_chain(symbol="AAPL", expiration_date="2025-05-16", option_type="calls")`

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
