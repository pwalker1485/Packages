#!/bin/zsh

########################################################################
#               Enable Touch ID for Sudo - postinstall                 #
#################### Written by Phil Walker Feb 2021 ###################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Launch Daemon
launchDaemon="/Library/LaunchDaemons/com.pwalker1485.EnableTouchIDForSudo.plist"
# Launch Daemon status
launchDaemonStatus=$(launchctl list | grep "com.pwalker1485.EnableTouchIDForSudo")

########################################################################
#                         Script starts here                           #
########################################################################

if [[ "$launchDaemonStatus" == "" ]]; then
    echo "Bootstrapping the Launch Daemon..."
    launchctl bootstrap system "$launchDaemon"
    sleep 2
    # Launch Daemon status
    launchDaemonStatus=$(launchctl list | grep "com.pwalker1485.EnableTouchIDForSudo")
    if [[ "$launchDaemonStatus" != "" ]]; then
        echo "Launch Daemon bootstrapped"
    else
        echo "Failed to bootstrap the Launch Daemon, it should load on next boot"
    fi
else
    echo "Launch Daemon already bootstrapped, nothing to do"
fi
exit 0