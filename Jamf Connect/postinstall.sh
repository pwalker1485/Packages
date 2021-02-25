#!/bin/zsh

########################################################################
#                  Install Jamf Connect - postinstall                  #    
#################### Written by Phil Walker Nov 2020 ###################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Temp content directory
tempDir="/usr/local/JamfConnect"
# Jamf Connect Installer
jcInstaller="JamfConnect.pkg"
# Jamf Connect Launch Agent Installer
launchAgentInstaller="JamfConnectLaunchAgent.pkg"

########################################################################
#                            Functions                                 #
########################################################################

function cleanUp ()
{
if [[ -d "$tempDir" ]]; then
    rm -rf "$tempDir"
    if [[ ! -d "$tempDir" ]]; then
        echo "All temporary content removed successfully"
    else
        echo "Failed to remove temporary content, manual cleanup required"
    fi
else
    echo "No Temporary content found, nothing to do"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

if [[ -d "$tempDir" ]]; then
    # Install Jamf Connect
    if [[ -e "${tempDir}/${jcInstaller}" ]]; then
        echo "Installing Jamf Connect..."
        installer -pkg "${tempDir}/${jcInstaller}" -target /
        jcInstallResult="$?"
        if [[ "$jcInstallResult" -eq "0" ]]; then
            echo "Jamf Connect installed successfully"
        else
            echo "Jamf Connect install failed!"
            # Remove temp content
            cleanUp
            exit 1
        fi
    else
        echo "Jamf Connect package not found!"
        # Remove temp content
        cleanUp
        exit 1
    fi
    # Install Jamf Connect Launch Agent
    if [[ -e "${tempDir}/${launchAgentInstaller}" ]]; then
        echo "Installing Jamf Connect Launch Agent..."
        installer -pkg "${tempDir}/${launchAgentInstaller}" -target /
        agentInstallResult="$?"
        if [[ "$agentInstallResult" -eq "0" ]]; then
            echo "Jamf Connect Launch Agent installed successfully"
        else
            echo "Jamf Connect Launch Agent install failed!"
            # Remove temp content
            cleanUp
            exit 1
        fi
    else
        echo "Jamf Connect Launch Agent package not found!"
        # Remove temp content
        cleanUp
        exit 1
    fi
else
    echo "Jamf Connect content not found!"
    # Remove temp content
    cleanUp
    exit 1
fi
# Remove temp content
cleanUp

####################### For Zero Touch Only ############################
# A slow network connection during enrolment could result in the end user
# being presented with a standard macOS login window.
# In this scenario, to make sure the end user is presented with the Jamf
# Connect login window the loginwindow process must be killed.
# The loginwindow process will only be killed if specific conditions are met

# Wait until the AppleSetupDone file is created. Required for macOS Big Sur and later
until [[ -f "/var/db/.AppleSetupDone" ]]; do
    sleep 2
done
echo "AppleSetupDone file found"
# Get the logged in user
loggedInUser=$(stat -f %Su /dev/console)
if [[ "$loggedInUser" == "_mbsetupuser" ]] || [[ "$loggedInUser" == "root" ]] || [[ "$loggedInUser" == "" ]]; then
	# If Setup Assistant is running, exit and let macOS finish setup assistant and display the new Jamf Connect login screen
    setupAssistantProcess=$(pgrep -l "Setup Assistant")
    if [[ "$setupAssistantProcess" != "" ]]; then
        echo "Setup Assistant still running, exiting..."
        exit 0
    else
        # Kill the login window to reload it and show the Jamf Connect login window
        echo "Killing the loginwindow process to load the Jamf Connect login window..."
        /usr/bin/killall -9 loginwindow
    fi
fi
exit 0