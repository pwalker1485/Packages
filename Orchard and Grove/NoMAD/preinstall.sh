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
# NoMAD app
nomadApp="/Applications/NoMAD.app"

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

function removeLaunchAgent ()
{
if [[ -f "$launchAgent" ]]; then
    # Get the status of the launch daemon
    launchAgentStatus=$(runAsUser launchctl list | grep -i "com.trusourcelabs.NoMAD")
    if [[ "$launchAgentStatus" != "" ]]; then
        echo "Removing the Launch Agent..."
        launchctl bootout gui/"$loggedInUserID" "$launchAgent"
        sleep 2
        # Remove the plist
        rm -f "$launchAgent" 2>/dev/null
        # re-populate variable
        launchAgentStatus=$(runAsUser launchctl list | grep -i "com.trusourcelabs.NoMAD")
        if [[ "$launchAgentStatus" == "" ]]; then
            echo "NoMAD Launch Agent removed"
        else
            echo "Failed to remove the Launch Agent"
        fi
    else
        echo "NoMAD Launch Agent not currently loaded"
        # Remove the plist
        rm -f "$launchAgent" 2>/dev/null
    fi
else
    echo "NoMAD Launch Agent not found"
fi    
}

########################################################################
#                         Script starts here                           #
########################################################################

# Check if a user is logged in
if [[ "$loggedInUser" == "" ]] || [[ "$loggedInUser" == "root" ]]; then
    echo "No user logged in, checking for existing install..."
    # No user is logged in so only remove the app, if required
    if [[ -d "$nomadApp" ]]; then
        echo "Existing installation of NoMAD found"
        rm -rf "$nomadApp"
        if [[ ! -d "$nomadApp" ]]; then
            echo "Removed existing install of NoMAD"
        else
            echo "Failed to remove existing install of NoMAD"
        fi
    else
        echo "No existing install of NoMAD found"
    fi
else
    echo "${loggedInUser} logged in, removing any previous version of NoMAD..."
    # Remove the Launch Agent
    removeLaunchAgent
    # If running, kill the process
    if [[ "$(pgrep NoMAD)" != "" ]]; then
        echo "NoMAD running, killing the process"
        pkill -9 "NoMAD" >/dev/null 2>&1
        sleep 2        
        if [[ "$(pgrep NoMAD)" == "" ]]; then
            echo "NoMAD process killed"
        else
            echo "Failed to kill NoMAD process"
        fi
    else
        echo "NoMAD not currently running"
    fi
    # Remove previous version
    if [[ -d "$nomadApp" ]]; then
        echo "Existing installation of NoMAD found"
        rm -rf "$nomadApp"
        if [[ ! -d "$nomadApp" ]]; then
            echo "Removed existing install of NoMAD"
        else
            echo "Failed to remove existing install of NoMAD"
        fi
    else
        echo "No existing install of NoMAD found"
    fi
fi
exit 0