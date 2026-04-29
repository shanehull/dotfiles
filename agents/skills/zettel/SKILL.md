---
name: zettel
description: Create and manage Zettelkasten notes in your secondbrain inbox. Use when you need to capture a new idea or document a project.
compatibility: Requires either local write access to $SECOND_BRAIN/0-inbox/ or the obsidian-remote MCP server.
allowed-tools: mcp__obsidian-remote__update_note, mcp__obsidian-remote__append_note, mcp__obsidian-remote__list_notes
---

# Zettelkasten Workflow

This skill provides a structured way to create new Zettelkasten notes directly in your inbox at `0-inbox/`.

## Writing a New Zettel

When asked to create a new note, follow this structure strictly:

1.  **Metadata (Front Matter):**
    - `id`: A hyphenated, lowercase version of the note title (e.g., `my-new-idea`).
    - `aliases`: An empty array `[]` unless aliases are provided.
    - `tags`: An array of tag names **WITHOUT** the `#` prefix (e.g., `[idea, research]`). Tags must be thoughtful and capture any practical or philosophical concepts; they are used to form a knowledge graph.
    - `date`: Current date in `YYYY-MM-DD` format.

2.  **Markdown Structure:**

    ```markdown
    ---
    id: my-new-idea
    aliases: []
    tags:
      - tag1
      - tag2
    date: 2026-03-05
    ---

    # Note Title

    [Content]
    ```

3.  **Content Handling:**
    - **Preservation:** If the user provides text to be saved, preserve the original language and structure exactly. Do not rewrite, summarize, or "improve" the text unless explicitly requested to "refactor" or "clean up".
    - **Generation:** If the user asks you to "write" or "flesh out" a thought, you may generate the content. Maintain a professional, technical tone and avoid generic AI conversational patterns. Never use bold-beginning bullet points (e.g., `- **Title:** Description`); prefer plain lists or well-structured headers.

4.  **Filename:** The filename MUST be the note's title, converted to lowercase and hyphenated (e.g., "My New Idea" becomes `my-new-idea.md`).

5.  **Storage:** Always save to the `0-inbox/` directory. NEVER write to `inbox/`, `Inbox/`, or any other variation. The correct MCP path is `0-inbox/<filename>.md`. If unsure, call `list_notes` first to verify the directory structure.

## Tools

Before writing, check whether `$SECOND_BRAIN/0-inbox/` exists on the local filesystem.

- **Local vault exists** (`$SECOND_BRAIN/0-inbox/` is a directory): Use the native `create_file` (or `write_file`) tool to create the note at `$SECOND_BRAIN/0-inbox/<filename>.md`. Always resolve the absolute path using the `$SECOND_BRAIN` environment variable, never use the skill's base directory.
- **No local vault** (directory does not exist): Use the `obsidian-remote` MCP tool `update_note` with `path` set to `0-inbox/<filename>.md` and `content` set to the full note content (front matter + body). The path MUST start with `0-inbox/` — never use bare `inbox/` or any other directory. To add content to an existing note, use `append_note` instead.

For searching existing notes:

- **Local vault exists**: Use `qmd` (supports semantic and keyword search across the full vault).
- **No local vault**: Use the `obsidian-remote` MCP tool `list_notes`.
