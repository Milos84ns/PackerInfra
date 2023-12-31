packer {
  required_plugins {
    lxc = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/lxc"
    }
  }
}

locals {
  output_directory = "/tmp/lxc/build/${var.application}/${var.distribution}/${var.os_version}/${var.arch}/${var.image_version}"
  timestamp_date = "${formatdate("YYMMDD",timestamp())}"
  timestamp_time = "${formatdate("hhmmss",timestamp())}"
  box_user = "hashibox"
  box_group = "hashigroup"
}

source "lxc" "container" {
  config_file      = "/etc/lxc/default.conf"
  template_name    = "download"
  output_directory = "${local.output_directory}"
  container_name   = "${var.application}-${var.app_version}-${var.distribution}-${var.os_version}-${var.arch}-${var.image_version}"

  template_parameters = [
    "-d", "${var.distribution}",
    "-r", "${var.os_version}",
    "-a", "${var.arch}"
  ]
}

#
# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
#
build {
  name    = "${local.timestamp_date}${local.timestamp_time}-${var.application}-${var.distribution}-${var.os_version}-${var.arch}"
  sources = ["source.lxc.container"]

  #provision packages wget git nano unzip
  provisioner "shell" {
    script = "${path.root}/../provisioning_scripts/${var.distribution}/base/provision-basic.sh"
  }

  ############################################ Scripts to Install packages #############################################


  provisioner "shell" {
    script = "${path.root}/../provisioning_scripts/apps/install-rust-fileserver.sh"
  }

  provisioner "file" {
    source = "${path.root}/scripts/bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }


  ########################################### Post process scripts #####################################################
  post-processors {
    #
    # Fix the rootfs issue, re-archive the thing with proper directory structure
    #
    post-processor "shell-local" {
      script = "${path.root}/../provisioning_scripts/base/post-processor-rearchive.sh"

      env = {
        OUTPUT_DIRECTORY = local.output_directory
        BUILD_NAME       = build.name
        IMAGE_DIRECTORY  = var.image_directory
      }
    }

    #
    # The new tgz file is now the actual artifact and we can nuke the previous old 'rootfs.tar.gz'
    #
    post-processor "artifice" { # tell packer this is now the new artifact
      files = ["${var.image_directory}/${build.name}"]
    }

    #
    # Clean up the original 'rootfs.tar.gz' artifact that's no longer needed
    #
    post-processor "shell-local" {
      script = "${path.root}/../provisioning_scripts/base/post-processor-clean.sh"

      env = {
        OUTPUT_DIRECTORY = local.output_directory
      }
    }
  }
}
