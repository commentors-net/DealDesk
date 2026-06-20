# Deal Desk

A real estate transaction management system for handling deals from "Accepted Offer" to "Closing."

## Core Components
- **Frontend:** Standard UI for real estate operators to manage deals and clearance tasks.
- **Backend:** Node.js API handling business logic, data persistence, and AI integrations.
- **Dev Agent Bridge:** A secure, supervised AI-powered developer assistant (v3) for codebase diagnostics, file editing, network port verification, live log tailing, dependency management, and Git commits under developer approvals.

## Documentation
- [User & Developer Manual](./docs/USER_MANUAL.md) - Detailed guide on using the frontend, the Dev Console, and the interactive approval workflow.

## Server Installation

There is one primary way to install or update the Deal Desk system: using the **Interactive Installer & Deployer** (`install.sh`), which automatically handles fresh setups as well as subsequent code updates and database migrations.

### Prerequisites
1. Ensure `git`, `node` (v16+), and `npm` are installed on the server.
2. Ensure `pm2` is installed globally (`npm install -g pm2`).
3. Ensure a MySQL/MariaDB database has been created by the system administrator.

---

### Interactive Installation & Deployment (Fresh Setup or Updates)
This script is used for both setting up a new instance and deploying updates to an existing one.

1. **Upload or run `install.sh`** on your server.
2. **Run the script:**
   ```bash
   bash install.sh
   ```
3. **Smart Workflows:**
   *   **Fresh Setup:** Follow the prompts to configure your repository, directories, database credentials, and port. The script will clone, generate `.env`, install dependencies, run migrations, and launch PM2.
   *   **Existing Update:** The script automatically detects existing installations (e.g. at `/home/servicedepartmen/dealdesk-backend-2` or the local dir). It prompts: *"Would you like to run an UPDATE/DEPLOYMENT using this configuration? [Y/n]"*. Selecting Yes automatically loads the configuration, pulls the latest code, runs database migrations, updates frontend files, and restarts PM2 without overwriting `.env` secrets.

---

### Database Migrations
The system includes an automatic migration tool that ensures your database schema is up-to-date. This runs automatically during installation, but can be run manually if needed:

```bash
cd backend
node scripts/run-migration.js
```
*Migrations are tracked in the `dd_migrations` table to ensure each script in `backend/sql/` is only applied once.*

End of document