#Simple bootstrap for testing

REPOSILITE_VERSION=3.4.8

mkdir -p /opt/repo/workspaces
TOKEN=$(openssl rand -base64 14)
export ROOT_TOKEN=$TOKEN


cat <<EOF > /usr/lib/systemd/system/reposilite.service
[Unit]
Description=Reposilite Service
Requires=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Restart=on-failure
ExecStart=java -Xmx128M -jar /opt/reposilite/reposilite-$REPOSILITE_VERSION-all.jar --token root:$TOKEN
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl start reposilite
sudo systemctl enable reposilite

firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --reload

(
cat <<-EOF

Reposilite $REPOSILITE_VERSION server started at: http://localhost:8080
EOF
)  | sudo tee -a /etc/motd

cat
