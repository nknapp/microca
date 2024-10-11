#!/bin/bash

set -e

. ./microca-config.sh

for REQUIRED_VAR in CA_ORG CA_COMMON_NAME CA_ROOT_FILE_PREFIX; do
    echo "Checking $REQUIRED_VAR"
    if [ -z "${!REQUIRED_VAR}" ] ; then
        echo "${REQUIRED_VAR} is not set."
        exit 1
    fi
done

CA_DIR=.
CA_ROOT_KEY=$CA_DIR/root/$CA_ROOT_FILE_PREFIX.key
CA_ROOT_CERT=$CA_DIR/root/$CA_ROOT_FILE_PREFIX.crt

mkdir -p $CA_DIR $CA_DIR/private $CA_DIR/csr $CA_DIR/certs $CA_DIR/root $CA_DIR/sites

openssl genrsa -aes256 -out "$CA_ROOT_KEY" 4096
openssl req -x509 -new -nodes -key "$CA_ROOT_KEY" -sha256 -days 3650 -out "$CA_ROOT_CERT" \
    -subj "/CN=$CA_COMMON_NAME/O=$CA_ORG"


cat <<EOF
  Root cerficate has been created, you can install it on this machine by running

  sudo cp $CA_ROOT_CERT /usr/local/share/ca-certificates
  sudo update-ca-certificates

  In Chrome browsers on Linux, you need to open chrome://settings/certificates and
  add it to the authorities tab.
EOF