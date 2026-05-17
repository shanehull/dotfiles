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
description: >- # imperative, user-intent focused, under 1024 chars
  What the skill does and when to use it. Use imperative phrasing:
  "Use this skill when..." not "This skill does..." Include cases
  where the user doesn't name the domain directly: "even if they
  don't explicitly mention X."
compatibility: >- # required when skill has scripts.
  Requires bash and curl. Scripts are bash — invoke directly
  (e.g. `scripts/foo`), not with python.
allowed-tools: bash # or tool pattern like fred_*
---
```

### Body sections (convention order)

| Section        | Purpose                                                      |
| -------------- | ------------------------------------------------------------ |
| `# Title`      | Brief one-liner of what the skill enables                    |
| Intro          | 2-3 lines expanding on scope. Reference scripts by path.     |
| `## Gotchas`   | Environment-specific facts the agent would get wrong.        |
| `## Scripts`   | Each script's usage, options table, examples.                |
| `## Workflows` | Common task sequences with concrete commands.                |
| `## Reference` | API endpoints, field tables, IDs. Keep in SKILL.md if small. |

## Script conventions

Scripts live in `scripts/` relative to `SKILL.md`. The agent invokes them by path (`scripts/owid-search`).

- **Pure bash + curl** — zero external dependencies beyond `jq` (optional for pretty-print).
- **`#!/usr/bin/env bash`** — shebang line.
- **`set -euo pipefail`** — at top of every script.
- **`usage()` function** — heredoc with examples, triggered by `-h`/`--help`.
- **`die()` function** — consistent error messages to stderr.
- **`main()` function** — entry point, called at bottom: `main "$@"`.
- **`--raw` flag** — allow bypassing pretty-print for debugging.
- **Long options** — `--country`, `--time`; avoid single-dash long flags.
- **`=` variants** — support both `--key value` and `--key=value` forms.
- **`compatibility` field** — required in frontmatter. Always state "requires bash" so the agent invokes scripts directly, not with python.

## Description writing

The description is the **only** field the agent sees before deciding whether to load the skill. It carries the entire triggering burden.

### Principles

- **Imperative phrasing** — "Use this skill when..." not "This skill does..."
- **User intent, not implementation** — describe what the user wants to achieve.
- **Errand on the side of pushy** — list contexts explicitly, including cases where the user doesn't name the domain.
- **Concise** — 2-4 sentences. Hard limit of 1024 characters.

### Before and after

```yaml
# Before — too vague
description: Process CSV files.

# After — specific about what and when
description: >
  Analyze CSV and tabular data files — compute summary statistics,
  add derived columns, generate charts, and clean messy data. Use
  this skill when the user has a CSV, TSV, or Excel file and wants
  to explore, transform, or visualize the data, even if they don't
  explicitly mention "CSV" or "analysis."
```

## Gotchas section guidelines

The highest-value content. Each item should be a concrete fact that defies reasonable assumptions — not general advice.

```markdown
## Gotchas

- **Naming mismatch** — The user ID is `user_id` in the database,
  `uid` in the auth service, and `accountId` in the billing API.
- **API quirk** — The `/health` endpoint returns 200 even when the
  database is down. Use `/ready` to check full service health.
- **Non-obvious default** — CSV output uses long human-readable column
  names. Use `--short-names` for machine-readable headers.
```

When an agent makes a mistake you have to correct, add the correction to gotchas.

## Calibrating control

Match instruction specificity to task fragility:

- **Be prescriptive** for fragile operations, specific sequences, or where consistency matters. Give exact commands.
- **Give freedom** when multiple approaches are valid. Explain _why_ rather than prescribing exact steps.
- **Provide defaults, not menus** — pick one approach as default, mention alternatives briefly as fallbacks.

## Progressive disclosure

Keep `SKILL.md` under 500 lines. For larger reference material:

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
