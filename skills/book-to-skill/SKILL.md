---
name: book-to-skill
description: Convert an ebook into an agent skill — locate the file on disk, extract its core framework or mental model, and write it as a loadable skill at ~/.config/skills/<name>/SKILL.md. Use this when encoding domain knowledge from a book into a skill, even if the user just says "turn this book into a skill" or "extract the framework from this book."
compatibility: Requires a text extraction tool (pandoc, pdftotext, or similar).
---

# Book → Skill

## 1. Find the file

Check these locations in order:

**Calibre Library** (most common for organised collections):

```
ls "$HOME/Calibre Library/"
```

Books are stored as `$HOME/Calibre Library/<Author Name>/<Title> (<id>)/<Title> - <Author Name>.epub`. Search by author or title:

```
find "$HOME/Calibre Library" -iname "*search-term*" 2>/dev/null
```

**Apple Books (iBooks):**

The database is at `BKLibrary/BKLibrary-1-091020131601.sqlite` inside the Apple Books container. Query by title or author:

```
sqlite3 ~/Library/Containers/com.apple.iBooksX/Data/Documents/BKLibrary/BKLibrary-1-091020131601.sqlite \
  "SELECT ZTITLE, ZAUTHOR, ZPATH FROM ZBKLIBRARYASSET WHERE ZTITLE LIKE '%search-term%';"
```

Epub files are stored as UUID-named files in:

```
ls ~/Library/Containers/com.apple.iBooksX/Data/Documents/iBooks/Books/*.epub
```

The `ZPATH` column in the database gives the full path to the epub file (typically under `BKAgentService/Data/Documents/iBooks/Books/`).

**Generic search** (slow, use as fallback):

```
find ~ -name "*.epub" -o -name "*.pdf" 2>/dev/null
```

## 2. Convert to text

Prefer `pandoc` if available:

```
pandoc /path/to/book.epub -t plain --wrap=preserve -o /tmp/book-text.txt
```

Otherwise try `pdftotext` (from poppler) for PDFs:

```
pdftotext /path/to/book.pdf /tmp/book-text.txt
```

Fallback: ask the user to install pandoc (`brew install pandoc` or `apt install pandoc`).

## 3. Extract the framework

Get the table of contents first:

```
grep -n "CHAPTER \|Chapter \|Part \|Section \|^# " /tmp/book-text.txt | head -40
```

Read key chapters in batches (~300-500 lines at a time). Extract selectively:

- Core concepts, frameworks, taxonomies — how the book organises its domain
- Rules, principles, heuristics — actionable decision criteria
- Specific thresholds, formulas, or classifications stated by the author
- Step-by-step methodologies or workflows
- Quotes that encapsulate the key idea

Skip introductions, stories, acknowledgments. Extract only what the agent needs to reason in that domain.

### Handling images and diagrams

If the framework or worksheet is in images (e.g. scanned forms, diagrams), check whether the epub has image files:

```
unzip -l /path/to/book.epub | grep -i "jpg\|png\|svg"
```

Use tesseract OCR on images:

```
cd /tmp && tesseract extracted-image.jpg output-prefix && cat output-prefix.txt
```

Some epub images use paths like `ops/images/<name>.jpg`. Unzip to the correct directory first:

```
unzip -o /path/to/book.epub "ops/images/*" -d /tmp/book-images/
```

## 4. Write the skill

**Location:** `~/.config/skills/<name>/SKILL.md`

Follow the agentskills.io specification and skill-creator conventions for frontmatter and structure. The `name` must use lowercase and hyphens and match the directory name.

Frontmatter (minimal required):

```yaml
---
name: <hyphenated-name>
description: <single line. Imperative, 1-1024 chars. "Use this skill when..." phrasing. Include contexts where the user doesn't name the domain directly.>
compatibility: Requires git, jq. # optional. Execution-environment requirements only (system packages), not user data needs.
allowed-tools: bash # optional. Pre-approve tools the environment always has. Never list domain MCP tools that may not exist.
---
```

Keep the body concise — the agent loads this on activation. Use:

- **Bold** for rules and principles
- Tables for structured comparisons or thresholds
- Bullet lists for criteria and checklists
- Code blocks for formulas or commands
- `---` section breaks for major divisions

### Naming

Use concept-based names, not book titles or chapter names. The skill must stand alone.

- Skill `name`: the methodology, not the book title. `magic-formula-investing`, not `little-book-value`.
- Section headings: generic concepts, not "Chapter 4: Where to Find the Numbers."
- Credit the book in the opening paragraph only.

### Structure

```
# Framework Name

Framework from *Title* by Author.

## Core Concept

One paragraph: the central idea.

## [Major Section]

Key concepts, rules, and principles extracted from the book.

## Gotchas

Non-obvious pitfalls, environment-specific facts, or edge cases.

## Quick-Reference

Compact summary — what the agent checks first.
```

Do not add content that isn't in the book. Represent the author's framework faithfully. Include gotchas you discovered during extraction (OCR quirks, Calibre path conventions, etc.).

## Gotchas

- **Calibre path**: Calibre stores books at `$HOME/Calibre Library/<Author Name>/<Title> (<numeric-id>)/<Title> - <Author Name>.epub`. The numeric ID in parentheses after the title is the Calibre internal ID.
- **Apple Books database**: The actual SQLite file is `BKLibrary/BKLibrary-1-091020131601.sqlite` inside the container. The `BKLibrary/` directory itself is not a database file.
- **Epub images**: Some books use `ops/` as a prefix in their zip paths. Always check the full archive path with `unzip -l`.
- **OCR quality**: Tesseract on scanned form images may produce garbled output. Run it from `/tmp/` (not from subdirectories) to avoid path issues with Leptonica.
- **Description optimisation**: The skill's `description` field is the only thing that triggers the skill. Write it with imperative phrasing ("Use this when..."), focus on user intent, and list contexts where it applies "even if the user doesn't mention [domain] explicitly."
