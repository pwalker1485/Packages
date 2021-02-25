#!/bin/zsh

########################################################################
#                 Check Filevault Reissue App Result                   #
################### Written by Phil Walker Feb 2021 ####################
########################################################################
# If the app has closed run an inventory update
# If the app is still open the end user has ignored it so we'll close it

########################################################################
#                            Variables                                 #
########################################################################

# FileVault Reissue
filevaultReissue="/private/var/tmp/Filevault Reissue.app"
# Launch Daemon
launchDaemon="/Library/LaunchDaemons/com.bauer.FilevaultReissue.plist"
# Log directory
logDir="/Library/Logs/Bauer/FilevaultReissue"
# Log location
logFile="${logDir}/ReissuePRK.log"

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

function cleanUp ()
{
# Bootout the Launch Daemon
launchctl bootout system "$launchDaemon"
if [[ $(launchctl list | grep "com.bauer.FilevaultReissue") == "" ]]; then
    echo "Filevault Reissue Launch Daemon booted out"
else
    echo "Attempting to bootout the Launch Daemon again..."
    launchctl bootout system "$launchDaemon"
    if [[ $(launchctl list | grep "com.bauer.FilevaultReissue") == "" ]]; then
        echo "Filevault Reissue Launch Daemon booted out"
    else
        echo "Failed to bootout the Launch Daemon"
        echo "It should be booted out on the next boot"
    fi
fi
# Remove temp content
if [[ -d "$filevaultReissue" ]] || [[ -f "$launchDaemon" ]]; then
    rm -rf "$filevaultReissue"
    rm -f "$launchDaemon"
    if [[ ! -d "$filevaultReissue" ]] && [[ ! -f "$launchDaemon" ]]; then
        echo "Temporary content cleaned up"
    else
        echo "Failed to cleanup temporary content"
    fi
fi
# Delete this script
/bin/rm -f "$0"
}

########################################################################
#                         Script starts here                           #
########################################################################

createLog
# redirect both standard output and standard error to the log
exec >> "$logFile" 2>&1
if [[ -d "$filevaultReissue" ]]; then
    echo "FileVault Reissue app found"
    # If the user hasn't interacted with the application force it to close so that the policy can run again the following day
    fvReissueProcess=$(pgrep "Filevault Reissue")
    if [[ "$fvReissueProcess" != "" ]]; then
        /usr/bin/pkill -9 "Filevault Reissue"
        echo "Filevault Reissue application closed"
    else
        echo "Filevault Reissue application closed by the user" 
        # 1 inventory update required to trigger the ‘SecurityInfo’ command
        # Once Jamf Pro receives the reply to the ‘SecurityInfo’ command it escrows the PRK and automatically sets the key to ‘Valid’
        /usr/local/jamf/bin/jamf recon
    fi
else
    echo "FileVault Reissue app not found, nothing to do"
fi
# Remove temp files
cleanUp
exit 0