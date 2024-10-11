#!/update-sites.sh/sh

# Example for having the CA on a separate machine, copying and installing the certificate on a remote server via ssh.
# Note that this is not an automatic process, at least if "sudo" needs a password entered on the tty.

set -e

KEY_FILE=$1
CERT_FILE=$2

ssh pi@nextcloudpi mkdir -p /home/pi/ca

# Write a script to the target server to install the certificate
ssh pi@nextcloudpi tee /home/pi/ca/install.sh <<"EOF"
# ----------------- script executed on nextcloudpi -------------------------
TARGET_CERT_FILE=/etc/ssl/certs/nextcloudpi.pem
TARGET_KEY_FILE=/etc/ssl/private/nextcloudpi.key
mv "$1" "$TARGET_KEY_FILE"
mv "$2" "$TARGET_CERT_FILE"
chown root:ssl-cert $TARGET_KEY_FILE
chmod 640 $TARGET_KEY_FILE
sed -i "s_SSLCertificateFile.*_SSLCertificateFile ${TARGET_CERT_FILE}_" /etc/apache2/sites-enabled/001-nextcloud.conf
sed -i "s_SSLCertificateKeyFile.*_SSLCertificateKeyFile ${TARGET_KEY_FILE}_" /etc/apache2/sites-enabled/001-nextcloud.conf
systemctl reload apache2
echo DONE

# -----------------/ script executed on nextcloudpi ------------------------
EOF

scp "$KEY_FILE" "$CERT_FILE" pi@nextcloudpi:/home/pi/ca/
ssh -t pi@nextcloudpi sudo bash "/home/pi/ca/install.sh" "/home/pi/ca/$( basename "$KEY_FILE" )" "/home/pi/ca/$( basename "$CERT_FILE" )"



