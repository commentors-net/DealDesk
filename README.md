# Deal Desk

A real estate transaction management system for handling deals from "Accepted Offer" to "Closing."

## Core Components
- **Frontend:** Standard UI for real estate operators to manage deals and clearance tasks.
- **Backend:** Node.js API handling business logic, data persistence, and AI integrations.
- **Dev Agent Bridge:** A secure, AI-powered diagnostic console for technical interrogation and debugging.

## Documentation
- [User & Developer Manual](./docs/USER_MANUAL.md) - Detailed guide on using the frontend vs. the Dev Console.

## Server Installation

There are two ways to install or update the Deal Desk system: using the **Interactive Installer** (recommended for fresh setups) or the **Standard Deployer** (for updates).

### Prerequisites
1. Ensure `git`, `node` (v16+), and `npm` are installed on the server.
2. Ensure `pm2` is installed globally (`npm install -g pm2`).
3. Ensure a MySQL/MariaDB database has been created by the system administrator.

---

### Option 1: Interactive Installation (Fresh Setup)
This is the easiest way to setup a new instance (e.g., `dealdesk-2`).

1. **Upload or create `install.sh`** on your server.
2. **Run the script:**
   ```bash
   bash install.sh
   ```
3. **Follow the prompts:** The script will ask for your GitHub repository, installation paths, and database credentials. It will automatically:
   - Clone the code.
   - Generate your `.env` file.
   - Install dependencies.
   - Run database migrations.
   - Launch the application via PM2.

---

### Option 2: Standard Deployment (Updates)
Use this script to pull the latest changes and restart an existing instance.

1. **Navigate to your backend folder:**
   ```bash
   cd /home/servicedepartmen/dealdesk-backend-2
   ```
2. **Run the deployer:**
   ```bash
   bash backend/deploy-server.sh
   ```

---

### Database Migrations
The system includes an automatic migration tool that ensures your database schema is up-to-date. This runs automatically during installation, but can be run manually if needed:

```bash
cd backend
node scripts/run-migration.js
```
*Migrations are tracked in the `dd_migrations` table to ensure each script in `backend/sql/` is only applied once.*

End of document