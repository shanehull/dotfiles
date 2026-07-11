# Equity Screener Fields

Filter and sort fields for `yfinance_screen(query_type="equity")`. Source: `yfinance/const.py` → `EQUITY_SCREENER_FIELDS`.

## eq_fields

| Field        | Description                                                                                     |
| ------------ | ----------------------------------------------------------------------------------------------- |
| `region`     | Country code: `"us"`, `"no"`, `"gb"`, etc.                                                      |
| `sector`     | Sector: `"Energy"`, `"Industrials"`, etc. Must be set before filtering by `industry`.           |
| `peer_group` | Peer group name                                                                                 |
| `industry`   | Industry: `"Oil & Gas Drilling"`, `"Marine Shipping"`, etc. Requires `sector` filter alongside. |

## price

| Field                                  | Description                    |
| -------------------------------------- | ------------------------------ |
| `lastclosemarketcap.lasttwelvemonths`  | Market cap at last close (TTM) |
| `percentchange`                        | Daily % change                 |
| `lastclose52weekhigh.lasttwelvemonths` | 52-week high at last close     |
| `fiftytwowkpercentchange`              | 52-week % change               |
| `lastclose52weeklow.lasttwelvemonths`  | 52-week low at last close      |
| `intradaymarketcap`                    | Intraday market cap            |
| `eodprice`                             | End-of-day price               |
| `intradaypricechange`                  | Intraday price change          |
| `intradayprice`                        | Intraday price                 |

## trading

| Field            | Description              |
| ---------------- | ------------------------ |
| `beta`           | Beta                     |
| `avgdailyvol3m`  | 3-month avg daily volume |
| `pctheldinsider` | % held by insiders       |
| `pctheldinst`    | % held by institutions   |
| `dayvolume`      | Daily volume             |
| `eodvolume`      | End-of-day volume        |

## short_interest

| Field                                          | Description                   |
| ---------------------------------------------- | ----------------------------- |
| `short_percentage_of_shares_outstanding.value` | Short % of shares outstanding |
| `short_interest.value`                         | Short interest                |
| `short_percentage_of_float.value`              | Short % of float              |
| `days_to_cover_short.value`                    | Days to cover short           |
| `short_interest_percentage_change.value`       | Short interest % change       |

## valuation

| Field                                              | Description           |
| -------------------------------------------------- | --------------------- |
| `bookvalueshare.lasttwelvemonths`                  | Book value per share  |
| `lastclosemarketcaptotalrevenue.lasttwelvemonths`  | Market cap / revenue  |
| `lastclosetevtotalrevenue.lasttwelvemonths`        | EV / revenue          |
| `pricebookratio.quarterly`                         | P/B (quarterly)       |
| `peratio.lasttwelvemonths`                         | Trailing P/E          |
| `lastclosepricetangiblebookvalue.lasttwelvemonths` | Price / tangible book |
| `lastclosepriceearnings.lasttwelvemonths`          | Price / earnings      |
| `pegratio_5y`                                      | PEG ratio (5-year)    |

## profitability

| Field                                        | Description                          |
| -------------------------------------------- | ------------------------------------ |
| `dividendyield`                              | Trailing dividend yield              |
| `dividendpershare.lasttwelvemonths`          | Dividend per share (TTM)             |
| `consecutive_years_of_dividend_growth_count` | Years of consecutive dividend growth |
| `returnonassets.lasttwelvemonths`            | ROA (TTM)                            |
| `returnonequity.lasttwelvemonths`            | ROE (TTM)                            |
| `forward_dividend_per_share`                 | Forward dividend per share           |
| `forward_dividend_yield`                     | Forward dividend yield               |
| `returnontotalcapital.lasttwelvemonths`      | ROIC (TTM)                           |

## leverage

| Field                                    | Description               |
| ---------------------------------------- | ------------------------- |
| `lastclosetevebit.lasttwelvemonths`      | EV / EBIT                 |
| `netdebtebitda.lasttwelvemonths`         | Net debt / EBITDA         |
| `totaldebtequity.lasttwelvemonths`       | Total debt / equity       |
| `ltdebtequity.lasttwelvemonths`          | Long-term debt / equity   |
| `ebitinterestexpense.lasttwelvemonths`   | EBIT / interest expense   |
| `ebitdainterestexpense.lasttwelvemonths` | EBITDA / interest expense |
| `lastclosetevebitda.lasttwelvemonths`    | EV / EBITDA               |
| `totaldebtebitda.lasttwelvemonths`       | Total debt / EBITDA       |

## liquidity

| Field                                                                    | Description                        |
| ------------------------------------------------------------------------ | ---------------------------------- |
| `quickratio.lasttwelvemonths`                                            | Quick ratio                        |
| `altmanzscoreusingtheaveragestockinformationforaperiod.lasttwelvemonths` | Altman Z-score                     |
| `currentratio.lasttwelvemonths`                                          | Current ratio                      |
| `operatingcashflowtocurrentliabilities.lasttwelvemonths`                 | Operating CF / current liabilities |

## income_statement

