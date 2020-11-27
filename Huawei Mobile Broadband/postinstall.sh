#!/bin/zsh

########################################################################
#              Huawei Mobile Broadband Service - postinstall           #
#################### Written by Phil Walker Oct 2020 ###################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Launch Daemon
launchDaemon="/Library/LaunchDaemons/com.huawei.mbbservice.plist"
# Launch Daemon status
launchDaemonStatus=$(launchctl list | grep "com.huawei.mbbservice")

########################################################################
#                         Script starts here                           #
########################################################################

if [[ "$launchDaemonStatus" == "" ]]; then
    echo "Bootstrapping the Launch Daemon..."
    launchctl bootstrap system "$launchDaemon"
    sleep 2
    # Launch Daemon status
    launchDaemonStatus=$(launchctl list | grep "com.huawei.mbbservice")
    if [[ "$launchDaemonStatus" != "" ]]; then
        echo "Launch Daemon bootstrapped"
    else
        echo "Failed to bootstrap the Launch Daemon, it should load on next boot"
    fi
else
    echo "Launch Daemon already bootstrapped, nothing to do"
fi
exit 0