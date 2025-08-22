#!/bin/bash

set -e

CERT_DIR=certs
mkdir -p "$CERT_DIR"
cd "$CERT_DIR"

echo "[*] Generating CA (ca.key, ca.crt)..."
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt -subj "/CN=MyDockerRootCA"

# echo "[*] Generating server key and CSR (server.key, server.csr)..."
# openssl genrsa -out server.key 4096
# openssl req -new -key server.key -out server.csr -subj "/CN=nginx-proxy"

# echo "[*] Creating server certificate..."
# openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
#     -out server.crt -days 3650 -sha256

# generate-docker-proxy-certs.sh (updated server cert part)

echo "[*] Generating server key and CSR..."
openssl genrsa -out server.key 4096

cat > server.cnf <<EOF
[ req ]
default_bits       = 4096
distinguished_name = req_distinguished_name
req_extensions     = req_ext
x509_extensions    = v3_req
prompt             = no

[ req_distinguished_name ]
CN = docker-proxy

[ req_ext ]
subjectAltName = @alt_names

[ v3_req ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1   = localhost
IP.1    = 127.0.0.1
DNS.2   = nginx-proxy
EOF

openssl req -new -key server.key -out server.csr -config server.cnf

openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
    -out server.crt -days 3650 -sha256 -extfile server.cnf -extensions v3_req

rm -f server.cnf


echo "[*] Generating client key and CSR (client.key, client.csr)..."
openssl genrsa -out client.key 4096
openssl req -new -key client.key -out client.csr -subj "/CN=docker-client"

echo "[*] Creating client certificate..."
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
    -out client.crt -days 3650 -sha256

echo "[*] Cleaning up CSRs and serials..."
rm -f *.csr *.srl

echo "[✓] All certs generated in ./${CERT_DIR} ✅"
ls -l
