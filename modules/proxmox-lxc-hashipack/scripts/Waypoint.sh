#!/bin/sh
set -euxo pipefail
#WAYPOINT_VERSION=0.11.4
# Create Prerequisites
echo "Creating System Prerequisites"

echo "Adding Waypoint system users"
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
create_ids waypoint
# Install Vault
# Update variables above to manage version, OSS/Ent, and platform
export WAYPOINT_ARCHIVE="waypoint_${WAYPOINT_VERSION}_linux_amd64.zip"
echo "Installing Waypoint "
curl --silent -Lo /tmp/${WAYPOINT_ARCHIVE} https://releases.hashicorp.com/waypoint/${WAYPOINT_VERSION}/${WAYPOINT_ARCHIVE}
sudo unzip -d /usr/local/bin /tmp/${WAYPOINT_ARCHIVE}
rm -f /tmp/${WAYPOINT_ARCHIVE}
waypoint -version