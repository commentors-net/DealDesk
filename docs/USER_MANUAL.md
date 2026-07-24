# Agentic Dev Console: Operating & Technical Manual

> **System Version:** Agentic Dev Console (V3)  
> **Target Audience:** Product Owners, Technical Operators, System Admins, and Developers.

---

## 1. Introduction & Core Philosophy

This document serves as the complete operational and technical guide for the **Agentic Dev Console**.

### The Autonomous Diagnostic Paradigm
In traditional AI-assisted development, using AI often requires manual intervention:
1. The AI asks you to open SSH and copy-paste a bash command.
2. You run the command and paste the output back into the chat.
3. The AI reads the output and asks for another command.

**The Agentic Dev Console shifts from manual execution to an Autonomous Copilot Model:**
* You express a business requirement or technical question in natural language.
* The Agentic Dev Console **autonomously interrogates the server, inspects code files, and queries database tables** behind the scenes.
* You watch its diagnostic execution live in an **Agent Terminal Window**, and receive a complete, synthesized research report without ever touching SSH or manually running terminal commands.

---

## 2. Standard Deal Desk Frontend

**Purpose:** The primary interface for real estate operators, managers, and admins to manage deals from "Accepted Offer" to "Closing."

*   **URL:** `http://localhost:3017/index.html` (Local) or `https://yourdomain.com/index.html` (Server)
*   **Target User:** Business Operators, Managers, Product Owners.
*   **Capabilities:** Data entry, viewing deal status, uploading documents, managing contacts, and tracking clearance tasks.

### Standard Use Case Example:
**Scenario:** A new offer has been accepted for "123 Main St."
1.  **Action:** Open the Dashboard.
2.  **Step:** Click "Add New Deal" or process the intake from the "Inbox."
3.  **Operation:** Fill in the buyer/seller names and attorney details.
4.  **Verification:** The system generates a "Transaction Tracker" (Clearance List) automatically.

---

## 3. Agentic Dev Console (The "Bridge")

**Purpose:** A secure, AI-powered assistant interface for technical interrogation, debugging, editing files, spinning up sibling applications, and running whitelisted shell commands under strict human supervision.

*   **URL:** `http://localhost:3017/dev-console.html` (Local) or `https://yourdomain.com/dev-console.html` (Server)
*   **Target User:** Product Owners, Developers, System Admins, Tech Leads.
*   **Authentication:** Protected by `DEALDESK_DEV_AGENT_TOKEN` (from `.env` or system basic auth).

### Core Capabilities & System Features:

#### 🛠️ 1. Autonomous "Ask-Once" Research Engine
When given a feature request or diagnostic question, the agent executes consecutive read-only tools (`list_directory`, `read_file`, `grep_file`, `mysql_schema`, `mysql_select`, `check_port`) in a multi-step loop behind the scenes until it understands the codebase and answers your question completely.

#### 🖥️ 2. Live Agent Terminal Execution Window
The right-hand panel of the Dev Console features a real-time monitor labeled **`AGENT TERMINAL EXECUTION`**. As the agent works, you can watch every diagnostic step execute line-by-line (`$ STEP 1: exec grep_file...`, `✔ [RESULT]`) in real time before the final response appears in the chat box.

#### 🛡️ 3. "Research-First" & Supervised Approvals
The system defaults to **Read-Only / Research mode**:
* Pure investigation, code reading, and database querying run automatically without stopping.
* Any code modification (`write_file`, `replace_file_content`), path deletion (`delete_path`), or shell command (`run_command`) enters a **Pending Approval** state. An interactive modal displays a **visual code diff** requiring your explicit click on **Approve** before anything changes.
* Rejections or timeouts happen after **10 minutes** to allow ample time to review complex code modifications.

#### ⚙️ 4. Smart PM2 Service Targeting
The agent uses `pm2 list` and `pm2 status` to identify all active services on the server. Before restarting or managing a service, it explicitly targets the exact PM2 process name (e.g., `pm2 restart dev-console-1`) and specifies its working directory (`cwd`), ensuring all other services remain running without interruption.

