#!/bin/bash
# Deal Desk Server Deployment Script
# To be run ON THE SERVER at ${BACKEND_PATH:-/home/servicedepartmen/dealdesk-backend-2}/deploy.sh

# Configuration - Update these for your environment
BACKEND_PATH="${BACKEND_PATH:-/home/servicedepartmen/dealdesk-backend-2}"
FRONTEND_PATH="${FRONTEND_PATH:-/home/servicedepartmen/public_html/dealdesk-2}"
PM2_NAME="dealdesk-backend-2"

echo "--- Starting Deployment ---"

# 1. Pull latest code
echo "Pulling latest changes from Git..."
# Ensure we are in the backend directory to pull
cd "$BACKEND_PATH"
git pull origin main

# 2. Backend Setup
echo "Installing backend dependencies..."
npm install --silent

# 3. Frontend Sync
echo "Syncing frontend files to $FRONTEND_PATH..."
mkdir -p "$FRONTEND_PATH"
# Copy frontend files from the repo (assumed to be sibling to backend in the repo)
cp -r ../frontend/* "$FRONTEND_PATH/"

# 4. Restart Process
echo "Restarting Deal Desk Backend via PM2..."
pm2 restart "$PM2_NAME" || pm2 start server.js --name "$PM2_NAME"

echo "--- Deployment Complete ---"
echo "Dev Agent should be live at: http://your-server-ip:3017/dev-console.html"
