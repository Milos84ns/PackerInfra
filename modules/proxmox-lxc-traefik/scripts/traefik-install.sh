#!/usr/bin/env bash
#==============================================================================
# title: traefik-installer.sh
# description: install latest traefik from https://github.com/traefik/traefik
# author: Kawin Viriyaprasopsook <kawin.vir@zercle.tech>
# usage: bash traefik-installer.sh
# notes: need `curl wget tar` package
#==============================================================================
CURRECT_DIR=$(pwd || echo ${PWD})
TEMP_DIR="${CURRECT_DIR}/tmp/"
ACME_EMAIL="acme@your.domain"

if [ "$(whoami)" != "root" ]; then
    SUDO=sudo
fi

# detect system arch
ARCH=$(uname -m)
# Show system arch
echo "System arch ${ARCH}"

case "${ARCH}" in
        i*)
        ARCH=386
        ;;
        x*)
        ARCH=amd64
        ;;
        aarch64)
        ARCH=arm64
        ;;
        armv7l)
        ARCH=armv6
        ;;
	*)
	echo "Not support ${ARCH}"
	exit 1
	;;
esac

# get latest traefik version
TRAEFIK_VERSION=$(curl --silent "https://api.github.com/repos/traefik/traefik/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Make some temporary path
mkdir -p "${TEMP_DIR}"
cd "${TEMP_DIR}" || exit 1

# Get traefik release
wget -q https://github.com/traefik/traefik/releases/download/${TRAEFIK_VERSION}/traefik_${TRAEFIK_VERSION}_linux_${ARCH}.tar.gz

tar -zxvf traefik_${TRAEFIK_VERSION}_linux_${ARCH}.tar.gz
rm -rf traefik_${TRAEFIK_VERSION}_linux_${ARCH}.tar.gz

${SUDO} mv traefik /usr/local/bin/traefik
${SUDO} chmod +x /usr/local/bin/traefik

# Add traefik user space
if ! id -u "traefik" >/dev/null 2>&1; then
  ${SUDO} useradd traefik
fi

# Add config stuff
${SUDO} mkdir -p /etc/traefik/conf.d/
if [ ! -f /etc/traefik/acme.json ]; then
  ${SUDO} touch /etc/traefik/acme.json
fi
${SUDO} chown traefik:traefik /etc/traefik/acme.json
${SUDO} chmod 0600 /etc/traefik/acme.json

# Add file provider
if [ ! -f /etc/traefik/traefik.toml ]; then
${SUDO} tee /etc/traefik/traefik.toml &>/dev/null <<EOF
################################################################
# Global configuration
################################################################
[global]
  checkNewVersion = true

################################################################
# EntryPoints configuration
################################################################
[entryPoints]
  [entryPoints.web-80]
    address = ":80"
  [entryPoints.web-443]
    address = ":443"
  [entryPoints.web-8080]
    address = ":8080"
  [entryPoints.dashboard]
    address = ":8443"
#  [ping]
#    entryPoint = "web-8080"

################################################################
# Traefik logs configuration
################################################################
[log]
  filePath = "/var/log/traefik.log"
  level = "DEBUG"

################################################################
# API and dashboard configuration
################################################################
[api]
  dashboard = true
  insecure = true
[providers]
  [providers.file]
    directory = "/etc/traefik/conf.d"
    watch = true

################################################################
# Certificates configuration
################################################################
[certificatesResolvers]
  [certificatesResolvers.acme-ec256.acme]
#    caServer = "https://acme.zerossl.com/v2/DV90"
    email = "${ACME_EMAIL}"
    storage = "/etc/traefik/acme.json"
    keyType = "EC256"
#    [certificatesResolvers.acme-ec256.acme.eab]
#      kid = ""
#      hmacEncoded = ""
    [certificatesResolvers.acme-ec256.acme.httpChallenge]
      entryPoint = "web-80"
    [certificatesResolvers.acme-ec256.acme.tlsChallenge]
    [certificatesResolvers.acme-ec256.acme.dnsChallenge]
      provider = "cloudflare"
  [certificatesResolvers.acme-rsa4096.acme]
#    caServer = "https://acme.zerossl.com/v2/DV90"
    email = "${ACME_EMAIL}"
    storage = "/etc/traefik/acme.json"
    keyType = "RSA4096"
#    [certificatesResolvers.acme-rsa4096.acme.eab]
#      kid = ""
#      hmacEncoded = ""
    [certificatesResolvers.acme-rsa4096.acme.httpChallenge]
      entryPoint = "web-80"
    [certificatesResolvers.acme-rsa4096.acme.tlsChallenge]
    [certificatesResolvers.acme-rsa4096.acme.dnsChallenge]
      provider = "cloudflare"
[tls.options]
  [tls.options.default]
    minVersion = "VersionTLS12"
EOF
fi

# Add log files
if [ ! -f /var/log/traefik.log ]; then
touch /var/log/traefik.log
chown traefik /var/log/traefik.log
fi

# Add systemd service
if [ ! -f /lib/systemd/system/traefik.service ]; then
${SUDO} tee /lib/systemd/system/traefik.service &>/dev/null <<EOF
[Unit]
Description=Traefik
Documentation=https://doc.traefik.io/traefik/
After=network-online.target
AssertFileIsExecutable=/usr/local/bin/traefik
AssertPathExists=/etc/traefik/traefik.toml

[Service]
# Run traefik as its own user (create new user with: useradd -r -s /bin/false -U -M traefik)
User=traefik
AmbientCapabilities=CAP_NET_BIND_SERVICE

# configure service behavior
Type=notify
ExecStart=/usr/local/bin/traefik --configFile=/etc/traefik/traefik.toml
Restart=always
WatchdogSec=1s

# lock down system access
# prohibit any operating system and configuration modification
ProtectSystem=strict
# create separate, new (and empty) /tmp and /var/tmp filesystems
PrivateTmp=true
# make /home directories inaccessible
ProtectHome=true
# turns off access to physical devices (/dev/...)
PrivateDevices=true
# make kernel settings (procfs and sysfs) read-only
ProtectKernelTunables=true
# make cgroups /sys/fs/cgroup read-only
ProtectControlGroups=true

# allow writing of acme.json
ReadWritePaths=/etc/traefik/acme.json
# depending on log and entrypoint configuration, you may need to allow writing to other paths, too

# limit number of processes in this unit
#LimitNPROC=1

[Install]
WantedBy=multi-user.target
EOF
fi

${SUDO} systemctl daemon-reload
${SUDO} systemctl enable traefik
${SUDO} systemctl restart traefik
sleep 4
${SUDO} systemctl status traefik