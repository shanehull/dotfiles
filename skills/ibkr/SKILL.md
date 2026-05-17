---
name: ibkr
description: Manage Interactive Brokers brokerage accounts — check balances, view positions, place trades, get real-time quotes, and manage alerts. Use this skill when the user asks about their portfolio, buying power, margin, or wants to execute orders, even if they don't name IBKR or Interactive Brokers directly.
compatibility: Requires IBKR MCP server connection. Client Portal Gateway (with JRE) is bundled — no separate install needed. Full IB Gateway provides broader API support.
allowed-tools: ibkr_*
---

# Interactive Brokers

Live trading account via IB Gateway. All tools operate against real accounts with real money.

## Safety Rules

1. **Confirm before any transaction.** The agent must ask for explicit confirmation before placing, modifying, or canceling any order. Never auto-execute.
2. **Never suggest trades.** The agent provides data and executes user instructions — no advice, no recommendations.
3. **Treat all accounts as live.** The MCP connects to live IB Gateway sessions. Paper accounts must be explicitly set up in Gateway.
4. **Session contention.** IB Gateway allows one authenticated session. Logging into the Client Portal web UI will disconnect the MCP session, requiring re-authentication.

## Authentication

Run `ibkr_authenticate({ confirm: true })`. A browser window opens to `https://localhost:5000` for IB Gateway OAuth. Complete login there and the session is established. Do not open the IBKR Client Portal separately — it will replace the MCP's session.

If market data or orders return auth errors, re-run `ibkr_authenticate` first.

## Tools

### Account Info

`ibkr_get_account_info({ confirm: true })` — All accounts with balances, margin, and buying power.

Key fields per account summary: `netliquidation` (total value), `totalcashvalue`, `availablefunds`, `buyingpower`, `excessliquidity`, `initmarginreq`, `maintmarginreq`, `grosspositionvalue`, `equitywithloanvalue`.

### Positions

`ibkr_get_positions({ accountId: "U..." })` — Current holdings for a specific account.

Returns: `contractDesc`, `position` (quantity), `mktPrice`, `mktValue`, `currency`, `avgCost`, `unrealizedPnl`, `realizedPnl`, `assetClass`.

### Market Data

`ibkr_get_market_data({ symbol: "AAPL", exchange?: "NASDAQ" })` — Real-time quote for a symbol.

Requires market data subscriptions in IB Gateway. If it fails, verify data subscriptions are active for the exchange.

### Orders

`ibkr_get_live_orders({ accountId?: "U..." })` — All open/live orders. Use to verify execution after placing an order.

`ibkr_get_order_status({ orderId: "12345" })` — Status of a specific order.

`ibkr_place_order({ accountId, symbol, action, orderType, quantity, price?, stopPrice? })` — Place a new order.

**Before placing any order, the agent must confirm:**

- Account ID and symbol
- Action (BUY/SELL)
- Order type (MKT/LMT/STP)
- Quantity
- Price or stop price (if applicable)

`ibkr_confirm_order({ replyId, messageIds })` — Manually confirm orders that require additional confirmation.

### Alerts

`ibkr_get_alerts({ accountId })` — List trading alerts for an account.

`ibkr_create_alert({ accountId, alertRequest: { alertName, conditions } })` — Create a price or trigger alert.

Conditions: `conidex`, `type` (price), `operator` (>, <, >=, <=, =), `triggerMethod` (last), `value`.

`ibkr_activate_alert({ accountId, alertId })` — Activate a previously created alert.

`ibkr_delete_alert({ accountId, alertId })` — Delete an alert.

## Bundled vs Full IB Gateway

The MCP ships with **Client Portal Gateway** (a single JAR: `clientportal.gw`), not the full IB Gateway. Capabilities differ:

| Capability    | Bundled (Client Portal GW) | Full IB Gateway        |
| ------------- | -------------------------- | ---------------------- |
| Account info  | Works                      | Works                  |
| Positions     | Works                      | Works                  |
| Market data   | Works (contract info)      | Needs market data subs |
| Orders (read) | Works (fresh auth req)     | Works                  |
| Place order   | Works (confirms required)  | Untested               |
| Order confirm | Works                      | Untested               |
| Order status  | Works (fresh auth req)     | Untested               |
| Alerts        | Not supported (400 error)  | Works                  |

If an endpoint returns 400 or "Failed to retrieve," it may require the full IB Gateway. The full Gateway also handles session management differently — market data and orders endpoints are more reliable.

Known bundled Gateway limitations:

- **Short-lived sessions.** Auth degrades after a few calls. Re-authenticate if endpoints return auth errors.
- **Exchange routing.** The bundled config may default orders to USD/VALUE exchange. Non-USD stocks (ASX, TSX, etc.) return "No trading permissions" even on accounts with valid permissions. Full IB Gateway handles multi-exchange routing correctly.
- **Auth quality matters.** "Client login succeeds" produces a functional session. "Browser opened" may produce a degraded one with more endpoint failures.

## Multi-Currency Notes

IBKR accounts hold positions in multiple currencies. `mktValue`, `avgCost`, and `unrealizedPnl` are in `currency` (not account base currency). To assess total exposure, convert each position's value to the account's base currency.

Account summary figures (`netliquidation`, `totalcashvalue`, etc.) are already in the account's base currency.