#### 🌐 5. Multi-Tenant Sibling App Orchestration
The agent is sandboxed to the entire user home directory (`/home/servicedepartmen/`). It can spin up, inspect, or manage sibling applications (e.g., in `devapps/` or `public_html/`), dynamically allocate ports between `3020` and `3050`, and configure public `.htaccess` routing automatically.

---

## 4. Step-by-Step Console Guide & Real-World Walkthrough

### 4.1 Quick-Start Steps
1. **Open & Authenticate:** Go to `dev-console.html` and enter your `DEALDESK_DEV_AGENT_TOKEN`.
2. **Submit Prompt:** Type your request in natural language (e.g., *"Check git status"* or *"Investigate email intake code"*).
3. **Watch Terminal:** Observe the **`AGENT TERMINAL EXECUTION`** window as diagnostic commands execute.
4. **Approve / Reject:** If the agent proposes modifying files or running shell commands, review the visual diff modal and click **Approve**.

---

### 4.2 Real-World Walkthrough: Handling Duplicate Email Attachments

*(This example reflects a real business scenario of auditing email intake for an active deal)*

#### Business Goal:
You receive an email for an active deal (**118 E Midland**) containing 4 attachments, 3 of which are suspected duplicates of existing deal files. You want the system to identify duplicates, exclude exact matches, and prompt for review on ambiguous files.

#### Step 1: Product Owner Types Prompt
> *"We are going to tackle duplicate attachments in emails that are already in the deal. For attachments going into an existing deal like 118 E Midland, we want non-duplicate files added automatically, exact duplicates skipped, and possible duplicates held for user decision. Inspect our live email ingestion and document storage code and tell me what is missing."*

#### Step 2: Live Agent Terminal Window (What You See Stream in Real Time)
```text
$ dev-agent --prompt "We are going to tackle duplicate attachments..."
[INIT] Running autonomous diagnostic investigation...
$ [STEP 1] exec mysql_select({"query":"SELECT id, public_id, property_address FROM dd_deals WHERE property_address LIKE '%118 E Midland%' LIMIT 1"})
  ✔ [RESULT] [ { "id": 14, "public_id": "2e24ea62-fc9d-4208-984f-b4e798d07bc7", "property_address": "118 E Midland" } ]

$ [STEP 2] exec mysql_schema({"table_name":"dd_deals"})
  ✔ [RESULT] Schema retrieved (28 columns).

$ [STEP 3] exec grep_file({"pattern":"inbound_email_attachments","file_path":"backend/server.js"})
  ✔ [RESULT] Matched line 4820 in backend/server.js

$ [STEP 4] exec read_file({"file_path":"backend/server.js","start_line":4810,"end_line":4860})
  ✔ [RESULT] Content retrieved (50 lines).

$ [STEP 5] exec mysql_select({"query":"SELECT id, filename, created_at FROM dd_communications WHERE deal_id = 14 LIMIT 10"})
  ✔ [RESULT] [ { "filename": "Listing_Agreement.pdf" }, { "filename": "Sales_Agreement.pdf" } ]

[COMPLETE] Interrogation finished. Synthesized response posted to chat.
----------------------------------------
```

#### Step 3: Agent's Final Chat Response
> ### Inbound Attachment Deduplication Architecture & Gap Analysis
> 
> **Current Architecture Identified:**
> 1. **Email Cache Key:** Today, SHA-256 is only used to compute an intake cache key from `IMAP UID + Subject + Date + Filename`. It does **not** hash actual attachment binary bytes.
> 2. **Database Storage:** The `dd_inbound_email_attachments` table does not currently store a `file_hash`, `duplicate_status`, or `matched_document_id`.
> 
> **Proposed Workflow Solution:**
> 1. **Exact Byte Duplicate (SHA-256 Hash Match):** Compute SHA-256 hash on attachment arrival. If hash matches a file attached to deal `2e24ea62...` (118 E Midland), mark `status = 'skipped_duplicate'` automatically.
> 2. **Clearly New File:** Add document to deal immediately.
> 3. **Possible Duplicate (Matching filename/size, differing hash):** Flag for user review with choices: `Skip New`, `Replace Existing`, `Keep Both`.
> 
> **Proposed Next Step:**
> * I can draft a migration file (`backend/sql/002_attachment_hash.sql`) to add `file_hash` and `duplicate_status` columns. 
> * *Would you like me to prepare this migration file for your approval?*

