#!/bin/bash

# Example for running the CA on the same server as the web-server (in this case "nextcloudpi")

set -e

KEYFILE=$1
CERTFILE=$2

TARGET_CERT=/etc/ssl/certs/nextcloudpi.pem
TARGET_KEY=/etc/ssl/private/nextcloudpi.key

sudo cp $CERTFILE $TARGET_CERT
sudo cp $KEYFILE $TARGET_KEY
sudo chown root:ssl-cert $TARGET_KEY
sudo chmod 640 $TARGET_KEY

sed -i "s_SSLCertificateFile.*_SSLCertificateFile ${TARGET_CERT}_" /etc/apache2/sites-enabled/001-nextcloud.conf 
sed -i "s_SSLCertificateKeyFile.*_SSLCertificateKeyFile ${TARGET_KEY}_" /etc/apache2/sites-enabled/001-nextcloud.conf 
