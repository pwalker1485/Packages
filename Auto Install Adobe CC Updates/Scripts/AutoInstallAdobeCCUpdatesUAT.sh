#!/bin/bash

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
# UAT Log
logFileUAT="/Library/Logs/Bauer/AdobeUpdates/AdobeCCUpdates_AutoInstall-UAT.log"

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
if [[ ! -f "$logFileUAT" ]]; then
    touch "$logFileUAT"
fi
# Redirect both standard output and standard error to the log
exec >> "$logFileUAT" 2>&1
echo "Script started at: $(date +"%H-%M-%S (%d-%m-%Y)")"
#Confirm RUM is installed
if [[ ! -f "$rumBinary" ]]; then
    echo "Adobe Remote Update Manager not installed"
    echo "--------------------------------------------------"
    exit 0
else
    #Check basic requirements for successful update installations
    checkConnectivity
    checkPower
    echo ""
    "$rumBinary" --action=list
    # Check if any updates are required
    updatesCheck=$(cat "$logFileUAT")
    if [[ "$updatesCheck" =~ "Following Updates are applicable" ]]; then
        echo "Updates available"
        echo "Installing all available updates..."
        # Install all available updates and output result to the log
        "$rumBinary" --action=install
        echo "Successful update installations detailed in the UAT log"
    else
        echo "No available updates found"
    fi
fi
echo "Script completed at: $(date +"%H-%M-%S (%d-%m-%Y)")"
echo "--------------------------------------------------"
exit 0