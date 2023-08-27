#!/bin/sh
set -euxo pipefail
#CONSUL_VERSION=1.15.3
# Create Prerequisites
echo "Creating System Prerequisites"

echo "Adding Consul system users"
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
create_ids consul
# Install consul
# Update variables above to manage version, OSS/Ent, and platform
export CONSUL_ARCHIVE="consul_${CONSUL_VERSION}_linux_amd64.zip"
echo "Installing Consul "
curl --silent -Lo /tmp/${CONSUL_ARCHIVE} https://releases.hashicorp.com/consul/${CONSUL_VERSION}/${CONSUL_ARCHIVE}
sudo unzip -d /usr/local/bin /tmp/${CONSUL_ARCHIVE}
rm -f /tmp/${CONSUL_ARCHIVE}
consul -version
