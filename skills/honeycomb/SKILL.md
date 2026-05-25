---
name: read-honeycomb-opentelemetry
description: "Query Honeycomb for SLO compliance, error budgets, burn alerts, and OpenTelemetry traces. Use when asked about SLO status, service health, error budgets, latency, or Honeycomb data."
allowed-tools: mcp__honeycomb__get_slos, mcp__honeycomb__get_triggers, mcp__honeycomb__run_query, mcp__honeycomb__run_bubbleup, mcp__honeycomb__get_trace, mcp__honeycomb__find_columns, mcp__honeycomb__get_workspace_context, mcp__honeycomb__get_environment, mcp__honeycomb__get_dataset
---

# Read Honeycomb OpenTelemetry

READ-ONLY observability skill. Query SLO status, error budgets, burn alerts, and traces.

📖 **Full guide:** [Remote's SLOs framework (Notion)](https://www.notion.so/remotecom/Draft-Remote-s-SLOs-framework-30dcb4dadab480f990aae1c6c523be76)

## Setup

If no Honeycomb MCP is configured:

```bash
claude mcp add honeycomb --transport http https://mcp.eu1.honeycomb.io/mcp
```

Only READ access is needed during OAuth setup.

## Bootstrap

Always start by discovering what's available:

1. `get_workspace_context` → list environments and datasets.
2. `get_environment` → confirm the target environment (typically `production`).
3. `get_dataset` → confirm the target dataset.

Skip 2–3 if the user specifies environment and dataset explicitly.

## SLO Status

Use `get_slos` with `environment_slug` to list all SLOs.

**Triage pattern:**

1. List all SLOs → identify any with compliance below target or triggered status.
2. For triggered SLOs, note remaining error budget and burn rate.
3. Use `run_query` to investigate contributing errors or latency.

## Burn Alerts

Use `get_triggers` with `environment_slug` to list burn alert triggers and current state.

- Check which triggers are currently firing — these indicate active budget burn.
- Cross-reference fired triggers with SLO names to understand which SLOs are affected.

## Diagnostic Queries

Use `run_query` with `environment_slug` and `dataset_slug`.

**Error rates:** `COUNT` where `error = true` or `status_code >= 500`, broken down by `service.name` or endpoint. Use `RATE_AVG` or `COUNT` with error filter vs total for error percentage.

**Latency:** `HEATMAP(duration_ms)` or `P99(duration_ms)` / `P95(duration_ms)` / `P50(duration_ms)`. Break down by endpoint or operation.

**Availability:** Total requests vs error requests over a time window.

**Time windowing:** For incidents, narrow to the incident window first, then expand if needed.

## BubbleUp Analysis

Use `run_bubbleup` to identify what makes a problematic subset different from the baseline.

**When to use:** SLO breaching, post-deploy comparison, latency spikes.

**Pattern:**

1. Define baseline (e.g., all requests in the last hour).
2. Define selection (e.g., requests where `duration_ms > P99` or `error = true`).
3. BubbleUp surfaces disproportionate attributes (region, endpoint, deploy SHA).

## Trace Investigation

MCP responses include URLs (`trace_link` from `get_trace`, `Query Url` from `run_query`). Always prefer those over manually constructing URLs.

## Known Gotchas

**15-second frontend timeout:** Dragon cuts requests at 15s. Traces for long requests may appear incomplete, child spans disconnect from the parent. Gaps in span hierarchy on 15s+ traces are likely timeout-related, not missing instrumentation.

## Constraints

- **Read-only.** Do not create, modify, or delete SLOs, triggers, or datasets.
- **Always share Honeycomb URLs** from query results and trace lookups in your response.
- **Defaults.** Use `production` environment unless told otherwise. Discover the dataset via bootstrap.
