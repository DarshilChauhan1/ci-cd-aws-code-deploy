#!/bin/bash

set -e  # Exit on any error

echo "Running start.sh..."

cd /home/ubuntu/app || { echo "App directory not found! Exiting."; exit 1; }

# Install PM2 globally if not installed
if ! command -v pm2 >/dev/null 2>&1; then
    echo "Installing PM2..."
    sudo npm install -g pm2
fi

# Stop any existing instance of the app
APP_NAME="my-app"

if pm2 list | grep -q "$APP_NAME"; then
    echo "Stopping existing PM2 app: $APP_NAME"
    pm2 stop "$APP_NAME"
    pm2 delete "$APP_NAME"
fi

#Build the app
echo "Building the app..."
npm run build

# Start the app with PM2
echo "Starting app with PM2..."
pm2 start dist/main.js --name "$APP_NAME"

# Save the PM2 process list and configure it to launch on boot
pm2 save

echo "App started and managed with PM2."
