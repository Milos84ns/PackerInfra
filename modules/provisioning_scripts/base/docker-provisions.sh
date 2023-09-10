#for proxmox need to on server $: echo -e "overlay\naufs" >> /etc/modules-load.d/modules.conf

sudo yum install git wget nano unzip jq lsof tar -y
cd /tmp
wget https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.rpm
sudo rpm -Uvh jdk-20_linux-x64_bin.rpm

sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io -y

sudo systemctl start docker
docker run hello-world