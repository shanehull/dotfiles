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


| Metric | Formula |
|--------|---------|
| P/B | `priceToBook` or `currentPrice / bookValue` |
| P/TB | `currentPrice / (tangibleBookValue / sharesOutstanding)` |
| Dividend Yield | `dividendYield` |
| FCF Yield | `freeCashflow / marketCap` |
| EV/EBITDA | `enterpriseValue / ebitda` |
| EV/FCF | `enterpriseValue / freeCashflow` |
| Earnings Yield | `1 / trailingPE` |
| Net Debt | `totalDebt - totalCash` |
| Debt/Equity | `debtToEquity` |
| ROIC | `(EBIT × (1 - Tax Rate)) / Invested Capital` where Tax Rate = `Tax Provision / Pretax Income` |

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

**Requires**: `tabulate` Python package. Returns only OHLCV data (no fundamentals).

### Get Ticker News

`yfinance_get_ticker_news` - Recent news and press releases for a stock.

**Example**: `yfinance_get_ticker_news(symbol="TSLA")`

### Search

`yfinance_search` - Find ticker symbols by company name or keywords.

- search_type: "all", "quotes", or "news"

**Example**: `yfinance_search(query="Nvidia", search_type="quotes")`

### Get Top (Sector Data)

`yfinance_get_top` - Top-ranked entities within a sector:

- top_etfs: Popular ETFs for a sector
- top_mutual_funds: Popular mutual funds
- top_companies: Largest by market cap
- top_growth_companies: Fastest revenue/earnings growth
- top_performing_companies: Best stock price performance

**Example**: `yfinance_get_top(sector="Technology", top_type="top_companies", top_n=10)`

Valid sectors: Basic Materials, Communication Services, Consumer Cyclical, Consumer Defensive, Energy, Financial Services, Healthcare, Industrials, Real Estate, Technology, Utilities

See `references/ticker-suffixes.md` for complete ticker suffix reference by exchange.
