---
name: notion
description: Access, search, and manage Notion pages and databases. Use when the user asks to read content from Notion, update notes, or query Notion databases.
compatibility: Requires Notion MCP server connection.
allowed-tools: mcp__notion__*
---

# Notion

Direct access to your Notion workspace for reading, searching, and managing content.

## Search

Use `search` to find pages or databases across the entire workspace.

```json
{ "query": "Project Roadmap" }
```

## Reading Content

To read a page, you typically need to:

1. `get_page`: Retrieve metadata and ensure the page exists.
2. `get_block_children`: List the blocks within the page to read the actual content.

```json
{ "block_id": "page-id-here" }
```

Note: Large pages may require paginating through blocks.

## Databases

- `get_database`: Check the schema and properties.
- `query_database`: Search for specific entries using filters or sorts.

## Creating & Updating

- `create_page`: Add new pages to a parent page or database.
- `update_page`: Change properties or archive status.
- `append_block_children`: Add content (text, lists, etc.) to an existing page or block.

## Authentication

This skill uses the official Notion MCP server which requires OAuth authentication. If prompted, follow the login flow to grant access to your workspace.
