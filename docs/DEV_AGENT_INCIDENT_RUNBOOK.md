# DealDesk Dev Console: Incident Response Runbook

## Goal
Handle production incidents with a safe, evidence-first workflow in Dev Console.

## Incident Workflow
- Phase 1: Read-only diagnostics and evidence collection.
- Phase 2: Approved remediation only (commands/edits require approval).
- Phase 3: Verification and written incident summary.

## Top 10 Incident Prompts
Use these during production incidents. Start with read-only triage, then controlled remediation.

1. Incident triage start: show PM2 status for dealdesk-backend-2, last 150 log lines, and top 3 probable causes.
2. Check service reachability: test if backend port 3017 is listening and report process details.
3. API health sweep: identify failing API routes from recent logs and rank by error frequency in the last 30 minutes.
4. Database connectivity check: verify current DB connection health indicators from backend logs and summarize timeout/refused errors.
5. Crash loop diagnosis: detect restart loops for dealdesk-backend-2 and show timestamps, exit patterns, and likely trigger file/module.
6. Recent change correlation: run git log and git diff for latest deploy window and identify risky changes tied to failing routes.
7. Token/auth failures: find authentication-related errors for dev-agent or API auth and summarize root cause candidates.
8. Safe rollback prep: show commands and file diff needed to revert only the latest risky backend change; wait for approval before any command.
9. Controlled restart: propose minimal-risk recovery sequence (graceful restart, verify logs, verify key route), and wait for approval before execution.
10. Incident report draft: produce a short post-incident summary with timeline, root cause, remediation, and prevention actions.

## Incident Exit Checklist
1. Service is healthy (process online, key route responding).
2. Logs show no recurring fatal errors after restart/fix.
3. Root cause is identified and documented.
4. Temporary mitigations and permanent fixes are separated.
5. Incident summary is shared with team.
