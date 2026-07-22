# DealDesk Dev Console: Daily Developer Prompts

## Purpose
Use Dev Console for normal day-to-day developer work you would usually do over SSH, but with approvals and audit logging built in.

## Step 1: First 3 Minutes
1. Open Dev Console URL.
2. Paste DEALDESK_DEV_AGENT_TOKEN in the token field.
3. Send one read-only message first.
4. Confirm output appears in chat and in Live Audit Log.

## First Message To Send
Show me first 80 lines of backend/dev-agent-tools.js and summarize what redact() and getSafePath() protect.

## Daily Operating Prompts (Top 20)
Copy-paste these directly into Dev Console chat.

1. Show PM2 status for all processes and highlight any process that is not online.
2. Show last 120 lines of logs for dealdesk-backend-2 and summarize errors in plain English.
3. Check whether port 3017 is in use and report listener details.
4. Find where /api/dev-agent/chat is defined and show the route handler function.
5. Search for DEALDESK_DEV_AGENT_TOKEN validation logic and explain the auth flow.
6. Show backend/dev-agent-tools.js functions related to read_file, replace_file_content, and run_command.
7. Show git status and summarize only files changed in backend and frontend dev console assets.
8. Show git diff for backend/server.js and explain behavior changes in bullet points.
9. In backend/server.js, improve the invalid JSON error message for developers, show exact diff, and wait for approval.
10. After the previous change, run backend lint and report any warnings or errors by file.
11. Run backend tests and show failed test names with stack traces.
12. Find all references to dd_dev_agent_audit and explain where rows are inserted.
13. Query latest 20 audit entries and group by status allowed, blocked, approved, rejected.
14. Find code handling pending approvals and explain timeout behavior.
15. Show recent changes in backend/email-worker.js and summarize potential risk areas.
16. Search backend/routes for clearance update logic and show key validation checks.
17. Create a new migration file in backend/sql to add an index on dd_dev_agent_audit created_at, then show diff and wait for approval.
18. Run node scripts/run-migration.js from backend directory and report result.
19. Show current PM2 ecosystem or process config relevant to dealdesk-backend-2 and suggest safe restart command.
20. Prepare commit workflow: create branch named chore/dev-console-audit-tidy, stage modified files, and draft a commit message; wait for approval before committing.

## Approval Pattern
- Read-only requests: run directly.
- Write/command/delete requests: pending approval modal appears.
- You approve or reject each action.

## Prompting Tips
- Start with scope: include file path, route name, process name, or table name.
- Ask for format: request summary, diff, root cause, or step-by-step output.
- For risky actions: explicitly say wait for approval before executing.

## Quick Troubleshooting
- Token not accepted: verify token value in backend environment config.
- No audit updates: click Refresh in Live Audit Log panel and verify DB connectivity.
- Command timed out: rerun with smaller scope (fewer log lines, narrower file path).
