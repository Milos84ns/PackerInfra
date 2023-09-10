#!/bin/sh
set -e
NEWUSR=$root_user
PASSWD=$root_pass

echo "Wait for 5 seconds to get IP address..."
sleep 5 # necessary to get IP address otherwise it can't get packages
sudo yum update -y
sudo yum install git wget nano unzip jq lsof firewalld tar -y
sudo yum install epel-release -y
sudo yum install dnf -y
sudo yum install NetworkManager -y
sudo dnf install openssh-server -y
sudo systemctl enable sshd --now
sudo systemctl start sshd

#create new user
echo Create localadmin user for ssh
sudo useradd -G wheel -c "Provision user" $NEWUSR
sudo echo "$NEWUSR:$PASSWD" | chpasswd
sudo usermod -a -G root $NEWUSR



