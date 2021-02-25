#!/bin/zsh

########################################################################
#                 Filevault Reissue App - postinstall                  #
################### Written by Phil Walker Feb 2021 ####################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Launch Daemon
launchDaemon="/Library/LaunchDaemons/com.bauer.FilevaultReissue.plist"

########################################################################
#                         Script starts here                           #
########################################################################

# Boostrap the Launch Daemon
launchctl bootstrap system "$launchDaemon"
if [[ $(launchctl list | grep "com.bauer.FilevaultReissue") != "" ]]; then
    echo "Filevault Reissue Launch Daemon now bootstrapped"
else
    echo "Attempting to boostrap the Launch Daemon again..."
    launchctl bootstrap system "$launchDaemon"
    if [[ $(launchctl list | grep "com.bauer.FilevaultReissue") != "" ]]; then
        echo "Filevault Reissue Launch Daemon now bootstrapped"
    else
        echo "Failed to boostrap the Launch Daemon"
        echo "It should be boostrapped on the next boot"
    fi
fi
exit 0