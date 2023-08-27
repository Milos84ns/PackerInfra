#!/bin/sh
set -euxo pipefail
#VAULT_VERSION=1.8.2
# Create Prerequisites
echo "Creating System Prerequisites"

echo "Adding Vault system users"
create_ids() {
  sudo /usr/sbin/groupadd --force --system ${1}
  if ! getent passwd ${1} >/dev/null ; then
    sudo /usr/sbin/adduser \
      --system \
      --gid ${1} \
      --home /srv/${1} \
      --no-create-home \
      --comment "${1} account" \
      --shell /bin/false \
      ${1}  >/dev/null
  fi
}
create_ids vault
# Install Vault
# Update variables above to manage version, OSS/Ent, and platform
export VAULT_ARCHIVE="vault_${VAULT_VERSION}_linux_amd64.zip"
echo "Installing Vault "
curl --silent -Lo /tmp/${VAULT_ARCHIVE} https://releases.hashicorp.com/vault/${VAULT_VERSION}/${VAULT_ARCHIVE}
sudo unzip -d /usr/local/bin /tmp/${VAULT_ARCHIVE}
rm -f /tmp/${VAULT_ARCHIVE}
vault -version