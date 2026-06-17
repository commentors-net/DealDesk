# Deal Desk Development & Agent Bridge

This is a living document for the Deal Desk project, detailing the architecture, implementation progress, and historical design decisions for the AI-powered Development Agent Bridge.

---

## 🚀 Implementation Plan (Living Document)

### Status Overview
The Deal Desk Read-Only Development Agent Bridge (v1) is designed to automate server diagnostics and codebase interrogation, replacing manual SSH/FileZilla loops.

### Development Phases

#### Phase 1: Security & Auditing (✅ Completed)
- [x] Create the `dd_dev_agent_audit` database table to log every tool call the AI makes.
- [x] Set up the secure token (`DEALDESK_DEV_AGENT_TOKEN`) in the `.env` file to protect the endpoint.

#### Phase 2: Core Diagnostic Tools (✅ Completed)
- [x] Build the internal `dev-agent-tools.js` module.
- [x] Code the initial read-only tools: `read_file`, `grep_file`, `mysql_schema`, `mysql_select`, `pm2_status`.
- [x] Implement the strict redaction layer to hide keys/passwords.

#### Phase 3: Backend API Integration (✅ Completed)
- [x] Implement the secure `POST /api/dev-agent/chat` endpoint in `server.js` to handle authenticated requests, run tools, and communicate with the OpenAI API.

#### Phase 4: Frontend Console (✅ Completed)
- [x] Develop the private `/dev-console.html` admin UI for a dedicated interrogation interface.

---

### V2: Active Development & Safe Write Actions

The goal of V2 is to transition the Dev Agent Bridge from a read-only diagnostician to a supervised assistant that can safely modify files, run tests, and execute approved shell commands.

#### Phase 5: Write & Modify File Tools (✅ Completed)
- [x] Implement write tools in `backend/dev-agent-tools.js`:
  - `write_file`: Create new files or overwrite existing files.
  - `replace_file_content`: Apply targeted edits to existing files.
- [x] Ensure all file operations are strictly sandboxed within the project workspace boundaries.
- [x] Add audit logs in `dd_dev_agent_audit` specifically for write attempts.

#### Phase 6: Command Execution Tool & Whitelisting (✅ Completed)
- [x] Implement a restricted `run_command` tool in `backend/dev-agent-tools.js` allowing the agent to execute specific development commands (e.g., `npm test`, `npm run build`, `git diff`).
- [x] Add strict command validation (forbidding arbitrary/destructive shell syntax like command chaining `&&`, `;`, `|`, or recursive deletions).

#### Phase 7: Interactive Developer Approvals (✅ Completed)
- [x] Build a "Human-in-the-Loop" approval flow. Any write or command execution tool must enter a "Pending Approval" state.
- [x] Extend `backend/server.js` to support SSE (Server-Sent Events) or HTTP polling so the Dev Console UI is notified of pending operations.
- [x] Update `frontend/dev-console.html` to show an interactive modal with code diffs or proposed commands, giving the developer "Approve" and "Reject" buttons.

#### Phase 8: OS-Level Access Control (AlmaLinux 10 Target) (⏳ Proposed)
- [ ] Configure access controls for `dev-console.html` and `/api/dev-agent/*` to restrict access strictly to `root` or specific system accounts on AlmaLinux 10.
- [ ] Document/test the configuration options: SSH Port Forwarding vs. PAM (Pluggable Authentication Modules) basic auth integration in Apache `.htaccess`.

---

## 🛡️ Architecture & Guardrails

*   **Location:** Integrated directly into the existing Deal Desk Node backend (`backend/server.js`).
*   **Security:** Protected by a dedicated `DEALDESK_DEV_AGENT_TOKEN` in `.env`.
*   **Privileges:** **Write-capable (v2)**. Can read, search, create, and edit files within the workspace sandbox, and execute whitelisted shell commands. All write and execution tools are strictly gatekept behind interactive developer approvals.
*   **Redaction:** All outputs are scrubbed of API keys and passwords (e.g., `OPENAI_API_KEY`, `DB_PASSWORD`) before returning to the UI or AI model.
*   **Auditing:** Every tool execution attempt is permanently logged to the `dd_dev_agent_audit` database table.

### Key Safety Highlights
- **No Root Access:** Uses a dedicated application token rather than exposing SSH credentials.
- **Sandboxed:** Restricted to a whitelist of project files and database tables.
- **Automatic Scrubbing:** A dedicated layer in `dev-agent-tools.js` replaces sensitive values with `[REDACTED]`.

---

## 📜 Historical Discussion & Design Decisions

### The "Why" Behind the Dev Agent
The project originated from the need to eliminate the "manual SSH loop":
1. AI asks for a diagnostic command.
2. User runs it via SSH.
3. User pastes output back to AI.
4. AI provides the next step.

The Dev Agent Bridge automates steps 2 and 3, allowing the AI to directly query the server through safe, pre-defined tools.

### Technical Verdict
- **Speed:** Drastically accelerates development by allowing instant server interrogation.
- **Safety:** Building the bridge into the Node backend is more secure than a public SSH gateway.
- **Auditability:** Every action is logged, providing a clear trail for security monitoring.

---

## 🔍 Technical Snapshots & Context

### Clearance Update Logic
The following logic was identified as a core area for auditing and state management:

```javascript
// Example of the Clearance Update Route Body
async function updateDealClearanceControl(dealPublicId, taskPublicId, body) {
  // ... Deal lookup ...
  const state = normalizeClearanceControlState(body.control_state || body.state, existingTask.status);
  const status = clearanceStatusFromControlState(state);
  // ... Validation and Proof checking ...
  
  // History Audit Integration
  await pool.query(
    `INSERT INTO dd_deal_history
     (deal_id, event_type, event_summary, created_by)
     VALUES (?, ?, ?, ?)`,
    [deals[0].id, 'Clearance Control Updated', eventSummary, operator]
  );
  // ...
}
```

### Installation Standard
- **Backend:** `/home/servicedepartmen/dealdesk-backend-2`
- **Frontend:** `/home/servicedepartmen/public_html/dealdesk-2`
- **Process Manager:** PM2 (running `dealdesk-backend-2`)

---
*Last Updated: June 17, 2026*
