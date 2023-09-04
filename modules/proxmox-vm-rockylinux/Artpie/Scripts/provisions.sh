#!/bin/sh
set -e
NEWUSR=$root_user
PASSWD=$root_pass
ARTPIE_VERSION=v0.30.1

echo "Wait for 5 seconds to get IP address..."
sleep 5 # necessary to get IP address otherwise it can't get packages
sudo yum update -y
sudo yum install git wget nano unzip jq lsof firewalld tar -y
sudo yum install NetworkManager -y

cd /tmp
wget https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.rpm
sudo rpm -Uvh jdk-20_linux-x64_bin.rpm
sudo yum install maven -y

sudo dnf install openssh-server -y
sudo systemctl enable sshd --now
sudo systemctl start sshd

mkdir -p /opt/artpie
mkdir -p /opt/artpie/config
mkdir -p /opt/artpie/data
mkdir -p /opt/artpie/images
mkdir -p /opt/artpie/security

cat <<EOF > /opt/artpie/config/main-config.yaml
meta:
  storage:
    type: fs
    path: /opt/artipie/config

  credentials:
    - type: env

  policy:
    type: artipie
    storage:
      type: fs
      path: /opt/artpie/security
EOF

cat <<EOF > /opt/artpie/config/my-maven.yaml
repo:
 type: maven-proxy
 remotes:
  - url: https://repo.maven.apache.org/maven2
    cache:
     storage:
      type: fs
      path: /opt/artpie/data
EOF

cat <<EOF > /opt/artpie/config/my-docker.yaml
epo:
  type: docker
  storage:
    type: fs   #type = FileStorage
    path: /var/artipie/images #place where the data will be stored
EOF


cd /opt/artpie
wget -c https://github.com/artipie/artipie/releases/download/$ARTPIE_VERSION/artipie-$ARTPIE_VERSION-jar-with-dependencies.jar