#### Step 4: Human Approval Gatekeeper
If you reply *"Yes, create the migration file"*:
1. The Dev Console displays the **Action Pending Approval** modal:
   * **Action:** `WRITE_FILE`
   * **Target:** `backend/sql/002_attachment_hash.sql`
   * **Diff Preview:** Shows the new `ALTER TABLE dd_inbound_email_attachments ADD COLUMN file_hash VARCHAR(64);` lines in green.
2. Review the SQL code diff and click **Approve**.
3. The migration file is saved safely, logged in `dd_dev_agent_audit`, and reported in the Agent Terminal monitor.

---

## 5. Technical Capabilities, Schema Migrations & Sibling Web Apps

### 5.1 Database Capabilities & Schema Migrations
The Agentic Dev Console has access to the database using the credentials configured in `backend/.env`.

*   **Whitelisted Tables:** Direct interrogation via the agent is restricted to whitelisted tables (`dd_deals`, `dd_transaction_tasks`, `dd_deal_history`, `dd_communications`, `dd_directory_contacts`, `dd_manager_chat_questions`).
*   **Read-Only Chat Queries:** Direct database queries via chat are restricted to `SELECT` operations. Destructive SQL keywords (`CREATE`, `DROP`, `ALTER`, `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`) are strictly forbidden and blocked in direct query tools.
*   **OS Sudo is Not Required:** Database schema engine operations do **not** require system root/sudo privileges. They only require appropriate privileges granted to `DB_USER` in MySQL/MariaDB.

#### Executing Schema Changes:
1. **Migration File Creation:** The Dev Agent writes a version-controlled SQL migration file to `backend/sql/` (e.g., `002_attachment_hash.sql`).
2. **Migration Execution:** The agent requests permission to run `node scripts/run-migration.js` via the console's command execution flow.
3. **Approval Flow:** Review the SQL diff and the command in the approval modal, then click **Approve** to run it safely.

---

### 5.2 Sibling Web Applications & Workspace Orchestrator (V3)
The V3 Agentic Dev Console can dynamically spin up and tear down independent sibling web applications (such as a separate public HR system or invoice portal) inside parent-relative hosting directories.

#### Workspace Safe Boundaries:
*   **Authorized Home Directory:** `/home/servicedepartmen/` (enabling access to sibling app directories like `devapps/` and `public_html/` alongside Deal Desk itself).
*   The primary Deal Desk application directories, base hosting folders, and Git/node_modules files are strictly protected from deletion.

#### Port Allocation & Sibling App Registry:
Sibling backend apps are assigned unique ports in the range `3020` to `3050`. The agent maintains a local registry at `backend/storage/dev-agent-ports.json`. When creating an app, the agent:
1. Reads the port registry file to find the next available port.
2. Registers the new app name and allocated port.
3. Writes the updated registry back to disk.

#### Dynamic Public Routing (`.htaccess`):
By default, the primary Deal Desk UI is secured by Basic Auth (`.htaccess`). Sibling applications are public by default. To proxy traffic to the sibling backend port, the agent generates an independent `.htaccess` file inside the sibling's public folder (e.g., `/home/servicedepartmen/public_html/app-name/.htaccess`) overriding parent authentication limits:
```htaccess
# Sibling App Public Routing
Satisfy Any
Allow from all

RewriteEngine On
RewriteRule ^api/(.*)$ http://127.0.0.1:PORT/api/$1 [P,L,QSA]
```

