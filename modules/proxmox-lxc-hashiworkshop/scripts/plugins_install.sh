echo 'Get and install plugins'

# Terraform plugins example
curl -s --netrc -o /tmp/terraform-provider-template_${TF_TEMPLATE_VER}_linux_amd64.zip https://<wherever_zip_file_is>
mkdir -p $HOME/.terraform.d/plugins/registry.terraform.io/hashicorp/template/${TF_TEMPLATE_VER}/linux_amd64
unzip -q /tmp/terraform-provider-template_${TF_TEMPLATE_VER}_linux_amd64.zip -d $HOME/.terraform.d/plugins/registry.terraform.io/hashicorp/template/${TF_TEMPLATE_VER}/linux_amd64

