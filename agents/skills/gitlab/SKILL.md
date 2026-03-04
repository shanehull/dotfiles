---
name: gitlab
description: Access, search, and manage GitLab repositories, merge requests, issues, and pipelines. Use when the user asks for information from GitLab or needs to manage git-related workflows on GitLab.
compatibility: Requires GitLab MCP server connection.
allowed-tools: mcp__gitlab__*
---

# GitLab

Direct access to your GitLab instance for searching, managing repositories, MRs, and issues.

## Repositories

Use `get_project` or `list_projects` to find and access specific repositories.

## Merge Requests

- `list_merge_requests`: See open MRs across projects.
- `get_merge_request`: View details, discussions, and changes of an MR.
- `create_merge_request`: Start a new MR for your changes.
- `update_merge_request`: Approve, close, or merge existing MRs.

## Issues

- `list_issues`: Search for tasks and bugs.
- `get_issue`: Read descriptions and comments.
- `create_issue`: Report new bugs or feature requests.

## Pipelines & CI/CD

- `list_pipelines`: Check the status of builds and deployments.
- `get_pipeline`: See detailed job logs and failures.

## Authentication

This skill uses the official GitLab MCP server which requires OAuth authentication. If prompted, follow the login flow to grant access to your GitLab account and organizations.
