#!/usr/bin/env bash
set -e

echo "Installing syswatch modules and binary..."

# Create system directories
sudo mkdir -p /usr/lib/syswatch
sudo mkdir -p /etc/syswatch

# Copy files
sudo cp bin/syswatch /usr/local/bin/syswatch
sudo cp lib/*.sh /usr/lib/syswatch/
sudo cp config/syswatch.conf /etc/syswatch/syswatch.conf

# Make executable
sudo chmod +x /usr/local/bin/syswatch

echo "Installation complete! Run 'syswatch' from anywhere."