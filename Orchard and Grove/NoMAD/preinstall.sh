#!/bin/zsh

########################################################################
#                            Variables                                 #
########################################################################

# Get the logged in user
loggedInUser=$(stat -f %Su /dev/console)
# NoMAD Launch Agent
launchAgent="/Library/LaunchAgents/com.trusourcelabs.NoMAD.plist"
# NoMAD process
nomadProc=$(pgrep "NoMAD")
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
    userID=$(id -u "$loggedInUser")
    launchctl asuser "$userID" sudo -u "$loggedInUser" "$@"
fi
}

function unloadLaunchAgent ()
{
# Get the status of the launch daemon
launchAgentStatus=$(runAsUser launchctl list | grep -i "com.trusourcelabs.NoMAD")
if [[ "$launchAgentStatus" != "" ]]; then
    echo "Stopping and unloading the Launch Agent..."
    runAsUser launchctl stop "$launchAgent"
    runAsUser launchctl unload "$launchAgent"
    /bin/sleep 2
    # re-populate variable
    launchAgentStatus=$(runAsUser launchctl list | grep -i "com.trusourcelabs.NoMAD")
    if [[ "$launchAgentStatus" == "" ]]; then
        echo "NoMAD Launch Agent stopped and unloaded"
    else
        echo "Failed to stop and unload the Launch Agent"
    fi
else
    echo "NoMAD Launch Agent not currently loaded, nothing to do"
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
    # Unload the Launch Agent
    unloadLaunchAgent
    # If running, kill the process
    echo "Checking for NoMAD process"
    if [[ "$nomadProc" != "" ]]; then
        echo "NoMAD running, killing the process"
        pkill -9 "NoMAD" >/dev/null 2>&1
        sleep 2        
        nomadProc=$(pgrep "NoMAD")
        if [[ "$nomadProc" == "" ]]; then
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