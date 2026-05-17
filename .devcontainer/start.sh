#!/bin/bash

# Generate REALITY keys robustly
KEYPAIR=$(/usr/local/bin/xray x25519)
PRIVATE_KEY=$(echo "$KEYPAIR" | grep -i "private" | awk '{print $NF}')
PUBLIC_KEY=$(echo "$KEYPAIR" | grep -i "public" | awk '{print $NF}')
SHORT_ID=$(openssl rand -hex 8)

# Safety check to prevent container crash if key generation fails
if [ -z "$PRIVATE_KEY" ] || [ -z "$PUBLIC_KEY" ]; then
    echo "CRITICAL ERROR: Failed to generate or parse Xray keys."
    echo "Raw output was: $KEYPAIR"
    sleep infinity # Keep container alive for debugging
fi

# Inject keys into config
sed -i "s/PRIVATE_KEY_PLACEHOLDER/$PRIVATE_KEY/g" /etc/xray/g2ray.json
sed -i "s/SHORT_ID_PLACEHOLDER/$SHORT_ID/g" /etc/xray/g2ray.json

# Extract IP (Fallback to Codespace name if IP isn't easily reachable)
SERVER_IP=$(curl -s https://api.ipify.org || echo "YOUR_SERVER_IP")
UUID=$(jq -r '.inbounds[0].settings.clients[0].id' /etc/xray/g2ray.json)

# Create connection string
LINK="vless://${UUID}@${SERVER_IP}:443?encryption=none&security=reality&type=xhttp&mode=packet-up&pbk=${PUBLIC_KEY}&sid=${SHORT_ID}&sni=yahoo.com&fp=chrome&path=%2F#g2ray"

# Print and save link
echo -e "\n[g2ray] Connection string:\n$LINK\n"
echo "echo -e '\n[g2ray] Connection string:\n$LINK\n'" >> /etc/bash.bashrc

# Start Xray
exec /usr/local/bin/xray run -c /etc/xray/g2ray.json
