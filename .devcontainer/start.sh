#!/bin/bash

# 1. Install Xray binary if it doesn't exist
if ! command -v xray &> /dev/null; then
    echo "Downloading and installing Xray..."
    sudo apt-get update -y && sudo apt-get install -y wget unzip
    wget -qO xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
    unzip -qo xray.zip -d /tmp/xray
    sudo mv /tmp/xray/xray /usr/local/bin/
    sudo chmod +x /usr/local/bin/xray
    rm -rf xray.zip /tmp/xray
fi

# 2. Setup configuration directory
sudo mkdir -p /etc/xray

# 3. Create a fresh UUID or use existing one
if [ ! -f "/etc/xray/config.json" ]; then
    UUID=$(cat /proc/sys/kernel/random/uuid)
    sudo cp ./.devcontainer/config.json /etc/xray/config.json
    sudo sed -i "s/UUID_PLACEHOLDER/$UUID/g" /etc/xray/config.json
else
    # Extract the UUID if the file already exists
    UUID=$(grep -oP '(?<="id": ")[^"]*' /etc/xray/config.json)
fi

# 4. Generate the real Codespace Domain dynamically
# GitHub automatically provides the $CODESPACE_NAME variable
DOMAIN="${CODESPACE_NAME}-8080.app.github.dev"

echo "=================================================================="
echo "SUCCESS! Xray is starting."
echo "Here is your REAL VLESS+WS Link:"
echo ""
echo "vless://${UUID}@${DOMAIN}:443?type=ws&security=tls&path=%2Fxray#Codespace-WS"
echo ""
echo "=================================================================="
echo "IMPORTANT: Open the 'Ports' tab in VS Code and ensure Port 8080"
echo "Visibility is set to 'Public' by right-clicking it!"
echo "=================================================================="

# 5. Start Xray
sudo xray run -c /etc/xray/config.json
