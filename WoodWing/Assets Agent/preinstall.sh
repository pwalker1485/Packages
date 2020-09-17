#!/bin/bash

########################################################################
#              Install WoodWing Assets Agent - preinstall              #
################### Written by Phil Walker Sept 2020 ###################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Get the logged in user
loggedInUser=$(stat -f %Su /dev/console)
# WoodWing Assets Agent Launch Agent
launchAgent="/Library/LaunchAgents/com.woodwing.AssetsAgent.plist"
# WoodWing Assets Agent
assetsAgent="/Applications/Assets Agent.app"

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

function unloadLaunchAgent ()
{
# Get the status of the launch daemon
launchAgentStatus=$(runAsUser launchctl list | grep -i "com.woodwing.AssetsAgent")
if [[ "$launchAgentStatus" != "" ]]; then
    echo "WoodWing Assets Agent Launch Agent currently loaded"
    echo "Stopping and unloading the Launch Agent..."
    runAsUser launchctl stop "$launchAgent"
    runAsUser launchctl unload "$launchAgent"
    sleep 2
    # re-populate variable
    launchAgentStatus=$(runAsUser launchctl list | grep -i "com.woodwing.AssetsAgent")
    if [[ "$launchAgentStatus" == "" ]]; then
        echo "WoodWing Assets Agent Launch Agent stopped and unloaded"
    else
        echo "Launch Agent still running"
    fi
else
    echo "WoodWing Assets Agent Launch Agent not loaded"
fi
}

function removePreviousVersions ()
{
# Remove old versions of the Assets Agent and Launch Agent
# If found, kill the processes
agentStatus=$(pgrep "Assets Agent")
if [[ "$agentStatus" != "" ]]; then
    pkill -9 "Assets Agent" 2>/dev/null
fi
# Remove previous versions of the app
if [[ -d "$assetsAgent" ]]; then
    echo "Previous version of the Assets Agent found"
    rm -rf "$assetsAgent"
    sleep 2
    if [[ ! -d "$assetsAgent" ]]; then
        echo "Previous version of the Assets Agent uninstalled successfully"
    else
        echo "Failed to remove previous versions of the Assets Agent"
    fi
fi
# Remove previous versions of the Launch Agent
if [[ -f "$launchAgent" ]]; then
    echo "Previous version of the Launch Agent found"
    rm -f "$launchAgent"
    sleep 2
    if [[ ! -f "$launchAgent" ]]; then
        echo "Previous version of the Launch Agent removed successfully"
    else
        echo "Failed to remove previous version of the Launch Agent"
    fi
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

if [[ "$loggedInUser" == "" ]] || [[ "$loggedInUser" == "root" ]]; then
    echo "No user logged in, checking for previous versions..."
    removePreviousVersions
else
    echo "${loggedInUser} is logged in, checking for previous versions..."
    unloadLaunchAgent
    removePreviousVersions
fi
exit 0