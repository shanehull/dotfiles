---
name: zettel
description: Create and manage Zettelkasten notes in your secondbrain inbox. Use when you need to capture a new idea or document a project.
compatibility: Requires write access to $SECOND_BRAIN/0-inbox/
---

# Zettelkasten Workflow

This skill provides a structured way to create new Zettelkasten notes directly in your inbox at `$SECOND_BRAIN/0-inbox/`.

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
    date: "2026-03-05"
    ---

    # Note Title

    [Content]
    ```

3.  **Content Handling:**
    - **Preservation:** If the user provides text to be saved, preserve the original language and structure exactly. Do not rewrite, summarize, or "improve" the text unless explicitly requested to "refactor" or "clean up".
    - **Generation:** If the user asks you to "write" or "flesh out" a thought, you may generate the content. Maintain a professional, technical tone and avoid generic AI conversational patterns. Never use bold-beginning bullet points (e.g., `- **Title:** Description`); prefer plain lists or well-structured headers.

4.  **Filename:** The filename MUST be the note's title, converted to lowercase and hyphenated (e.g., "My New Idea" becomes `my-new-idea.md`).

5.  **Storage:** Always save to `$SECOND_BRAIN/0-inbox/`.

## Tools

Use the native `write_file` tool to create the note. Note that you only have write access to the inbox; use `qmd` for searching existing notes across the entire vault.
