---
name: notion
description: Manage Notion workspaces — read, search, create, and update pages, databases, and content blocks. Use this skill when the user wants to find or edit information in Notion, even if they don't say Notion.
compatibility: Requires Notion MCP server connection.
allowed-tools: mcp__notion__*
---

# Notion

Direct access to your Notion workspace for reading, searching, and managing content.

## Gotchas

- **Two-step page read** — `get_page` returns metadata only (properties, title). To read actual content, follow up with `get_block_children` on the page's `id`. Missing this second step is the most common mistake.
- **Large pages need pagination** — `get_block_children` returns blocks in pages. Use `start_cursor` to walk through all blocks on long pages.
- **Database filters are property-specific** — the filter structure depends on the property type (text, select, date, number, etc.). Check the database schema with `get_database` first to see which properties are available and their types.
- **`update_page` changes properties, not content** — use `append_block_children` to add body content to a page. `update_page` only sets database properties or changes archive status.

## Search

```json
{ "query": "Project Roadmap" }
```

Use `search` to find pages or databases across the entire workspace. Returns page/database IDs needed for subsequent calls.

## Reading Content

1. `get_page({ "page_id": "<id>" })` — retrieve metadata
2. `get_block_children({ "block_id": "<id>" })` — list content blocks

If `get_block_children` returns `has_more: true`, pass `start_cursor` with the returned cursor to get the next chunk.

## Databases

1. `get_database({ "database_id": "<id>" })` — inspect schema and properties
2. `query_database({ "database_id": "<id>", "filter": {...}, "sorts": [...] })` — filtered/sorted rows

## Creating & Updating

- `create_page({ "parent": {"page_id"|"database_id": "<id>"}, "properties": {...} })` — new page in a parent or database
- `update_page({ "page_id": "<id>", "properties": {...} })` — change database properties or archive
- `append_block_children({ "block_id": "<id>", "children": [...] })` — add content blocks

## Authentication

Uses the official Notion MCP server with OAuth. Follow the login flow if prompted.
