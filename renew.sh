#!/bin/bash

CERT=$CERT_DIR/device.crt

# Vérifie expiration dans 10 jours
if openssl x509 -checkend 864000 -noout -in $CERT; then
  echo ">> Cert still valid"
  exit 0
fi

echo ">> Renewing certificate"

# CSR avec clé existante
openssl req -new -key $CERT_DIR/device.key \
-out $CERT_DIR/device.csr \
-subj "/CN=$DEVICE_ID" \
-addext "subjectAltName=DNS:$DEVICE_ID"

CSR=$(awk '{printf "%s\\n", $0}' $CERT_DIR/device.csr)

RESPONSE=$(curl -s -X POST "$API_URL/renew" \
  --cert $CERT_DIR/device.crt \
  --key $CERT_DIR/device.key \
  -H "Content-Type: application/json" \
  -d "{
    \"csr\": \"$CSR\"
  }")

echo "$RESPONSE" | jq -r '.cert' > $CERT_DIR/device.crt.new

# remplacement atomique
mv $CERT_DIR/device.crt.new $CERT_DIR/device.crt

chmod 644 $CERT_DIR/device.crt

echo ">> Renewal done"