#!/usr/bin/env bash

echo 'Installing Grafana....'
cat <<EOF | sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=0
gpgkey=https://packages.grafana.com/gpg.key
sslverify=0
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

cat <<EOF | sudo tee /etc/grafana/grafana.ini
[server]

# The IP address to bind to, empty will bind to all interfaces
http_addr = 0.0.0.0

# The http port  to use
http_port = 3000

# The public facing domain name used to access grafana from a browser
domain = grafana.example.io
EOF

sudo dnf install grafana -y
echo 'Grafana installed.'