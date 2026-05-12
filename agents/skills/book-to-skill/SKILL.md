---
name: book-to-skill
description: Convert an ebook into an agent skill — locate the file on disk, extract its core framework or mental model, and write it as a loadable skill at ~/.config/agents/skills/<name>/SKILL.md. Use this when you need to encode domain knowledge from a book into the agent's toolchain.
compatibility: Requires a text extraction tool (pandoc, pdftotext, or similar).
---

# Book → Skill

## 1. Find the file

Ask the user where the ebook is stored. Common locations:

```
find ~ -name "*.epub" -o -name "*.pdf" 2>/dev/null
```

If the user mentions Apple Books, check:

```
ls ~/Library/Containers/com.apple.iBooksX/Data/Documents/
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

If neither is installed, check what is:

```
which pandoc pdftotext ebook-convert
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

You don't need every detail — just the framework the agent needs to reason in that domain. Skip introductions, stories, acknowledgments.

## 4. Write the skill

**Location:** `~/.config/agents/skills/<name>/SKILL.md`

Frontmatter:

```yaml
---
name: <hyphenated-name>
description: Action-verb opener describing what the skill does, its domain, and when the agent should use it.
compatibility: Optional. Only if the skill needs specific system packages, environment setup, or external services to function. Not for tools — the agent already knows its tools.
---
```

Write the body as a concise reference — the agent will read this at load time. Use:

- **Bold** for rules and principles
- Tables for structured comparisons or thresholds
- Bullet lists for criteria and checklists
- Code blocks for formulas
- `---` section breaks for major divisions

Structure:

```
# Framework Name

Framework from *Title* by Author.

## Core Concept

One paragraph: the central idea. What does this framework do?

## [Major Section]

[Key concepts, rules, and principles extracted from the book.]

## Quick-Reference

[Compact summary — what the agent checks first.]
```

Do not add content that isn't in the book. Represent the author's framework faithfully.
