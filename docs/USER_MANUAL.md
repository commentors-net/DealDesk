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
**Purpose:** A secure, AI-powered diagnostic interface for developers and technical leads to interrogate the application state without manual database/SSH access.

*   **URL:** `http://localhost:3017/dev-console.html`
*   **Target User:** Developers, System Admins, Tech Leads.
*   **Capabilities:** Code inspection, direct (read-only) database queries, log grepping, and deal snapshots.

### Use Case Example:
**Scenario:** A manager says "123 Main St" shows 10 open tasks on the detail page but only 7 on the dashboard summary.
1.  **Action:** Open the **Dev Console**.
2.  **Security:** Enter your `DEALDESK_DEV_AGENT_TOKEN`.
3.  **Prompt:** *"Why is the dashboard count different from the clearance count for 123 Main St? Compare the query logic in server.js."*
4.  **AI Response:** The Agent will use `grep_file` on `server.js` and `mysql_select` on the database to find the discrepancy (e.g., the dashboard might be excluding 'Not Applicable' tasks while the detail page isn't).
5.  **Outcome:** The AI provides a "Proposed Patch" for the code fix.

---

## Summary Comparison

| Feature | Standard Frontend | Dev Agent Console |
| :--- | :--- | :--- |
| **Primary Goal** | Business Operations | Technical Diagnostics |
| **Interface** | Buttons, Forms, Tables | Chat (Natural Language) |
| **Data Access** | User-friendly views | Raw DB rows & Source Code |
| **Action Type** | Write/Edit/Delete | **Strictly Read-Only** |
| **Security** | User Login | Dev Agent Token (from .env) |
| **Audit** | Deal History Table | Dev Agent Audit Table |

---

## How to Test/Run
To run both simultaneously in VS Code, use the **Run and Debug** sidebar and select the compound configuration:
*   **Dev Mode (Backend + Console)**

This will launch the backend server and open the Developer Console side-by-side.
