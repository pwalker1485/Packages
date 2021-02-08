#!/bin/zsh

########################################################################
#    Automatically Install All Adobe CC Application Updates Silently   #
#################### Written by Phil Walker Mar 2020 ###################
########################################################################
# Edit Nov 2020

########################################################################
#                            Variables                                 #
########################################################################

# Path to Adobe Remote Update Manager
rumBinary="/usr/local/bin/RemoteUpdateManager"
# Date (Month and Year only)
monthYear=$(date +"%m-%Y")
# Log file
logFile="/Library/Logs/Bauer/AdobeUpdates/AdobeCCUpdates_AutoInstall_${monthYear}.log"

########################################################################
#                            Functions                                 #
########################################################################

function checkConnectivity ()
{
#Check if the Mac has internet connectivity
ping -q -c 1 -W 1 www.apple.com >/dev/null 2>&1
pingResult="$?"
if [[ "$pingResult" -eq "0" ]]; then
    echo "Internet connectivity detected"
else
    echo "Internet connectivity not detected, exiting"
    exit 0
fi
}

function checkPower ()
{
##Check if the Mac is on ac power or has over 50% battery available
pwrAdapter=$(/usr/bin/pmset -g ps)
batteryPercentage=$(/usr/bin/pmset -g ps | grep -i "InternalBattery" | awk '{print $3}' | cut -c1-3 | sed 's/%//g')
if [[ "$pwrAdapter" =~ "AC Power" ]] || [[ "$batteryPercentage" -ge "50" ]]; then
	echo "Sufficient power detected"
else
	echo "Insufficient power detected, exiting"
    exit 0
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

# Create the log directory if required
if [[ ! -d "/Library/Logs/Bauer/AdobeUpdates" ]]; then
    mkdir -p "/Library/Logs/Bauer/AdobeUpdates"
fi
if [[ ! -f "$logFile" ]]; then
    touch "$logFile"
fi
# Redirect both standard output and standard error to the log
exec >> "$logFile" 2>&1
echo "Script started at: $(date +"%H-%M-%S (%d-%m-%Y)")"
# Confirm RUM is installed
if [[ ! -f "$rumBinary" ]]; then
    echo "Adobe Remote Update Manager not installed"
    echo "Script completed at: $(date +"%H-%M-%S (%d-%m-%Y)")"
    echo "--------------------------------------------------"
    exit 0
else
    # Check basic requirements for successful update installations
    checkConnectivity
    checkPower
    echo "Checking for updates..."    
    "$rumBinary" --action=list
    # Check the log to see if any updates are available
    updatesCheck=$(cat "$logFile")
    if [[ "$updatesCheck" =~ "Following Updates are applicable" ]]; then
        echo "Installing all available updates..."
        # Install all available updates and output result to the log
        "$rumBinary" --action=install
    else
        echo "No available updates found"
    fi
fi
echo "Script completed at: $(date +"%H-%M-%S (%d-%m-%Y)")"
echo "--------------------------------------------------"
exit 0