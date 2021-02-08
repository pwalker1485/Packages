#!/bin/zsh

########################################################################
#    Automatically Install All Adobe CC Application Updates Package    #
#                         postinstall script                           #    
#################### Written by Phil Walker Mar 2020 ###################
########################################################################
# Edit Nov 2020

########################################################################
#                            Variables                                 #
########################################################################

# Launch Daemon
launchDaemon="/Library/LaunchDaemons/com.bauer.AutoCCUpdates.plist"

########################################################################
#                            Functions                                 #
########################################################################

function launchDaemonStatus ()
{
# Get the status of the Launch Daemon
checkLaunchD=$(launchctl list | grep "com.bauer.AutoCCUpdates")
if [[ "$checkLaunchD" != "" ]]; then
    echo "Bauer Adobe CC Auto Updates Launch Daemon bootstrapped"
else
    echo "Something went wrong, the Bauer Adobe CC Auto Updates Launch Daemon is not currently bootstrapped!"
    echo "Reboot required"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

# Bootstrap the Launch Daemon
launchctl bootstrap system "$launchDaemon"
sleep 2
# Check if the Launch Daemon was bootstrapped successfully
launchDaemonStatus
exit 0