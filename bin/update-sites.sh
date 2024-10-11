#!/bin/bash -x

set -e

. ./microca-config.sh

for REQUIRED_VAR in CA_ROOT_FILE_PREFIX CA_ORG; do
    echo "Checking $REQUIRED_VAR"
    if [ -z "${!REQUIRED_VAR}" ] ; then
        echo "${REQUIRED_VAR} is not set."
        exit 1
    fi
done

CA_DIR=.
CA_ROOT_KEY=$CA_DIR/root/$CA_ROOT_FILE_PREFIX.key
CA_ROOT_CERT=$CA_DIR/root/$CA_ROOT_FILE_PREFIX.crt

# Generate certificates for each "v3.ext" file
for i in "${CA_DIR}"/sites/*.v3.ext ; do
    if [ -z "$i" ] ; then
      echo No .v3.ext files found in $CA_DIR
      exit 1
    fi
    COMMON_NAME="$( basename "$i" .v3.ext )"
  	echo "Creating certificate for $COMMON_NAME"
    openssl req -new -nodes -out "$CA_DIR/csr/$COMMON_NAME.csr" \
       -newkey rsa:4096 -keyout "$CA_DIR/private/$COMMON_NAME.key" \
       -subj "/CN=$COMMON_NAME/O=$CA_ORG"
       
    openssl x509 -req -in "$CA_DIR/csr/$COMMON_NAME.csr" \
       -CA "$CA_ROOT_CERT" -CAkey "$CA_ROOT_KEY" -CAcreateserial \
       -out "$CA_DIR/certs/$COMMON_NAME.pem" \
       -days 365 -sha256 -extfile "$i"
   

	if [ -f "$CA_DIR/sites/$COMMON_NAME.install.sh" ] ; then
	  echo "Running $CA_DIR/sites/$COMMON_NAME.install.sh"
		bash "$CA_DIR/sites/$COMMON_NAME.install.sh" \
			"$CA_DIR/private/$COMMON_NAME.key" \
			"$CA_DIR/certs/$COMMON_NAME.pem"
	fi
done




