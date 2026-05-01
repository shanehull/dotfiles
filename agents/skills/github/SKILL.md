---
name: github
description: Access, search, and manage GitHub repos, PRs, issues, and Actions via the `gh` CLI.
compatibility: Requires `gh` CLI.
allowed-tools: Bash(git:*), Bash(gh:*), Bash(cat:*), Read
---

# GitHub

Single surface: **`gh` CLI** for read + write (lifecycle, comments, CI watching, search).

## gh CLI rules

1. **Never auto-commit/push untracked files.** Run `git status` first; ask the user before adding.
2. PR creator = authenticated `gh` user (no flag changes this).
3. `@me` = current user. Branch names work wherever a PR number does.
4. Other repo: `-R owner/repo`.
5. JSON output: `--json <fields>` (requires explicit field list, e.g. `--json number,title,state`).
6. Templates auto-apply from `.github/PULL_REQUEST_TEMPLATE.md` when using `--fill` or no body flag.

Auth: `gh auth status` to check. `gh auth login --hostname github.com` to log in (pick HTTPS + browser).

## gh cheatsheet

```bash
# Create
gh pr create --fill --assignee @me
gh pr create --fill --assignee @me --reviewer user --label foo --draft

# With repo template
template=$(cat .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null)
gh pr create --title "..." --body "$template" --assignee @me

# View / comment
gh pr view [123|branch] --comments
gh pr view --web
gh pr comment [123] --body "comment"

# List
gh pr list --assignee @me
gh pr list --search "reviewer:@me label:needs-review draft:true"

# Lifecycle
gh pr review 123 --approve [-R owner/repo]
gh pr review 123 --request-changes --body "..."
gh pr merge 123 --squash --delete-branch
gh pr close 123
gh pr ready 123
gh pr edit 123 --add-reviewer user

# Diffs / commits / checks
gh pr diff 123
gh pr checks 123 [--watch]

# Issues
gh issue create --title "..." --body "..." --assignee @me --label bug
gh issue list --assignee @me
gh issue view 123 --comments
gh issue comment 123 --body "comment"
gh issue close 123

# CI / Actions
gh run list [--workflow=ci.yml]
gh run view <run-id> [--log-failed]
gh run watch <run-id>
gh workflow run <workflow> -f key=value

# Search
gh search prs "is:open author:@me"
gh search issues "is:open label:bug"
gh search code "func Foo" --owner owner --repo repo

# Find usernames
grep -i "name" .github/CODEOWNERS
```

## Workflows

**Draft → ready:** `gh pr create --fill --draft --assignee @me` → `gh pr checks --watch` → `gh pr ready` + `gh pr edit --add-reviewer user`.

**Hotfix:** `gh pr create --fill --assignee @me --reviewer lead --label hotfix` → `gh pr checks --watch` → `gh pr merge --squash --delete-branch`.

**Review:** `gh pr list --search "review-requested:@me"` → `gh pr view 123 --comments` → `gh pr review 123 --approve`.

## Rules

**Conventional Commits**: Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary) for all commit messages and PR titles.

**Simple branch names:** Use `feat/`, `fix/`, or `chore/` prefixes followed by a short slug (e.g. `feat/oauth-retry`). No ticket IDs, team names, or usernames.

**Concise PR descriptions:** Lead with the purpose of the change, then add only what a reviewer needs — links to related PRs/issues, code snippets highlighting key points, before/after notes. Skip checklists unless they track work inside this PR.
