#!/usr/bin/env bash
set -e

# Setup Welcome Banner
JDK_VERSION=$(java -version 2>&1 | grep version | awk '{print $3}')
MVN_VERSION=$(mvn -version | grep Apache | awk '{print $3}')
echo '
      ___           ___                       ___                     ___
     /  /\         /  /\          ___        /  /\      ___          /  /\
    /  /::\       /  /::\        /  /\      /  /::\    /  /\        /  /:/_
   /  /:/\:\     /  /:/\:\      /  /:/     /  /:/\:\  /  /:/       /  /:/ /\
  /  /:/~/::\   /  /:/~/:/     /  /:/     /  /:/~/:/ /__/::\      /  /:/ /:/_
 /__/:/ /:/\:\ /__/:/ /:/___  /  /::\    /__/:/ /:/  \__\/\:\__  /__/:/ /:/ /\
 \  \:\/:/__\/ \  \:\/:::::/ /__/:/\:\   \  \:\/:/      \  \:\/\ \  \:\/:/ /:/
  \  \::/       \  \::/~~~~  \__\/  \:\   \  \::/        \__\::/  \  \::/ /:/
   \  \:\        \  \:\           \  \:\   \  \:\        /__/:/    \  \:\/:/
    \  \:\        \  \:\           \__\/    \  \:\       \__\/      \  \::/
     \__\/         \__\/                     \__\/                   \__\/
                                                                                                        MS 2023
' >> /etc/motd
(
cat <<-EOF

Java Development Kit version ${JDK_VERSION}
Maven Version ${MVN_VERSION}
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

# add line to add banner
(
 cat <<-EOF
Banner /etc/mybanner
EOF
) | sudo tee -a /etc/ssh/sshd_config