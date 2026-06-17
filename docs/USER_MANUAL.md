# Deal Desk: User & Developer Manual

This document explains the difference between the **Standard Deal Desk Frontend** and the **Dev Agent Console**, including how to use them with examples.

---

## 1. Standard Deal Desk Frontend
**Purpose:** The primary interface for real estate operators, managers, and admins to manage deals from "Accepted Offer" to "Closing."

*   **URL:** `http://localhost:3017/index.html` (Local) or `https://yourdomain.com/index.html` (Server)
*   **Target User:** Business Operators, Managers.
*   **Capabilities:** Data entry, viewing deal status, uploading documents, managing contacts, and tracking clearance tasks.

### Use Case Example:
**Scenario:** A new offer has been accepted for "123 Main St."
1.  **Action:** Open the Dashboard.
2.  **Step:** Click "Add New Deal" or process the intake from the "Inbox."
3.  **Operation:** Fill in the buyer/seller names and attorney details.
4.  **Verification:** The system generates a "Transaction Tracker" (Clearance List) automatically.

---

## 2. Dev Agent Console (The "Bridge")
**Purpose:** A secure, AI-powered developer assistant interface for technical interrogation, debugging, editing files, and running whitelisted shell commands.

*   **URL:** `http://localhost:3017/dev-console.html`
*   **Target User:** Developers, System Admins, Tech Leads.
*   **Capabilities:** Code inspection, database queries, log grepping, deal snapshots, creating/modifying code files, and executing whitelisted shell commands (`git status/diff`, `npm test/build`, etc.) under strict sandboxing.

### 2.1 Interactive Developer Approvals (V2 Human-in-the-Loop)
To ensure system safety, the Dev Agent cannot write files or execute commands autonomously. When the agent attempts these actions, a **Pending Approval** modal appears on the console UI:
1.  **Code Diffs:** Shows deleted lines (red) and proposed replacement lines (green) for targeted modifications.
2.  **Command Previews:** Displays the exact shell command to be executed.
3.  **Approve/Reject Controls:** The developer can click **Approve** to authorize the action, or **Reject** (with an optional explanation) to block it.

### Use Case Example:
**Scenario:** A developer wants to verify a bug fix in `server.js` and run the project's tests.
1.  **Action:** Open the **Dev Console**.
2.  **Security:** Enter your `DEALDESK_DEV_AGENT_TOKEN`.
3.  **Prompt:** *"Find and replace the legacy port check in server.js, then run the test suite."*
4.  **Flow:**
    *   The agent uses `grep_file` to search.
    *   It requests a `replace_file_content` call. The UI displays the code diff. The developer reviews it and clicks **Approve**.
    *   It requests a `run_command` call with `npm test`. The UI displays the command. The developer clicks **Approve**.
5.  **Outcome:** The files are updated and tests are executed successfully, with all actions audited in `dd_dev_agent_audit`.

### 2.2 Database Schema Migrations
For database schema modifications (such as creating tables, altering columns, or adding indexes):
1.  **Migration File Creation:** The Dev Agent writes a version-controlled SQL migration file to `backend/sql/` (e.g., `002_person.sql`). The UI prompts you to review and approve the file contents.
2.  **Migration Execution:** The agent requests permission to run `node scripts/run-migration.js` via the console's command execution flow.
3.  **Approval Flow:** Review the SQL diff and the command in the approval modal, then click **Approve** to run it safely.

---

## 3. Current Sandbox Limitations & Roadmap

### 3.1 Current Environment Limitations
*   **Folder Sandboxing:** The Dev Agent is strictly sandboxed to the project directory. It can only read, write, modify files, and run commands **inside the current environment folder** (e.g., `/home/servicedepartmen/dev-console/`). Any attempt to access or execute scripts outside this folder is blocked by security guards.
*   **Read-Only DB Queries:** Direct database write/DDL execution (like ad-hoc `CREATE TABLE` or `DELETE`) is disabled inside the interactive chat window. Database modifications must go through version-controlled migrations as described in section 2.2.

### 3.2 Next Iteration Roadmap
*   **System-Wide Execution:** The next iteration is planned to support executing actions and configuration updates **outside the current folder environment** (such as managing OS-level settings, updating Apache/Nginx configuration outside the workspace, setting up PAM basic auth integration, and general server system administration tasks).

---

## Summary Comparison

| Feature | Standard Frontend | Dev Agent Console |
| :--- | :--- | :--- |
| **Primary Goal** | Business Operations | Technical Diagnostics & Development |
| **Interface** | Buttons, Forms, Tables | Chat (Natural Language) |
| **Data Access** | User-friendly views | Raw DB rows, Source Code, Shell |
| **Action Type** | Write/Edit/Delete (Deals) | **Supervised Read & Write** (Requires Developer Approval) |
| **Security** | User Login | Dev Agent Token (from `.env` or localhost bypass) |
| **Audit** | Deal History Table | Dev Agent Audit Table (`dd_dev_agent_audit`) |

---

## How to Test/Run
To run both simultaneously in VS Code, use the **Run and Debug** sidebar and select the compound configuration:
*   **Dev Mode (Backend + Console)**

This will launch the backend server and open the Developer Console side-by-side.

