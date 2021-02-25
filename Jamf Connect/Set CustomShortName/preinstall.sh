#!/bin/zsh

########################################################################
#        Jamf Connect CustomShortName Launch Agent - preinstall        #
################## Written by Phil Walker Feb 2021 #####################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Get the logged in user
loggedInUser=$(stat -f %Su /dev/console)
# Get the logged in users ID
loggedInUserID=$(id -u "$loggedInUser")
# Launch Agent
launchAgent="/Library/LaunchAgents/com.bauer.jamfconnect.shortname.plist"
# Script
jcScript="/usr/local/BauerMediaGroup/JamfConnect/SetCustomShortName.sh"

########################################################################
#                            Functions                                 #
########################################################################

function runAsUser ()
{  
# Run commands as the logged in user
if [[ "$loggedInUser" == "" ]] || [[ "$loggedInUser" == "root" ]]; then
    echo "No user logged in, unable to run commands as a user"
else
    launchctl asuser "$loggedInUserID" sudo -u "$loggedInUser" "$@"
fi
}

function launchAgentStatus ()
{
# Get the status of the Launch Agent
currentStatus=$(runAsUser launchctl list | grep -i "com.bauer.jamfconnect.shortname")
if [[ "$currentStatus" != "" ]]; then
    echo "Failed to bootout the Launch Agent!"
else
    echo "Launch Agent booted out"
fi
}

function removePreviousContent ()
{
# Remove the previous Launch Agent and script
if [[ -f "$launchAgent" || -f "$jcScript" ]]; then
    rm -f "$launchAgent" 2>/dev/null
    rm -f "$jcScript" 2>/dev/null
    if [[ ! -f "$launchAgent" || ! -f "$jcScript" ]]; then
        echo "Launch Agent and script removed successfully"
    else
        echo "Failed to remove the previous Launch Agent and script"
        exit 1
    fi
else
    echo "Previous content not found"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

if [[ "$loggedInUser" == "root" ]] || [[ "$loggedInUser" == "" ]]; then
    echo "No user logged in, removing previous content..."
    # Remove previous content
    removePreviousContent
else
    echo "${loggedInUser} currently logged in"
    # Remove the Launch Agent
    if [[ -f "$launchAgent" ]]; then
        echo "Booting out the Launch Agent..."
        launchctl bootout gui/"$loggedInUserID" "$launchAgent" 2>/dev/null
        sleep 2
        launchAgentStatus
    else
        echo "Previous Launch Agent not found"
    fi
    # Remove previous content
    removePreviousContent
fi
exit 0