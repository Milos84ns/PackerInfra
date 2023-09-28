#!/usr/bin/env bash

mkdir -p /opt/StaticWebServer/config
mkdir -p /opt/files


cat <<EOF > /opt/StaticWebServer/config/config.toml
[general]

#### Address & Root dir
host = "::"
port = 8787
root = "/opt/files/"

#### Logging
log-level = "error"

#### Cache Control headers
cache-control-headers = true

#### Auto Compression
compression = true

#### Error pages
page404 = "./public/404.html"
page50x = "./public/50x.html"

#### HTTP/2 + TLS
http2 = false
http2-tls-cert = ""
http2-tls-key = ""
https-redirect = false
https-redirect-host = "localhost"
https-redirect-from-port = 80
https-redirect-from-hosts = "localhost"

#### CORS & Security headers
# security-headers = true
# cors-allow-origins = ""

#### Directory listing
directory-listing = true

#### Directory listing sorting code
directory-listing-order = 1

#### Directory listing content format
directory-listing-format = "html"

#### Basic Authentication
# basic-auth = ""

#### File descriptor binding
# fd = ""

#### Worker threads
threads-multiplier = 1

#### Grace period after a graceful shutdown
grace-period = 0

#### Page fallback for 404s
# page-fallback = ""

#### Log request Remote Address if available
log-remote-address = false

#### Redirect to trailing slash in the requested directory uri
redirect-trailing-slash = true

#### Check for existing pre-compressed files
compression-static = true

#### Health-check endpoint (GET or HEAD `/health`)
health = false

### Windows Only

#### Run the web server as a Windows Service
# windows-service = false


[advanced]

#### HTTP Headers customization (examples only)

#### a. Oneline version
# [[advanced.headers]]
# source = "**/*.{js,css}"
# headers = { Access-Control-Allow-Origin = "*" }

#### b. Multiline version
# [[advanced.headers]]
# source = "/index.html"
# [advanced.headers.headers]
# Cache-Control = "public, max-age=36000"
# Content-Security-Policy = "frame-ancestors 'self'"
# Strict-Transport-Security = "max-age=63072000; includeSubDomains; preload"

#### c. Multiline version with explicit key (dotted)
# [[advanced.headers]]
# source = "**/*.{jpg,jpeg,png,ico,gif}"
# headers.Strict-Transport-Security = "max-age=63072000; includeSubDomains; preload"


### URL Redirects (examples only)

# [[advanced.redirects]]
# source = "**/*.{jpg,jpeg}"
# destination = "/images/generic1.png"
# kind = 301

# [[advanced.redirects]]
# source = "/index.html"
# destination = "https://static-web-server.net"
# kind = 302

### URL Rewrites (examples only)

# [[advanced.rewrites]]
# source = "**/*.{png,ico,gif}"
# destination = "/assets/favicon.ico"

# [[advanced.rewrites]]
# source = "**/*.{jpg,jpeg}"
# destination = "/images/sws.png"
EOF


cat <<EOF > /usr/lib/systemd/system/webserver.service
[Unit]
Description=Static Web Server Service
Requires=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Restart=on-failure
ExecStart=static-web-server -w /opt/StaticWebServer/config/config.toml
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl start webserver
sudo systemctl enable webserver

firewall-cmd --permanent --zone=public --add-port=8787/tcp
firewall-cmd --reload