#### Application Teardown / Removal:
Under developer approval, the agent performs clean application teardowns:
1. Stop and delete the PM2 process (`pm2 stop app-name`, `pm2 delete app-name`).
2. Recursively delete the backend folder (`../devapps/app-name`) and frontend folder (`../public_html/app-name`) via `delete_path`.
3. Remove the app's record from `dev-agent-ports.json` to free the allocated port.

---

### 5.3 Automated Self-Healing & Quality Tools
* **Syntax Checker:** Uses Node `vm.Script` to validate proposed JavaScript code changes. If a syntax error is detected, the backend immediately returns the parser error to the AI model so it can self-heal before presenting an approval modal.
* **ESLint Auto-Formatting:** Whitelists `npm run lint -- --fix` to auto-fix code styling issues.
* **Secure Package Installs:** Validates `npm install <package>` commands to ensure standard public npm packages are used while blocking suspicious path injections (e.g., `npm install ../path`).
* **Port Checker:** Uses the `check_port` diagnostic tool to test if a network port is free or occupied before launching services.

---

## 6. Security Restrictions & Sandbox Guardrails

> [!CAUTION]
> **Sudo Execution and Sandbox Escapes are Strictly Blocked**
> 
> The Agentic Dev Console does **not** support executing commands with `sudo` (root privileges) or interacting with files/directories outside the authorized home directory sandbox (`/home/servicedepartmen/`).

### Guardrail Summary:
| Guardrail | Enforcement Mechanism |
| :--- | :--- |
| **No Unapproved Writes** | Visual diff approval modal blocks file writes until user clicks "Approve". |
| **No Unapproved Commands** | Whitelisted command validator blocks arbitrary shell commands & requires approval. |
| **No Secret / Password Leaks** | Automated redaction layer scrubs API keys (`OPENAI_API_KEY`) and passwords (`DB_PASSWORD`). |
| **Complete Audit Trail** | Every tool execution (allowed or blocked) is stored permanently in `dd_dev_agent_audit`. |
| **Home Directory Sandbox** | Symlink-safe path checking confines operations strictly to `/home/servicedepartmen/`. |

---

## 7. Feature Comparison & Testing Guide

### Summary Comparison Table
| Feature | Standard Frontend | Agentic Dev Console |
| :--- | :--- | :--- |
| **Primary Goal** | Business Operations & Deal Tracking | Technical Interrogation, Research & Dev |
| **Interface** | Forms, Tables, Buttons | Natural Language Chat + Live Terminal |
| **Data Access** | Formatted Deal Views | Codebase, DB Rows, Logs, System State |
| **Action Type** | Standard Operations | **Supervised Read, Write & Execution** |
| **Security** | Basic Auth / User Login | `DEALDESK_DEV_AGENT_TOKEN` |
| **Audit Log** | Deal History Table | Permanent Audit Table (`dd_dev_agent_audit`) |

---

### Testing on a Live Linux Server (Deployment & Verification)

#### Step 1: Deploy to Server
```bash
git pull
pm2 restart dev-console-1
```

#### Step 2: Open Console & Authenticate
1. Navigate to: `https://yourdomain.com/dev-console.html`
2. Enter your `DEALDESK_DEV_AGENT_TOKEN`.

#### Step 3: Run Validation Prompts
* **Test Log Tailing:** *"Show me the last 50 lines of logs for dev-console-1"* (Executes `pm2 logs dev-console-1 --lines 50 --no-daemon`).
* **Test ESLint Formatting:** *"Run the code formatter to fix styles in backend/dev-agent-tools.js"* (Executes `npm run lint -- --fix`).
* **Test Dependency Installs:** *"Install the public npm package uuid as a development dependency"* (Executes `npm install uuid -D`).
* **Test Git Workflows:** *"Checkout a new branch called dev-test, stage backend/dev-agent-tools.js, and commit changes with message 'feat: support check_port'"*.
* **Test Port Conflicts:** *"Is port 3020 free on the server?"* (Invokes `check_port`).

---
*Manual Version 3.1 — Merged & Updated July 2026*
