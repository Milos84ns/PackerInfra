

function install_terraform_provider() {
  local terraform_provider_home=/usr/share//terraform/providers/registry.terraform.io/hashicorp
  sudo rm -rf $terraform_provider_home
  sudo mkdir $terraform_provider_home
}
function main(){

  echo 'Done'
}

main