#!/usr/bin/env bash
set -e

# Setup Welcome Banner
PACKER_VERSION=$(packer -version)
TERRAFORM_VERSION=$(terraform -version | grep v | awk '{print $2}')
JDK_VERSION=$(java -version 2>&1 | grep version | awk '{print $3}')
MVN_VERSION=$(mvn -version | grep Apache | awk '{print $3}')
CODE_SERVER_VERSION=$(code-server -v | awk '{print $5}')
echo '
      ___           ___           ___           ___           ___           ___           ___           ___
     /__/\         /  /\         /  /\         /__/|         /  /\         /__/\         /  /\         /  /\
    _\_ \:\       /  /::\       /  /::\       |  |:|        /  /:/_        \  \:\       /  /::\       /  /::\
   /__/\ \:\     /  /:/\:\     /  /:/\:\      |  |:|       /  /:/ /\        \__\:\     /  /:/\:\     /  /:/\:\
  _\_ \:\ \:\   /  /:/  \:\   /  /:/~/:/    __|  |:|      /  /:/ /::\   ___ /  /::\   /  /:/  \:\   /  /:/~/:/
 /__/\ \:\ \:\ /__/:/ \__\:\ /__/:/ /:/___ /__/\_|:|____ /__/:/ /:/\:\ /__/\  /:/\:\ /__/:/ \__\:\ /__/:/ /:/
 \  \:\ \:\/:/ \  \:\ /  /:/ \  \:\/:::::/ \  \:\/:::::/ \  \:\/:/~/:/ \  \:\/:/__\/ \  \:\ /  /:/ \  \:\/:/
  \  \:\ \::/   \  \:\  /:/   \  \::/~~~~   \  \::/~~~~   \  \::/ /:/   \  \::/       \  \:\  /:/   \  \::/
   \  \:\/:/     \  \:\/:/     \  \:\        \  \:\        \__\/ /:/     \  \:\        \  \:\/:/     \  \:\
    \  \::/       \  \::/       \  \:\        \  \:\         /__/:/       \  \:\        \  \::/       \  \:\
     \__\/         \__\/         \__\/         \__\/         \__\/         \__\/         \__\/         \__\/
                                                                                                        MS 2023
' >> /etc/motd
(
cat <<-EOF

Packer version ${PACKER_VERSION}
Terraform Version ${TERRAFORM_VERSION}
Java Development Kit version ${JDK_VERSION}
Maven Version ${MVN_VERSION}
Code Sever version ${CODE_SERVER_VERSION}
EOF
)  | sudo tee -a /etc/motd

# Setup Warning Banner
echo '
*******************************************************************************
*                                                                             *
*                   Welcome to MyCompany Secure Linux Server                  *
*                                                                             *
*  Unauthorized access to this system is strictly prohibited. By accessing    *
*  this system, you agree to comply with all applicable policies and          *
*  regulations. Any violation may result in legal action.                     *
*                                                                  MS 2023    *
*******************************************************************************

' >> /etc/mybanner
