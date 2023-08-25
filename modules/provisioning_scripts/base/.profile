umask 027

export BOX_LOCATION=srb
export BOX_SITE=LOH
export BOX_REGION=emea
export BOX_ZONE=DRN
export BOX_USER=$USER


###############################
## Common Variables
###############################

export BOX_HOME=/opt/main
export BOX_UTILITIES=$BOX_HOME/utilities
export BOX_APPS=$BOX_HOME/apps
export BOX_COMMON=$BOX_HOME/apps/common
export BOX_LOG=$BOX_HOME/log

export BOX_ARCHIVES=$BOX_COMMON/archives
export BOX_BIN=$BOX_COMMON/bin
export BOX_CFG=$BOX_COMMON/cfg
export BOX_DATA=$BOX_COMMON/data
export BOX_ROLLBACK=$BOX_COMMON/BOX_rollback
export BOX_EXPORT=$BOX_COMMON/export
export BOX_IMPORT=$BOX_COMMON/import
export BOX_LIB=$BOX_COMMON/lib
export BOX_PROFILE=$BOX_COMMON/profile
export BOX_SECURITY=$BOX_COMMON/security
export BOX_SECURITY_CERTS=$BOX_SECURITY/certs
export BOX_SCHEDULED_JOBS=$BOX_COMMON/scheduled-job
export BOX_TEMP=$BOX_COMMON/tmp

export JAVA_HOME=$BOX_APPS/java
export JDK_11_X64=$JAVA_HOME
# Workaround until all JDK14 references are changed to JDK11
export JDK_14_X64=$JDK_11_X64
export PATH=/usr/bin:/bin:/usr/sbin:/sbin/opt:/ssh/bin:/usr/sfw/bin:/ur/local/bin:$BOX_BIN:${JAVA_HOME}/bin

export HOST=`hostname | tr '[A-Z]' '[a-z]'`

###########################################
## User Aliases
###################################

alias services=". $BOX_BIN/all_service.ksh"
alias log='cd $BOX_LOG/$BOX_LOCATION'
alias apps='cd $BOX_APPS'
alias lps='ps -auxww | grep -v grep | grep'
alias ll="ls -al"
alias lt="ls -latr"
alias cfg='cd $BOX_CFG'

# Manuals all link /usr/share/man
export MANPATH=/usr/share/man:/usr/per15/man:$RET_HOME/man:/usr/openwin/share/man

# new env variable for BOX_DNSNAME, this is the ITID DNS name for a box e.g.
export BOX_DNS_ALIAS=$HOST.site.com
export MASTER_LOCATOR=HASHIBOX



