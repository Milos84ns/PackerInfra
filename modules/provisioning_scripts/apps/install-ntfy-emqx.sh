
cd /tmp
wget -c https://github.com/binwiederhier/ntfy/releases/download/v2.7.0/ntfy_2.7.0_linux_amd64.rpm
echo 'Install Ntfy.sh'
sudo rpm -i ntfy_2.7.0_linux_amd64.rpm
echo 'Install EMQX'
wget -c https://www.emqx.com/en/downloads/broker/5.0.26/emqx-5.0.26-el8-amd64.rpm
sudo yum install emqx-5.0.26-el8-amd64.rpm -y
