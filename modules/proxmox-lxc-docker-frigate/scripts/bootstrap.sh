LOCAL_IP=$(hostname -i)

#start docker
systemctl enable docker
systemctl start docker

#create folders
mkdir -p /opt/frigate/config
mkdir -p /opt/frigate/media
mkdir -p /opt/frigate/db
cd /tmp/
docker load -i frigate.tar

#create yaml
cat <<EOF > /opt/frigate/config/config.yml
database:
  path: /db/frigate.db

mqtt:
  host: mqtt.server.com

cameras:
  test_cam:
    ffmpeg:
      inputs:
        - path: rtsp://test
          roles:
            - detect
    detect:
      width: 1280
      height: 720
EOF

firewall-cmd --permanent --zone=public --add-port=5000/tcp
firewall-cmd --permanent --zone=public --add-port=8554/tcp
firewall-cmd --permanent --zone=public --add-port=8555/tcp
firewall-cmd --permanent --zone=public --add-port=8555/udp
firewall-cmd --reload

docker compose up