#!/bin/zsh

########################################################################
#              Huawei Mobile Broadband Service - postinstall           #
#################### Written by Phil Walker Oct 2020 ###################
########################################################################

# Load the launch daemon
if [[ -f "/Library/LaunchDaemons/com.huawei.mbbservice.plist" ]]; then
    /bin/launchctl load "/Library/LaunchDaemons/com.huawei.mbbservice.plist"
    echo "Launch Daemon loaded"
else
    echo "Launch Daemon not found!"
    exit 1
fi
exit 0