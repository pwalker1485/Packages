#!/bin/zsh

########################################################################
#        Jamf Connect CustomShortName Launch Agent - postinstall       #
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
    echo "Launch Agent running"
else
    echo "Launch Agent not running!"
    echo "Agent should start after the next reboot"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

if [[ "$loggedInUser" == "root" ]] || [[ "$loggedInUser" == "" ]]; then
    echo "No user logged in, nothing to do"
else
    echo "${loggedInUser} logged in, bootstrapping the Launch Agent..."
    # Bootstrap the Launch Agent
    launchctl bootstrap gui/"$loggedInUserID" "$launchAgent"
    sleep 2
    # Check the Launch Agent is now running
    launchAgentStatus
fi
exit 0
