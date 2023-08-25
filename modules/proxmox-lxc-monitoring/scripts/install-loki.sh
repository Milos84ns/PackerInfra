#!/usr/bin/env bash
echo 'Installing Loki...'
cd /tmp
sudo curl -O -L "https://github.com/grafana/loki/releases/download/v2.4.2/loki-linux-amd64.zip"
sudo unzip "loki-linux-amd64.zip"
sudo chmod a+x "loki-linux-amd64"
sudo ./loki-linux-amd64 -config.file=loki-local-config.yaml
sudo cp loki-linux-amd64 /usr/local/bin
ls -l /usr/local/bin/loki-linux-amd64

sudo mkdir /etc/loki
cat <<EOF | sudo tee /etc/loki/loki-local-config.yaml
auth_enabled: true

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 1h       # Any chunk not receiving new logs in this time will be flushed
  max_chunk_age: 1h           # All chunks will be flushed when they hit this age, default is 1h
  chunk_target_size: 1048576  # Loki will attempt to build chunks up to 1.5MB, flushing first if chunk_idle_period or max_chunk_age is reached first
  chunk_retain_period: 30s    # Must be greater than index read cache TTL if using an index cache (Default index read cache TTL is 5m)
  max_transfer_retries: 0     # Chunk transfers disabled

schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: aws
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  aws:
    s3: s3://XXXXX:YYYY@eu-west-1/logs-loki-test

  boltdb_shipper:
    active_index_directory: /loki/boltdb-shipper-active
    cache_location: /loki/boltdb-shipper-cache
    cache_ttl: 24h         # Can be increased for faster performance over longer query periods, uses more disk space
    shared_store: s3

compactor:
  working_directory: /loki/boltdb-shipper-compactor
  shared_store: aws

limits_config:
  reject_old_samples: true
  reject_old_samples_max_age: 168h

chunk_store_config:
  max_look_back_period: 0s

table_manager:
  retention_deletes_enabled: false
  retention_period: 0s

ruler:
  storage:
    type: local
    local:
      directory: /loki/rules
  rule_path: /loki/rules-temp
  alertmanager_url: http://localhost:9093
  ring:
    kvstore:
      store: inmemory
  enable_api: true
EOF

cat <<EOF | sudo tee /etc/systemd/system/loki.service
[Unit]
Description=Loki
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/local/bin/loki-linux-amd64 -config.file=/etc/loki/loki-local-config.yaml

[Install]
WantedBy=multi-user.target
EOF

echo 'Loki installed.'

