#!/usr/bin/env bash

echo 'Installing Influxdb2...'

cat <<EOF | sudo tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = influxdb Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 0
gpgkey = https://repos.influxdata.com/influxdb.key
EOF

sudo dnf install influxdb2 -y
echo 'Influxdb2 installed.'