systemctl enable docker
systemctl start docker

cd /tmp
unzip zoneminder.zip
tar -cC 'zoneminder' . | docker load

mkdir -p /opt/zoneminder/config
mkdir -p /opt/zoneminder/data

firewall-cmd --permanent --zone=public --add-port=9000/tcp
firewall-cmd --permanent --zone=public --add-port=8443/tcp
firewall-cmd --reload

docker compose up