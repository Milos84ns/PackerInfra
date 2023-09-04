LDAP_SERVER_VERSION=2.6.2-3

sudo dnf check-update
sudo dnf upgrade --refresh
sudo dnf config-manager --set-enabled crb
sudo dnf install dnf-utils epel-release mod_ssl

sudo yum -y update
sudo dnf -y install openldap openldap-clients #openldap-servers
#
#cd /tmp
#wget https://dl.rockylinux.org/pub/rocky/9/plus/x86_64/os/Packages/o/openldap-servers-2.6.2-3.el9.x86_64.rpm
#sudo rpm -i openldap-servers-2.6.2-3.el9.x86_64.rpm

