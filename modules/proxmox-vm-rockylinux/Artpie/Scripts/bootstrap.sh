#Simple bootstrap for testing
ARTPIE_VERSION=v0.30.1

mkdir -p /opt/repo/workspaces
TOKEN=$(openssl rand -base64 14)
export ROOT_TOKEN=$TOKEN

export ARTIPIE_USER_NAME=artipie
export ARTIPIE_USER_PASS=qwerty

#need to remove selinux otherwise service wont work
grubby --update-kernel ALL --args selinux=0


cat <<EOF > /usr/lib/systemd/system/artpie.service
[Unit]
Description=Artpie Service
Requires=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Restart=on-failure
ExecStart=java -Xmx128M -jar /opt/artpie/artipie-$ARTPIE_VERSION-jar-with-dependencies.jar --config-file=/opt/artpie/config/main-config.yaml --port=8085 --api-port=8086
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl start artpie
sudo systemctl enable artpie

firewall-cmd --permanent --zone=public --add-port=8085/tcp
firewall-cmd --permanent --zone=public --add-port=8086/tcp
firewall-cmd --reload

(
cat <<-EOF

Artpie $ARTPIE_VERSION server started at: http://localhost:8080
EOF
)  | sudo tee -a /etc/motd

cat

reboot