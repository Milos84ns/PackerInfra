sudo dnf check-update

sudo dnf install dnf-utils

#wget https://go.dev/dl/go1.19.5.linux-amd64.tar.gz
#
#tar -zxvf go1.19.5.linux-amd64.tar.gz -C /usr/local
#
#echo 'export GOROOT=/usr/local/go' | tee -a /etc/profile
#echo 'export PATH=$PATH:/usr/local/go/bin' | tee -a /etc/profile
#
#source /etc/profile
#
#go version
#
cd /opt

git clone https://github.com/ggerganov/llama.cpp.git ~/llama.cpp

git clone https://github.com/ggerganov/llama.cpp.git

go generate ./...

go build .