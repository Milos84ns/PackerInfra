mkdir -p /opt/code-server/workspaces

cat <<EOF > /usr/lib/systemd/system/code-server.service
[Unit]
Description=Code-Server Service
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
Environment=PASSWORD=codeserver
ExecStart=code-server --port 8080 --host 0.0.0.0 --user-data-dir /opt/code-server/workspaces --auth password

ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl start code-server
sudo systemctl enable code-server

firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --reload
