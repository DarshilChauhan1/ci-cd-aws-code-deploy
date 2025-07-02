#!/bin/bash

set -e  # Exit on any error

echo "Running install.sh..."

# Ensure ubuntu owns the app files
sudo chown -R ubuntu:ubuntu /home/ubuntu/app


# Update apt-get if not recently updated
if [ ! -f /var/log/apt-update-timestamp ]; then
    echo "Running apt-get update..."
    sudo apt-get update -y
    date | sudo tee /var/log/apt-update-timestamp
else
    echo "apt-get already updated recently."
fi

# Install Node.js (from NodeSource for latest stable version)
if ! command -v node >/dev/null 2>&1; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js already installed: $(node -v)"
fi

# Navigate to app directory
cd /home/ubuntu/app || { echo "App directory not found! Exiting."; exit 1; }

# Install app dependencies
if [ -f package.json ]; then
    echo "Installing npm dependencies..."
    npm install
else
    echo "package.json not found! Skipping npm install."
fi

echo "Install complete."
