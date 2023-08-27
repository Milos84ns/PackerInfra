#!/bin/sh

echo 'Install portainer'

mkdir -p /opt/portainer
mkdir -p /opt/portainer/data

docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /opt/portainer/data:/data portainer/portainer-ce:latest