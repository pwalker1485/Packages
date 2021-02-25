#!/bin/zsh

########################################################################
#                Set CustomShortName for Jamf Connect                  #
################### Written by Phil Walker Feb 2021 ####################
########################################################################
# Script run via a Launch Agent

########################################################################
#                            Variables                                 #
########################################################################

# Get the logged in user
loggedInUser=$(stat -f %Su /dev/console)
# Jamf Connect
jamfConnect="/Applications/Jamf Connect.app"
# Log directory
logDir="/Users/${loggedInUser}/Library/Logs/Bauer/JamfConnect"
# Log file
logFile="${logDir}/Set_CustomShortName.log"

########################################################################
#                            Functions                                 #
########################################################################

createLog ()
{
# Create the log directory, if required
if [[ ! -d "$logDir" ]]; then
    mkdir -p "$logDir"
fi
# Create the log file, if required
if [[ ! -e "$logFile" ]]; then
    touch "$logFile"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

if [[ -d "$jamfConnect" ]]; then
    echo "Jamf Connect found"
    echo "Checking Jamf Connect CustomShortName..."
    # Check the value for CustomShortName
    shortName=$(defaults read com.jamf.connect.state CustomShortName 2>/dev/null)
    if [[ "$shortName" == "" ]] || [[ "$shortName" != "$loggedInUser" ]]; then
        # Create the log directory and file, if required
        createLog
        echo "Script started at: $(date +"%d-%m-%Y_%H-%M-%S")" >> "$logFile"
        defaults write com.jamf.connect.state CustomShortName "$loggedInUser"
        # re-populate variable
        shortName=$(defaults read com.jamf.connect.state CustomShortName)
        echo "Jamf Connect CustomShortName set to: ${shortName}"  >> "$logFile"
        # Kill Jamf Connect to log the user in automatically if a domain controller can be reached
        pkill "Jamf Connect"
        echo "Script ended at: $(date +"%d-%m-%Y_%H-%M-%S")" >> "$logFile"
    else
        echo "No changes required"
        echo "Jamf Connect CustomShortName set to: ${shortName}"
    fi
else
    echo "Jamf Connect not installed, nothing to do"
fi
exit 0