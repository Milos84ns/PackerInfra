#Simple bootstrap for testing
ARTPIE_VERSION=v0.30.1

mkdir -p /opt/repo/workspaces
TOKEN=$(openssl rand -base64 14)
export ROOT_TOKEN=$TOKEN


cat <<EOF > /usr/lib/systemd/system/artpie.service
[Unit]
Description=Artpie Service
Requires=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Restart=on-failure
ExecStart=java -Xmx128M -jar /opt/artpie/artipie-$ARTPIE_VERSION-jar-with-dependencies.jar --token root:$TOKEN
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl start artpie
sudo systemctl enable artpie

firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --permanent --zone=public --add-port=8086/tcp
firewall-cmd --reload

(
cat <<-EOF

Artpie $ARTPIE_VERSION server started at: http://localhost:8080
EOF
)  | sudo tee -a /etc/motd

cat
