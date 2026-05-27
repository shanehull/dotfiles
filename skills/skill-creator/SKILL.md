---
name: skill-creator
description: Create and refine agent skills following best practices. Use this skill when the user wants to create a new skill, scaffold a skill directory, improve an existing skill's description, or apply skill-creation conventions (structure, frontmatter, description patterns, gotchas formatting), even if they don't say "skill" or "skill-creator" explicitly.
---

# Skill Creator

Create and refine agent skills following the conventions of this environment.

## Directory structure

```
skills/<name>/
├── SKILL.md          # skill definition
├── scripts/          # bash scripts invoked by the agent
├── references/       # optional docs loaded on demand
└── assets/           # optional templates, schemas
```

Create via `mkdir -p skills/<name>/scripts`.

## SKILL.md format

### Frontmatter (YAML, required)

```yaml
---
name: my-skill # lowercase, hyphens, must match directory name
description: What the skill does and when to use it. Use imperative phrasing: "Use this skill when..." not "This skill does..." Include cases where the user doesn't name the domain directly: "even if they don't explicitly mention X." # imperative, user-intent focused, under 1024 chars
compatibility: Requires git, docker, jq, and access to the internet. # optional. Only when environment requirements matter: intended product, system packages, network access.
allowed-tools: bash # or tool pattern like fred_*
---
```

### Body sections

The spec imposes no section order. Start with a title and a short intro (2-3 lines). A `## Gotchas` section is recommended — it's often the highest-value content in a skill.

## Script conventions

Scripts live in `scripts/` relative to `SKILL.md`. Invoked by relative path (`scripts/search`).

- **No interactive prompts** — Agents cannot respond to TTY prompts. Accept all input via flags, env vars, or stdin.
- **Structured output** — Emit JSON to stdout, diagnostics to stderr. Agents parse structured output more reliably than free text.
- **Helpful errors** — Say what went wrong, what was expected, what to try next. Provide `--help` with examples.
- **Safe by default** — Support `--dry-run` for destructive operations. Prefer idempotent operations (create-if-not-exists over create).
- **Predictable output size** — Agents truncate output beyond ~10-30K chars. Default to summaries; support `--offset` or `--output` for large results.
- **Meaningful exit codes** — Use distinct codes for different failure types. Document them in `--help`.
- **Pure bash + curl** — zero external dependencies. Output raw data (JSON, CSV) as-is. Agent pipes to `jq` itself.
- **`#!/usr/bin/env bash`** + **`set -euo pipefail`** — standard preamble.
- **`usage()`** / **`die()`** / **`main()`** — standard entry point pattern. Called at bottom: `main "$@"`.
- **Long options** — `--key value` and `--key=value` forms.

## Description writing

The description is the **only** field the agent sees before deciding whether to load the skill. It carries the entire triggering burden.

### Principles

- **Imperative phrasing** — "Use this skill when..." not "This skill does..."
- **User intent, not implementation** — describe what the user wants to achieve.
- **Err on the side of pushy** — list contexts explicitly, including cases where the user doesn't name the domain.
- **Concise** — 2-4 sentences. Hard limit of 1024 characters.

### Before and after

```yaml
# Before — too vague
description: Process CSV files.

# After — specific about what and when
description: Analyze CSV and tabular data files — compute summary statistics, add derived columns, generate charts, and clean messy data. Use this skill when the user has a CSV, TSV, or Excel file and wants to explore, transform, or visualize the data, even if they don't explicitly mention "CSV" or "analysis."
```

## Gotchas section guidelines

The highest-value content. Each item should be a concrete fact that defies reasonable assumptions — not general advice.

```markdown
## Gotchas

- **Naming mismatch** — The user ID is `user_id` in the database, `uid` in the auth service, and `accountId` in the billing API.
- **Non-obvious default** — CSV output uses long human-readable column names. Use `--short-names` for machine-readable headers.
- **Fiscal year mismatch** — Company filings are in fiscal, not calendar year. Microsoft's FY2025 ends June 2025. Calendar year queries may span two fiscal periods.
- **Currency varies by filing** — Non-US companies may report in local currency (`CNY`, `JPY`) even when the stock trades in USD. Check the `currency` field before comparing metrics across companies.
```

When an agent makes a mistake you have to correct, add the correction to gotchas.

## Keep it evergreen

Skills are read months later. Generalise patterns; skip details tied to now — timestamps, in-flight tickets, current headcount, patch versions. If a fact would need quarterly edits to stay true, link to a live source instead of embedding it.

## Keep it portable

Skills may run on other machines and other users. Use `$HOME`, `~`, or paths relative to `SKILL.md` — never hard-coded home directories or usernames.

## Calibrating control

Match instruction specificity to task fragility:

- **Be prescriptive** for fragile operations, specific sequences, or where consistency matters. Give exact commands.
- **Give freedom** when multiple approaches are valid. Explain _why_ rather than prescribing exact steps.
- **Provide defaults, not menus** — pick one approach as default, mention alternatives briefly as fallbacks.

## Progressive disclosure

For larger reference material:

- **`references/`** — docs loaded on demand. Tell the agent _when_ to load each file: "Read `references/api-errors.md` if the API returns a non-200 status code."
- **`assets/`** — output templates, schemas, or config files.

## Refinement workflow

1. **Create directory structure** — `mkdir -p skills/<name>/scripts`
2. **Write** scripts and SKILL.md body
3. **Test** the skill against real tasks
4. **Extract gotchas** from any corrections made during testing
5. **Verify** the description triggers on relevant prompts, doesn't trigger on near-misses
6. **Iterate** — feed execution traces back into the SKILL.md

Add corrections to gotchas immediately. This is the most direct way to improve a skill.
