#!/bin/bash

# Kill any existing x-ui processes
sudo pkill -f x-ui

# Create necessary directories
sudo mkdir -p /usr/local/x-ui
sudo mkdir -p /etc/x-ui

# Download and extract 3x-ui if it's not already there
if [ ! -f "/usr/local/x-ui/x-ui" ]; then
    echo "Downloading 3x-ui..."
    wget -qO x-ui.tar.gz https://github.com/MHSanaei/3x-ui/releases/latest/download/x-ui-linux-amd64.tar.gz
    sudo tar -zxvf x-ui.tar.gz -C /usr/local/
    rm x-ui.tar.gz
    sudo chmod +x /usr/local/x-ui/x-ui
fi

# Start 3x-ui in the background
echo "Starting 3x-ui..."
cd /usr/local/x-ui
sudo nohup ./x-ui > /tmp/xui.log 2>&1 &

# Output the Panel URL
echo "========================================="
echo "3x-ui Panel URL: https://${CODESPACE_NAME}-2053.app.github.dev"
echo "Username: admin"
echo "Password: admin"
echo "========================================="
