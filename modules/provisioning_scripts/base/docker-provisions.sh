#for proxmox need to on server $: echo -e "overlay\naufs" >> /etc/modules-load.d/modules.conf

sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io -y

#DOCKER_CONFIG_PATH='/etc/docker/daemon.json'
#mkdir -p $(dirname $DOCKER_CONFIG_PATH)
#
#VER=$(curl -s https://api.github.com/repos/containers/fuse-overlayfs/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3) }')
#echo $VER
#cd /tmp
#wget -c https://github.com/containers/fuse-overlayfs/releases/download/$VER/fuse-overlayfs-x86_64
#mv fuse-overlayfs-x86_64 /usr/local/bin/fuse-overlayfs
#chmod 755 /usr/local/bin/fuse-overlayfs
#echo -e '{\n  "storage-driver": "fuse-overlayfs",\n  "log-driver": "journald"\n}' > /etc/docker/daemon.json
#echo 'Done'
