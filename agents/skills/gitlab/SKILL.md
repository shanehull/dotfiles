---
name: gitlab
description: Manage GitLab repositories — create and review merge requests, check CI pipeline status, search code, manage issues, and approve or merge changes. Use this skill for any GitLab project workflow including code review, releases, and hotfixes, even if the user doesn't explicitly say GitLab or MR.
compatibility: Requires GitLab MCP server and/or `glab` CLI.
allowed-tools: mcp__gitlab__*, Bash(git:*), Bash(glab:*), Bash(cat:*), Read
---

# GitLab

Two surfaces. **MCP** = read + search. **`glab`** = write (lifecycle, comments, CI watching).

MCP docs: https://docs.gitlab.com/user/gitlab_duo/model_context_protocol/mcp_server_tools/

## Pick the right tool

| Task                                  | Tool                                         |
| ------------------------------------- | -------------------------------------------- |
| Approve/merge/close/update MR         | `glab` (MCP can't write to MRs)              |
| Create MR                             | `glab` if local branch, else MCP             |
| Read MR / diff / commits / pipelines  | MCP                                          |
| Comment on MR/issue                   | `glab mr note` or MCP `create_workitem_note` |
| Semantic code search                  | MCP `semantic_code_search`                   |
| Search issues/MRs/notes/blobs/commits | MCP `search`                                 |
| Live CI status                        | `glab ci status --live`                      |
| Link work items                       | MCP `link_work_items`                        |
| Bulk approve                          | `glab mr approve <id> -R <repo>` in parallel |

## MCP tools

- **MRs:** `create_merge_request`, `get_merge_request`, `get_merge_request_commits`, `get_merge_request_diffs`, `get_merge_request_pipelines`, `get_merge_request_conflicts`. No approve/merge/close/update — use `glab`.
- **Issues / work items:** `create_issue`, `get_issue`, `create_workitem_note`, `get_workitem_notes`, `link_work_items` (`relates_to`/`blocks`/`blocked_by`), `get_saved_view_work_items`.
- **Pipelines:** `manage_pipeline` (list/create/retry/cancel/delete), `get_pipeline_jobs`.
- **Search:** `search` (scopes: issues, merge_requests, blobs, commits, notes, users, projects), `search_labels`, `semantic_code_search`.
- **Misc:** `get_mcp_server_version`.

Auth: OAuth on first use.

## glab CLI rules

1. **Always pass `--yes`** on create/update/merge — without it `glab` errors with "Unable to confirm: could not prompt".
2. With `--yes`, also pass `--fill` or `--title` (otherwise: "--Title or --fill required").
3. **Never auto-commit/push untracked files.** Run `git status` first; ask the user before adding.
4. MR creator = authenticated `glab` user (no flag changes this).
5. `@me` = current user. Branch names work wherever an MR number does.
6. Other repo: `-R group/project`.
7. JSON output: `--output json`.

Auth: `glab auth status` to check. `glab auth login --hostname gitlab.com` to log in (pick Web). If it tries github.com, the `--hostname` flag is required.

## glab cheatsheet

```bash
# Create
glab mr create --fill --yes --assignee @me
glab mr create --fill --yes --assignee @me --reviewer user --label foo --draft

# With repo template
template=$(cat .gitlab/merge_request_templates/default.md 2>/dev/null)
glab mr create --title "..." --description "$template" --assignee @me --yes

# View / comment
glab mr view [123|branch] --comments
glab mr view --web
glab mr note [123] -m "comment"

# List
glab mr list --assignee=@me
glab mr list --reviewer=@me --label needs-review --draft

# Lifecycle
glab mr approve 123 [-R group/project]
glab mr revoke 123
glab mr merge 123 --squash --remove-source-branch
glab mr close 123
glab mr update 123 --ready --reviewer user

# CI
glab ci status [--compact|--live]

# Find usernames
grep -i "name" .gitlab/CODEOWNERS
```

## Workflows

**Draft → ready:** `glab mr create --fill --yes --draft --assignee @me` → `glab ci status --live` → `glab mr update --ready --reviewer user`.

**Hotfix:** `glab mr create --fill --yes --assignee @me --reviewer lead --label hotfix` → `glab ci status --live` → `glab mr merge --squash --remove-source-branch`.

**Review:** `glab mr list --reviewer=@me` → `glab mr view 123 --comments` → `glab mr approve 123`.

## Rules

**Conventional Commits**: Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary) for all commit messages and MR titles.

**Simple branch names:** Use `feat/`, `fix/`, `docs/`, `ci/`, or `chore/` prefixes followed by a short slug (e.g. `feat/oauth-retry`). No ticket IDs, team names, or usernames.

**Never commit to main:** Always branch, commit, push, and create an MR. The only exception is `glab mr merge`. No direct pushes to `main` or `master`.

**Concise MR descriptions:** Lead with the purpose of the change, then add only what a reviewer needs — links to related MRs/issues, code snippets highlighting key points, before/after notes. Skip checklists unless they track work inside this MR.
