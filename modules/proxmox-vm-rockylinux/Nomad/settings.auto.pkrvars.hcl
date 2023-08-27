distribution      = "rockylinux"
arch              = "amd64"
os_version        = "9"
image_version     = "1.0.2"
app_version       = "1.16.0"
#image_directory   = "/home/milos/Downloads/"
dns_search_domain = "search example.com"
dns_1             = "192.168.0.1"
dns_2             = "192.168.1.1"
application       = "Nomad"
template_name     = "Nomad"


# see */build.pkr.hcl for a full list of possible variable values to override here
consul_version = "1.15.3"
nomad_version = "1.6.1"

