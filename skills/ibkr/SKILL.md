---
name: ibkr
description: Manage Interactive Brokers brokerage accounts — check balances, view positions, place trades, get real-time quotes, and manage alerts. Use this skill when the user asks about their portfolio, buying power, margin, or wants to execute orders, even if they don't name IBKR or Interactive Brokers directly.
compatibility: Requires IBKR MCP server connection. Client Portal Gateway (with JRE) is bundled — no separate install needed. Full IB Gateway provides broader API support.
allowed-tools: ibkr_*
---

# Interactive Brokers

Live trading account via IB Gateway. All tools operate against real accounts with real money. Authenticate with `ibkr_authenticate({ confirm: true })` — a browser window opens to `https://localhost:5000` for IB Gateway OAuth.

## Safety Rules

1. **Confirm before any transaction.** The agent must ask for explicit confirmation before placing, modifying, or canceling any order. Never auto-execute.
2. **Never suggest trades.** The agent provides data and executes user instructions — no advice, no recommendations.
3. **Treat all accounts as live.** The MCP connects to live IB Gateway sessions. Paper accounts must be explicitly set up in Gateway.

## Gotchas

- **Session contention** — IB Gateway allows one authenticated session. Logging into the Client Portal web UI or opening it separately will disconnect the MCP session, requiring re-authentication.
- **Auth expiry** — If market data or orders return auth errors, re-run `ibkr_authenticate` first.
- **Market data subscriptions required** — `ibkr_get_market_data` requires active market data subscriptions in IB Gateway. If it fails, verify subscriptions are active for the target exchange.
- **Trade currency vs base currency** — Position fields (`mktValue`, `avgCost`, `unrealizedPnl`) are in the trade's `currency`, not the account base currency. Account summary figures (`netliquidation`, `totalcashvalue`) are in base currency. Convert position values to base currency to assess total exposure.

## Workflows

### Portfolio Review

1. `ibkr_authenticate({ confirm: true })`
2. `ibkr_get_account_info({ confirm: true })` — review balances, margin, buying power
3. `ibkr_get_positions({ accountId: "U..." })` — current holdings with P&L

### Placing an Order

1. Confirm with the user: account ID, symbol, action (BUY/SELL), order type (MKT/LMT/STP), quantity, and price/stop price if applicable.
2. `ibkr_place_order({ accountId, symbol, action, orderType, quantity, price?, stopPrice? })`
3. `ibkr_get_live_orders()` or `ibkr_get_order_status({ orderId })` — verify execution
4. If the order requires additional confirmation, use `ibkr_confirm_order({ replyId, messageIds })`.

### Setting an Alert

1. `ibkr_create_alert({ accountId, alertRequest: { alertName, conditions } })`
2. `ibkr_activate_alert({ accountId, alertId })` if activation is not automatic

## Tools

### Account Info

`ibkr_get_account_info({ confirm: true })`

Key fields: `netliquidation` (total value), `totalcashvalue`, `availablefunds`, `buyingpower`, `excessliquidity`, `initmarginreq`, `maintmarginreq`, `grosspositionvalue`, `equitywithloanvalue`.

### Positions

`ibkr_get_positions({ accountId: "U..." })`

Returns: `contractDesc`, `position` (quantity), `mktPrice`, `mktValue`, `currency`, `avgCost`, `unrealizedPnl`, `realizedPnl`, `assetClass`.

### Market Data

`ibkr_get_market_data({ symbol: "AAPL", exchange?: "NASDAQ" })` — Real-time quote.

### Orders

`ibkr_get_live_orders({ accountId?: "U..." })` — All open/live orders.

`ibkr_get_order_status({ orderId: "12345" })` — Status of a specific order.

`ibkr_place_order({ accountId, symbol, action, orderType, quantity, price?, stopPrice? })` — Place a new order. Action: BUY/SELL. Order type: MKT/LMT/STP.

`ibkr_confirm_order({ replyId, messageIds })` — Confirm orders that require additional confirmation.

### Alerts

`ibkr_get_alerts({ accountId })` — List alerts for an account.

`ibkr_create_alert({ accountId, alertRequest: { alertName, conditions } })` — Create an alert. Conditions take `conidex`, `type` (price), `operator` (>, <, >=, <=, =), `triggerMethod` (last), `value`.

`ibkr_activate_alert({ accountId, alertId })` — Activate a previously created alert.

`ibkr_delete_alert({ accountId, alertId })` — Delete an alert.
