#!/bin/bash

# 1. Install Xray binary if it doesn't exist
if ! command -v xray &> /dev/null; then
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
    sudo cp .devcontainer/config.json /etc/xray/config.json
    sudo sed -i "s/UUID_PLACEHOLDER/$UUID/g" /etc/xray/config.json
else
    # Extract the UUID if the file already exists
    UUID=$(grep -oP '(?<="id": ")[^"]*' /etc/xray/config.json)
fi

# 4. Generate the real Codespace Domain
DOMAIN="${CODESPACE_NAME}-8080.app.github.dev"

# 5. Output the link to a file in your workspace
echo "vless://${UUID}@${DOMAIN}:443?type=ws&security=tls&path=%2Fxray#Codespace-Automated" > VLESS_LINK.txt

# 6. Kill any existing Xray processes (useful if restarting codespace)
sudo pkill xray || true

# 7. Start Xray in the background
nohup sudo xray run -c /etc/xray/config.json > /tmp/xray.log 2>&1 &
