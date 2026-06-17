#!/usr/bin/env bash
# Deal Desk Interactive Server Installer & Deployer
# This script can be run on a fresh server to setup the environment.

set -e

echo "==============================================="
echo "   Deal Desk Interactive Server Installer      "
echo "==============================================="

# 1. Gather Information Interactively
read -p "GitHub Repository URL [https://github.com/user/repo.git]: " GIT_REPO
read -p "Target Backend Path [/home/servicedepartmen/dealdesk-backend-2]: " TARGET_BACKEND
TARGET_BACKEND=${TARGET_BACKEND:-/home/servicedepartmen/dealdesk-backend-2}

read -p "Target Frontend Path [/home/servicedepartmen/public_html/dealdesk-2]: " TARGET_FRONTEND
TARGET_FRONTEND=${TARGET_FRONTEND:-/home/servicedepartmen/public_html/dealdesk-2}

read -p "PM2 Process Name [dealdesk-backend-2]: " PM2_NAME
PM2_NAME=${PM2_NAME:-dealdesk-backend-2}

read -p "Server Port [3017]: " SERVER_PORT
SERVER_PORT=${SERVER_PORT:-3017}

read -p "Database Host [localhost]: " DB_HOST
DB_HOST=${DB_HOST:-localhost}

read -p "Database Name: " DB_NAME
read -p "Database User: " DB_USER
read -s -p "Database Password: " DB_PASSWORD
echo ""

# 2. Setup Directory and Clone Code
if [ ! -d "$TARGET_BACKEND" ]; then
    echo "Creating directory and cloning repository..."
    mkdir -p "$(dirname "$TARGET_BACKEND")"
    git clone "$GIT_REPO" "$TARGET_BACKEND"
    cd "$TARGET_BACKEND"
else
    echo "Directory exists. Pulling latest code..."
    cd "$TARGET_BACKEND"
    git pull origin main
fi

# 3. Create/Update .env file
echo "Configuring .env file..."
cat <<EOF > backend/.env
DEALDESK_HOST=127.0.0.1
DEALDESK_PORT=$SERVER_PORT
DB_HOST=$DB_HOST
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_NAME=$DB_NAME
BACKEND_PATH=$TARGET_BACKEND
FRONTEND_PATH=$TARGET_FRONTEND
EOF

# 4. Install Dependencies
echo "Installing backend dependencies..."
cd backend
npm install --silent

# 5. Database Verification (Simple check)
echo "Checking database connection..."
# We try to run a simple node script to verify the connection
cat <<EOF > test_conn.js
const mysql = require('mysql2/promise');
require('dotenv').config();
async function test() {
  try {
    const conn = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME
    });
    console.log("Database connection successful!");
    await conn.end();
  } catch (err) {
    console.error("Database connection failed: " + err.message);
    process.exit(1);
  }
}
test();
EOF

if node test_conn.js; then
    echo "Database connection successful."
    rm test_conn.js
    
    # 6. Run Migrations
    echo "Running database migrations..."
    node scripts/run-migration.js
else
    echo "CRITICAL: Database connection failed. Please check your credentials and ensure the database '$DB_NAME' exists."
    rm test_conn.js
    exit 1
fi

# 7. Setup Frontend
echo "Setting up frontend at $TARGET_FRONTEND..."
mkdir -p "$TARGET_FRONTEND"
cp -r ../frontend/* "$TARGET_FRONTEND/"

# 8. Start/Restart Process
echo "Launching via PM2..."
if pm2 describe "$PM2_NAME" > /dev/null 2>&1; then
    pm2 restart "$PM2_NAME" --update-env
else
    pm2 start server.js --name "$PM2_NAME"
fi

echo "==============================================="
echo "   Installation Complete!                      "
echo "   Backend: $TARGET_BACKEND                    "
echo "   Frontend: $TARGET_FRONTEND                  "
echo "   PM2 Process: $PM2_NAME                      "
echo "==============================================="
