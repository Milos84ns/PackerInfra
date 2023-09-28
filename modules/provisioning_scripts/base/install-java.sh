cd /tmp
wget https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.rpm
sudo rpm -Uvh jdk-20_linux-x64_bin.rpm
rm -f jdk-20_linux-x64_bin.rpm

sudo yum install maven -y
