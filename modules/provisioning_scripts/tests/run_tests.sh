

function test_install() {

  echo "Test installed packages"
  sudo runuser -l $1 -c 'whoami'
  sudo runuser -l $1 -c 'id'
  sudo runuser -l $1 -c 'git --version'
  sudo runuser -l $1 -c 'java -version'
  sudo runuser -l $1 -c 'terraform version'
}