#!/bin/zsh

########################################################################
#                            Variables                                 #
########################################################################

# Get the logged in user
loggedInUser=$(stat -f %Su /dev/console)
# Get the logged in users ID
loggedInUserID=$(id -u "$loggedInUser")
# NoMAD Launch Agent
launchAgent="/Library/LaunchAgents/com.trusourcelabs.NoMAD.plist"

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

function loadLaunchAgent ()
{
if [[ -f "$launchAgent" ]]; then
    # Get the status of the launch daemon
    launchAgentStatus=$(runAsUser launchctl list | grep -i "com.trusourcelabs.NoMAD")
    if [[ "$launchAgentStatus" == "" ]]; then
        echo "Bootstrapping the Launch Agent..."
        launchctl bootstrap gui/"$loggedInUserID" "$launchAgent"
        /bin/sleep 2
        # re-populate variable
        launchAgentStatus=$(runAsUser launchctl list | grep -i "com.trusourcelabs.NoMAD")
        if [[ "$launchAgentStatus" != "" ]]; then
            echo "NoMAD Launch Agent now running"
        else
            echo "Launch Agent not running, logout or reboot!"
        fi
    else
        echo "NoMAD Launch Agent already running, nothing to do"
    fi
else
    echo "NoMAD Launch Agent not found, critical component missing!"
    exit 1
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