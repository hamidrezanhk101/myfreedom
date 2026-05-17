#!/bin/bash
set -e

# Generate REALITY keypair and Short ID
KEYS=$(/usr/local/bin/xray x25519)
PRIVATE_KEY=$(echo "$KEYS" | grep "Private key:" | awk '{print $3}')
PUBLIC_KEY=$(echo "$KEYS" | grep "Public key:" | awk '{print $3}')
SHORT_ID=$(openssl rand -hex 8)

# Inject keys into config.json
sed -i "s/PRIVATE_KEY_PLACEHOLDER/$PRIVATE_KEY/g" /etc/xray/g2ray.json
sed -i "s/SHORT_ID_PLACEHOLDER/$SHORT_ID/g" /etc/xray/g2ray.json

# Output the connection string to the console
printf "\n\033[1;32m[g2ray]\033[0m Connection string:\n"
printf "vless://2166797c-f912-4a24-a467-c5d0c216cc2d@94.130.50.12:443?encryption=none&security=reality&type=xhttp&mode=packet-up&pbk=%s&sid=%s&sni=yahoo.com&fp=chrome&path=%%2F#g2ray\n\n" "$PUBLIC_KEY" "$SHORT_ID"

# Save it to bashrc so you can see it if you open a terminal later
echo "echo 'vless://2166797c-f912-4a24-a467-c5d0c216cc2d@94.130.50.12:443?encryption=none&security=reality&type=xhttp&mode=packet-up&pbk=$PUBLIC_KEY&sid=$SHORT_ID&sni=yahoo.com&fp=chrome&path=%2F#g2ray'" >> /etc/bash.bashrc

# Start Xray
exec /usr/local/bin/xray run -c /etc/xray/g2ray.json
