echo 'Installing cmake,gcc,make,curl,clang'
sudo dnf install cmake gcc make curl clang -y

cd /tmp
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rust-init.sh
sh rust-init.sh -y