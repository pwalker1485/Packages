#!/bin/bash

########################################################################
#                NoMAD Login AD Auth Check - preinstall                #
################### Written by Phil Walker June 2019 ###################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# NoMAD Login AD auth check launch daemon
launchDaemon="/Library/LaunchDaemons/com.bauer.NoMADLoginAD.AuthCheck.plist"
# NoMAD Login AD auth check script
noLoADScript="/usr/local/bin/NoMADLoginAD_AuthCheck.sh"

########################################################################
#                            Functions                                 #
########################################################################

function launchDaemonStatus()
{
# Get the status of the launch daemon
checkLaunchD=$(launchctl list | grep "NoMADLoginAD.AuthCheck" | awk '{print $3}')
if [[ "$checkLaunchD" == "com.bauer.NoMADLoginAD.AuthCheck" ]]; then
    echo "NoMAD Login AD auth check launch daemon currently loaded"
    echo "Stopping and unloading the launch daemon..."
    /bin/launchctl stop "$launchDaemon"
    /bin/launchctl unload "$launchDaemon"
    /bin/sleep 2
else
    echo "NoMAD Login AD auth check launch daemon not loaded"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

# If the launch daemon already exists, stop/unload and delete
if [[ -f "$launchDaemon" ]]; then
    launchDaemonStatus
    rm -f "$launchDaemon"
    if [[ ! -f "$launchDaemon" ]]; then
        echo "Launch daemon deleted successfully"
    else
        echo "Launch daemon deletion FAILED!"
    fi
    launchDaemonStatus
fi
# If the script used by the launch daemon already exists, delete it
if [[ -f "$noLoADScript" ]]; then
    rm -f "$noLoADScript"
    if [[ ! -f "$noLoADScript" ]]; then
        echo "NoMAD Login AD auth check script deleted successfully"
    else
        echo "NoMAD Login AD auth check script deletion FAILED!"
    fi
fi
exit 0