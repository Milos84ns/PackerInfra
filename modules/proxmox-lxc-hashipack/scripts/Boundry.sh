#!/bin/sh
set -euxo pipefail
#BOUNDARY_VERSION=0.13.1
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
create_ids boundary
# Install Boundary
# Update variables above to manage version, OSS/Ent, and platform
export BOUNDARY_ARCHIVE="boundary_${BOUNDARY_VERSION}_linux_amd64.zip"
echo "Installing Boundary"
curl --silent -Lo /tmp/${BOUNDARY_ARCHIVE} https://releases.hashicorp.com/boundary/${BOUNDARY_VERSION}/${BOUNDARY_ARCHIVE}
sudo unzip -d /usr/local/bin /tmp/${BOUNDARY_ARCHIVE}
rm -f /tmp/${BOUNDARY_ARCHIVE}
boundary -version