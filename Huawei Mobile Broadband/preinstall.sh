#!/bin/zsh

########################################################################
#              Huawei Mobile Broadband Service - preinstall            #
#################### Written by Phil Walker Oct 2020 ###################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Launch Daemon
launchDaemon="/Library/LaunchDaemons/com.huawei.mbbservice.plist"
# Launch Daemon status
launchDaemonStatus=$(launchctl list | grep "com.huawei.mbbservice")
# MBB Service Directory
mbbServiceDir="/Library/StartupItems/MobileBrServ"

########################################################################
#                         Script starts here                           #
########################################################################

# Boot out the Launch Daemon
if [[ "$launchDaemonStatus" != "" ]]; then
    echo "Booting out the Launch Daemon..."
    launchctl bootout system "$launchDaemon" >/dev/null 2>&1
    sleep 2
    echo "Launch Daemon booted out"
else
    echo "Launch Daemon not currently boostrapped, nothing to do"
fi
# Remove the Launch Daemon
if [[ -f "$launchDaemon" ]]; then
    rm -f "$launchDaemon" 2>/dev/null
    if [[ ! -f "$launchDaemon" ]]; then
        echo "Removed previous Launch Daemon"
    else
        echo "Failed to remove previous Launch Daemon"
    fi
else
    echo "Previous Launch Daemon not found"
fi
# Remove previous MBB Services
if [[ -d "$mbbServiceDir" ]]; then
    rm -rf "$mbbServiceDir" 2>/dev/null
    if [[ ! -d "$mbbServiceDir" ]]; then
        echo "Removed previous Services content"
    else
        echo "Failed to remove previous Services content"
    fi
else
    echo "Previous Services content not found"
fi
exit 0