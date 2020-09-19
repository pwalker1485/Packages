#!/bin/bash

########################################################################
#                NoMAD Login AD Auth Check - postinstall                #
################### Written by Phil Walker June 2019 ###################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# NoMAD Login AD auth check launch daemon
launchDaemon="/Library/LaunchDaemons/com.bauer.NoMADLoginAD.AuthCheck.plist"

########################################################################
#                            Functions                                 #
########################################################################

function launchDaemonStatus()
{
# Get the status of the launch daemon
checkLaunchD=$(launchctl list | grep "NoMADLoginAD.AuthCheck" | cut -f3)
if [[ "$checkLaunchD" == "com.bauer.NoMADLoginAD.AuthCheck" ]]; then
    echo "NoMAD Login AD auth check launch daemon loaded and started"
else
    echo "Something went wrong, NoMAD Login AD auth check launch daemon not currently loaded!"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

# Load and start the launch daemon
/bin/launchctl load "$launchDaemon"
/bin/launchctl start "$launchDaemon"
/bin/sleep 2
# Check the launch daemon has been loaded and started
launchDaemonStatus
exit 0