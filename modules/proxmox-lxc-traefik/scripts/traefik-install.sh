sudo dnf check-update
sudo dnf install dnf-utils
sudo dnf install epel-release

sudo yum update -y
sudo yum install snap -y

sudo systemctl enable --now snapd.socket

sudo systemctl start --now snapd.socket
sudo systemctl status snapd.socket

sudo ln -s /var/lib/snapd/snap /snap
snap