#!/bin/sh
set -e
NEWUSR=$root_user
PASSWD=$root_pass

echo "Wait for 5 seconds to get IP address..."
sleep 5 # necessary to get IP address otherwise it can't get packages
sudo yum update -y
sudo yum install git wget nano unzip jq lsof firewalld tar -y
sudo yum install NetworkManager -y

cd /tmp
wget https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.rpm
sudo rpm -Uvh jdk-20_linux-x64_bin.rpm

sudo dnf install openssh-server -y
sudo systemctl enable sshd --now
sudo systemctl start sshd
