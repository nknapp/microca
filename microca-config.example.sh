# Rename this to "microca-config.sh" and adjust values to your needs

# The ORG of the CA_ROOT and the server certificates
CA_ORG="My organisation"
# The common name used the the CA ROOT
CA_COMMON_NAME="My org CA ROOT"
# Base name of the certificate- and key-file of the CA_ROOT stored under ./root/
CA_ROOT_FILE_PREFIX="ca-root"

deploy_root_cert() {
    # Perform steps to upload the root certificate
    # somethere it can be downloaded by users.
    echo No deployment configured
}
