echo 'Get and install plugins'

TELMATE_VERSION=2.9.14
cd /tmp/
wget -c https://github.com/Telmate/terraform-provider-proxmox/releases/download/v$TELMATE_VERSION/terraform-provider-proxmox_2.9.14_linux_amd64.zip
mkdir -p $HOME/.terraform.d/plugins/terraform.local/local/proxmox/$TELMATE_VERSION/linux_amd64
unzip -q /tmp/terraform-provider-proxmox_${TELMATE_VERSION}_linux_amd64.zip -d $HOME/.terraform.d/plugins/terraform.local/local/proxmox/$TELMATE_VERSION/linux_amd64

