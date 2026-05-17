#!/bin/bash

# Generate UUID
UUID=$(xray uuid)

# Inject UUID into config
sed -i "s/UUID_PLACEHOLDER/$UUID/g" /etc/xray/config.json

# Determine the Codespace Domain
if [ -n "$CODESPACE_NAME" ] && [ -n "$GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN" ]; then
    DOMAIN="${CODESPACE_NAME}-443.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
elif [ -n "$CODESPACE_NAME" ]; then
    DOMAIN="${CODESPACE_NAME}-443.app.github.dev"
else
    DOMAIN="YOUR_CODESPACE_DOMAIN"
fi

# Build Connection String
LINK="vless://${UUID}@${DOMAIN}:443?type=ws&security=tls&path=%2Fxray#Codespace-WS"

echo "================================================================"
echo "SUCCESS! Xray is starting."
echo "Here is your VLESS+WS Link:"
echo "$LINK"
echo "================================================================"

# Save to bashrc so you can see it if you open a new terminal
echo "echo ''" >> /etc/bash.bashrc
echo "echo 'Your VLESS Link:'" >> /etc/bash.bashrc
echo "echo '$LINK'" >> /etc/bash.bashrc

# Start Xray
exec xray -c /etc/xray/config.json
