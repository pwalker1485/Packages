#!/bin/zsh

########################################################################
#    Automatically Install All Adobe CC Application Updates Package    #
#                         preinstall script                            #                        
#################### Written by Phil Walker Mar 2020 ###################
########################################################################
# Edit Nov 2020

########################################################################
#                            Variables                                 #
########################################################################

# Previous Launch Agent
launchAgent="/Library/LaunchAgents/com.bauer.AutoCCUpdates.LoginWindow.plist"
# Previous Launch Daemon
launchDaemon="/Library/LaunchDaemons/com.bauer.AutoCCUpdates.plist"
# Auto update script
updateScript="/usr/local/bin/AutoInstallAdobeCCUpdates.sh"

########################################################################
#                         Script starts here                           #
########################################################################

# Bootout the Launch Daemon
launchctl bootout system "$launchDaemon" 2>/dev/null
# Bootout the Launch Agent
launchctl bootout system "$launchAgent" 2>/dev/null
# Remove previous content
if [[ -e "$launchAgent" || -e "$launchDaemon" || -e "$updateScript" ]]; then
    echo "Previous content found"
    echo "Removing previous launch agent, daemon and script"
    rm -f "$launchAgent" 2>/dev/null
    rm -f "$launchDaemon" 2>/dev/null
    rm -f "$updateScript" 2>/dev/null
    if [[ ! -e "$launchAgent" && ! -e "$launchDaemon" && ! -e "$updateScript" ]]; then
        echo "Previous content deleted successfully"
    else
        echo "clean up FAILED!"
    fi
else
    echo "Previous content not found"
    echo "Nothing to do"
fi
exit 0