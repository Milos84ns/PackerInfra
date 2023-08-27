#!/bin/sh
set -euxo pipefail
#NOMAD_VERSION=1.6.1
# Create Prerequisites
echo "Creating System Prerequisites"

echo "Adding Nomad system users"
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
create_ids nomad
# Install Nomad
# Update variables above to manage version, OSS/Ent, and platform
export NOMAD_ARCHIVE="nomad_${NOMAD_VERSION}_linux_amd64.zip"
echo "Installing Nomad "
curl --silent -Lo /tmp/${NOMAD_ARCHIVE} https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/${NOMAD_ARCHIVE}
sudo unzip -d /usr/local/bin /tmp/${NOMAD_ARCHIVE}
rm -f /tmp/${NOMAD_ARCHIVE}
nomad -version