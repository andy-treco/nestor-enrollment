#!/bin/bash

CONFIG=/data/options.json
CERT_DIR=/ssl/certs

mkdir -p $CERT_DIR

# lecture config
API_URL=$(jq -r '.api_url' $CONFIG)
DEVICE_ID=$(jq -r '.device_id' $CONFIG)
AFFAIRE=$(jq -r '.affaire' $CONFIG)
TOKEN=$(jq -r '.token' $CONFIG)

# fallback hostname si non défini
if [ -z "$DEVICE_ID" ] || [ "$DEVICE_ID" = "null" ]; then
  DEVICE_ID=$(hostname)
fi

export API_URL DEVICE_ID AFFAIRE TOKEN CERT_DIR

echo ">> Device: $DEVICE_ID"
echo ">> Cert dir: $CERT_DIR"

# enrôlement initial
if [ ! -f "$CERT_DIR/device.crt" ]; then
  echo ">> First enrollment"
  /app/enroll.sh
fi

# boucle de renouvellement
while true; do
  /app/renew.sh
  sleep 86400
done