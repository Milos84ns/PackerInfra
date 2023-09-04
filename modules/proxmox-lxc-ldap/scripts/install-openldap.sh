sudo dnf check-update
sudo dnf upgrade --refresh
sudo dnf install vim cyrus-sasl-devel openssl-devel libdb-devel make libtool autoconf tar gcc perl perl-devel -y

wget -q https://repo.symas.com/configs/SOFL/rhel8/sofl.repo -O /etc/yum.repos.d/sofl.repo

sudo dnf install symas-openldap-clients symas-openldap-servers -y