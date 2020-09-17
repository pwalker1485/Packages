#!/bin/bash

########################################################################
#             Install WoodWing Assets Agent - postinstall              #
################### Written by Phil Walker Sept 2020 ###################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Get the logged in user
loggedInUser=$(stat -f %Su /dev/console)
# WoodWing Assets Agent Launch Agent
launchAgent="/Library/LaunchAgents/com.woodwing.AssetsAgent.plist"

########################################################################
#                            Functions                                 #
########################################################################

function runAsUser ()
{  
# Run commands as the logged in user
if [[ "$loggedInUser" == "" ]] || [[ "$loggedInUser" == "root" ]]; then
    echo "No user logged in, unable to run commands as a user"
else
    userID=$(id -u "$loggedInUser")
    launchctl asuser "$userID" sudo -u "$loggedInUser" "$@"
fi
}

function loadLaunchAgent ()
{
# Get the status of the launch daemon
launchAgentStatus=$(runAsUser launchctl list | grep -i "com.woodwing.AssetsAgent")
if [[ "$launchAgentStatus" == "" ]]; then
    echo "Loading and starting the Launch Agent..."
    runAsUser launchctl load "$launchAgent"
    /bin/sleep 2
    # re-populate variable
    launchAgentStatus=$(runAsUser launchctl list | grep -i "com.woodwing.AssetsAgent")
    if [[ "$launchAgentStatus" != "" ]]; then
        echo "WoodWing Assets Agent Launch Agent loaded and started"
    else
        echo "Launch Agent failed to load, logout or reboot"
    fi
else
    echo "WoodWing Assets Agent Launch Agent already loaded, nothing to do"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

if [[ "$loggedInUser" == "" ]] || [[ "$loggedInUser" == "root" ]]; then
    # If no user is logged in do nothing
    echo "No user logged in, nothing to do"
else
    # Load the Launch Agent
    loadLaunchAgent
fi
exit 0