| Field                                             | Description                |
| ------------------------------------------------- | -------------------------- |
| `totalrevenues.lasttwelvemonths`                  | Revenue (TTM)              |
| `netincomemargin.lasttwelvemonths`                | Net income margin          |
| `grossprofit.lasttwelvemonths`                    | Gross profit               |
| `ebitda1yrgrowth.lasttwelvemonths`                | EBITDA 1-year growth       |
| `dilutedepscontinuingoperations.lasttwelvemonths` | Diluted EPS continuing ops |
| `quarterlyrevenuegrowth.quarterly`                | Quarterly revenue growth   |
| `epsgrowth.lasttwelvemonths`                      | EPS growth                 |
| `netincomeis.lasttwelvemonths`                    | Net income                 |
| `ebitda.lasttwelvemonths`                         | EBITDA                     |
| `dilutedeps1yrgrowth.lasttwelvemonths`            | Diluted EPS 1-year growth  |
| `totalrevenues1yrgrowth.lasttwelvemonths`         | Revenue 1-year growth      |
| `operatingincome.lasttwelvemonths`                | Operating income           |
| `netincome1yrgrowth.lasttwelvemonths`             | Net income 1-year growth   |
| `grossprofitmargin.lasttwelvemonths`              | Gross margin               |
| `ebitdamargin.lasttwelvemonths`                   | EBITDA margin              |
| `ebit.lasttwelvemonths`                           | EBIT                       |
| `basicepscontinuingoperations.lasttwelvemonths`   | Basic EPS continuing ops   |
| `netepsbasic.lasttwelvemonths`                    | Net basic EPS              |
| `netepsdiluted.lasttwelvemonths`                  | Net diluted EPS            |

## balance_sheet

| Field                                               | Description                   |
| --------------------------------------------------- | ----------------------------- |
| `totalassets.lasttwelvemonths`                      | Total assets                  |
| `totalcommonsharesoutstanding.lasttwelvemonths`     | Common shares outstanding     |
| `totaldebt.lasttwelvemonths`                        | Total debt                    |
| `totalequity.lasttwelvemonths`                      | Total equity                  |
| `totalcurrentassets.lasttwelvemonths`               | Current assets                |
| `totalcashandshortterminvestments.lasttwelvemonths` | Cash + short-term investments |
| `totalcommonequity.lasttwelvemonths`                | Common equity                 |
| `totalcurrentliabilities.lasttwelvemonths`          | Current liabilities           |
| `totalsharesoutstanding`                            | Shares outstanding            |

## cash_flow

| Field                                           | Description                 |
| ----------------------------------------------- | --------------------------- |
| `forward_dividend_yield`                        | Forward dividend yield      |
| `leveredfreecashflow.lasttwelvemonths`          | Levered free cash flow      |
| `capitalexpenditure.lasttwelvemonths`           | Capital expenditure         |
| `cashfromoperations.lasttwelvemonths`           | Cash from operations        |
| `leveredfreecashflow1yrgrowth.lasttwelvemonths` | Levered FCF 1-year growth   |
| `unleveredfreecashflow.lasttwelvemonths`        | Unlevered free cash flow    |
| `cashfromoperations1yrgrowth.lasttwelvemonths`  | Cash from ops 1-year growth |

## esg

| Field                 | Description               |
| --------------------- | ------------------------- |
| `esg_score`           | ESG score                 |
| `environmental_score` | Environmental score       |
| `governance_score`    | Governance score          |
| `social_score`        | Social score              |
| `highest_controversy` | Highest controversy level |

## Sector/Industry EQ Values

Valid values for `sector` (EQ/IS-IN operator):

Basic Materials, Communication Services, Consumer Cyclical, Consumer Defensive, Energy, Financial Services, Healthcare, Industrials, Real Estate, Technology, Utilities

Valid values for `industry` (all per `SECTOR_INDUSTRY_MAPPING` in `yfinance/const.py`):

- **Energy**: Oil & Gas Drilling, Oil & Gas E&P, Oil & Gas Equipment & Services, Oil & Gas Integrated, Oil & Gas Midstream, Oil & Gas Refining & Marketing, Thermal Coal, Uranium
- **Industrials**: Aerospace & Defense, Airlines, Airports & Air Services, Building Products & Equipment, Business Equipment & Supplies, Conglomerates, Consulting Services, Electrical Equipment & Parts, Engineering & Construction, Farm & Heavy Construction Machinery, Industrial Distribution, Infrastructure Operations, Integrated Freight & Logistics, Marine Shipping, Metal Fabrication, Pollution & Treatment Controls, Railroads, Rental & Leasing Services, Security & Protection Services, Specialty Business Services, Specialty Industrial Machinery, Staffing & Employment Services, Tools & Accessories, Trucking, Waste Management
- Remaining sectors in `SECTOR_INDUSTRY_MAPPING` in source.

Valid values for `exchange` (EQ/IS-IN): exchange codes per region, e.g. `"OSL"` (Norway), `"NMS"` (NasdaqGS), `"NYQ"` (NYSE), `"NGM"` (NasdaqGM). Full list in `EQUITY_SCREENER_EQ_MAP`.

Valid values for `region` (EQ): `ae`, `ar`, `at`, `au`, `be`, `br`, `ca`, `ch`, `cl`, `cn`, `co`, `cz`, `de`, `dk`, `ee`, `eg`, `es`, `fi`, `fr`, `gb`, `gr`, `hk`, `hu`, `id`, `ie`, `il`, `in`, `is`, `it`, `jp`, `kr`, `kw`, `lk`, `lt`, `lv`, `mx`, `my`, `nl`, `no`, `nz`, `pe`, `ph`, `pk`, `pl`, `pt`, `qa`, `ro`, `ru`, `sa`, `se`, `sg`, `sr`, `th`, `tr`, `tw`, `us`, `ve`, `vn`, `za`
