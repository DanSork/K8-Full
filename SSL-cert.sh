#!/bin/bash

set -euo pipefail
 
NAMESPACE="yelb"
HOST="yelb.local"
CERT_DIR="$(mktemp -d)"
 
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "${CERT_DIR}/tls.key" \
  -out "${CERT_DIR}/tls.crt" \
  -subj "/CN=${HOST}/O=${HOST}"
 
kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -
 
kubectl create secret tls yelb-tls \
  --cert="${CERT_DIR}/tls.crt" \
  --key="${CERT_DIR}/tls.key" \
  --namespace "${NAMESPACE}" \
  --dry-run=client -o yaml | kubectl apply -f -
 
rm -rf "${CERT_DIR}"
echo "Secret 'yelb-tls' created in namespace '${NAMESPACE}'."