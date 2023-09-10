#for proxmox need to on server $: echo -e "overlay\naufs" >> /etc/modules-load.d/modules.conf

sudo yum install epel-release
sudo yum install dnf

sudo yum install git wget nano unzip jq lsof tar -y
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io -y
sudo systemctl start docker
