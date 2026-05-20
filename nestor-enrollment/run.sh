#!/bin/bash

CONFIG=/data/options.json
CERT_DIR=/ssl/certs
TIMESTAMP=$(date "+%d-%m-%Y %H:%M:%S")
mkdir -p $CERT_DIR

# lecture config
API_URL=$(jq -r '.api_url' $CONFIG)
AFFAIRE=$(jq -r '.affaire' $CONFIG)
TOKEN=$(jq -r '.token' $CONFIG)

# fallback hostname si non défini
if [ -z "$AFFAIRE" ] || [ "$AFFAIRE" = "null" ]; then
  AFFAIRE=$(hostname)
fi

export API_URL AFFAIRE TOKEN CERT_DIR

echo "[$TIMESTAMP] >> Device: $AFFAIRE"
echo "[$TIMESTAMP] >> Cert dir: $CERT_DIR"

# enrôlement initial
if [ ! -f "$CERT_DIR/device.crt" ]; then
  echo "[$TIMESTAMP] >> First enrollment"
  /enroll.sh
fi

# boucle de renouvellement
while true; do
  /renew.sh
  sleep 1800
done
