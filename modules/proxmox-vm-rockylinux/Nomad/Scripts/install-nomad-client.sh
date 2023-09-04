# Packages required for nomad & consul
LOCAL_IP=$(hostname -i)
SERVER_IP=$1
CLIENT_NAME=$2

directory_setup() {
  sudo mkdir -pm 0750 /etc/${1}.d /var/lib/${1} /opt/${1}/data
  sudo mkdir -pm 0700 /etc/${1}.d/tls
  sudo chown -R ${2}:${2} /etc/${1}.d /opt/${1}/data
}

directory_setup nomad nomad

#!! Client needs to run as root !!#
cat <<EOF > /opt/nomad/client.hcl
 # Increase log verbosity
 log_level = "DEBUG"

bind_addr = "$LOCAL_IP" # "0.0.0.0" # the default

 # Setup data dir
 data_dir = "/opt/nomad/data"

 # Give the agent a unique name. Defaults to hostname
 name = "$CLIENT_NAME"

 # Enable the server
client {
  enabled       = true
  servers = ["$SERVER_IP"]
  network_interface = "eth0"

  options {
          "driver.allowlist" = "exec,java,raw_exec"
        }
          chroot_env {
          "/bin" = "/bin"
          "/etc" = "/etc"
          "/lib" = "/lib"
          "/lib32" = "/lib32"
          "/lib64" = "/lib64"
          "/run/resolvconf" = "/run/resolvconf"
         "/sbin" = "/sbin"
          "/usr" = "/usr"
         "/apps/bin/java/" = "/apps/bin/java/"
          }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}
EOF

# Setup Service as Server
(
cat <<-EOF
 [Unit]
 Description=Nomad
 Wants=network-online.target

 [Service]
 # Nomad server should be run as the nomad user. Nomad Clients as root
 User=root
 Group=root

 ExecReload=/bin/kill -HUP $MAINPID
 ExecStart=nomad agent -config /opt/nomad/client.hcl
 KillMode=process
 KillSignal=SIGINT
 LimitNOFILE=65536
 LimitNPROC=infinity
 Restart=on-failure
 RestartSec=2

 [Install]
 WantedBy=multi-user.target
EOF
)  | sudo tee /etc/systemd/system/nomad.service

sudo systemctl enable nomad.service
sudo systemctl start nomad
#nomad -autocomplete-install

echo "Nomad UI at http://${LOCAL_IP}:4646"

sudo firewall-cmd --add-port=4646/tcp --permanent
sudo firewall-cmd --add-port=4647/tcp --permanent
firewall-cmd --reload