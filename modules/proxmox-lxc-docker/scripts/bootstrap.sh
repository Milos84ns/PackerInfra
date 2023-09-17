systemctl enable docker
systemctl start docker

docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

firewall-cmd --permanent --zone=public --add-port=8000/tcp
firewall-cmd --permanent --zone=public --add-port=9443/tcp
firewall-cmd --reload