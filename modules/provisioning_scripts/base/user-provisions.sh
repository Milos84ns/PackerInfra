set -e

echo Setting up Users and Groups

APP_GROUP=$group
APP_GROUP_ID=40187
APP_USER=$user
APP_USER_ID=20426
BOX_HOME=/opt/main
BOX_THIRDPARTY=$BOX_HOME/thirdparty

echo "Creating user: $user and group:$group"
mkdir -p $BOX_HOME
groupadd -g "$APP_GROUP_ID" "$APP_GROUP"
useradd -s /bin/bash -m "$APP_USER" -u "$APP_USER_ID" -d /home/"$APP_USER" -G "$APP_GROUP"

cd /tmp
cp .profile ~/.bash_profile
cp .profile /home/"$APP_USER"/.bash_profile

. ~/.bash_profile # reload variables

env

echo "Creating ENV folders..."
mkdir -p "$BOX_THIRDPARTY"
mkdir -p "$BOX_UTILITIES"
mkdir -p "$BOX_APPS"
mkdir -p "$BOX_COMMON"
mkdir -p "$BOX_LOG"
mkdir -p "$BOX_BIN"
mkdir -p "$BOX_CFG"
mkdir -p "$BOX_DATA"
mkdir -p "$BOX_ROLLBACK"
mkdir -p "$BOX_EXPORT"
mkdir -p "$BOX_IMPORT"
mkdir -p "$BOX_LIB"
mkdir -p "$BOX_PROFILE"
mkdir -p "$BOX_SECURITY"
mkdir -p "$BOX_SECURITY_CERTS"
mkdir -p "$BOX_TEMP"

echo "Change ownerwship..."
chown -R "$APP_USER" $BOX_HOME
chgrp -R "$APP_GROUP" $BOX_HOME
echo Setup Users and Groups complete


