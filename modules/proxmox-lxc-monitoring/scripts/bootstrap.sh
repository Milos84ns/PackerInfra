#!/usr/bin/env bash
# Start InfluxDB
echo 'Starting InfluxDB.'
sudo systemctl start influxdb
sudo systemctl enable influxdb
sudo firewall-cmd --add-port=8086/tcp --permanent
echo 'Testing Influxdb:'
curl localhost:8086/health

#Start Grafana
echo 'Starting grafana.'
sudo systemctl enable --now grafana-server
sudo systemctl restart grafana-server
sudo firewall-cmd --add-port=3000/tcp --permanent

echo 'Starting Loki'
sudo firewall-cmd --add-port=3100/tcp --permanent
sudo systemctl enable loki
sudo systemctl start loki
sudo firewall-cmd --reload
echo 'Testing Loki:'
sleep 5
curl localhost:3100/ready

echo 'Cleanup...'
rm -f *.zip
rm -f loki-linux-amd64

