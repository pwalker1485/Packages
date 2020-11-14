#!/bin/zsh

########################################################################
#                      Preinstall - Avid Pro Tools                     #
#################### Written by Phil Walker Nov 2019 ###################
########################################################################

# Edit May 2020
# Remove any previous version of Pro Tools to allow for upgrades or fresh installs
# Outset requires macOS 10.15+

########################################################################
#                            Variables                                 #
########################################################################

# Logged in user
loggedInUser=$(stat -f %Su /dev/console)
# Logged in user unique ID
loggedInUserUID=$(dscl . -read /Users/"$loggedInUser" UniqueID | awk '{print $2}')
# Logged in user ouset once plist
outsetOncePlist="/usr/local/outset/share/com.github.outset.once.${loggedInUserUID}.plist"
# Mac model
macModelFull=$(system_profiler SPHardwareDataType | grep "Model Name" | sed 's/Model Name: //' | xargs)
# OS Version
osVersion=$(sw_vers -productVersion)
# Minimum required OS version
minReqOS="10.15"

########################################################################
#                         Script starts here                           #
########################################################################

# Check the OS requirements are met
autoload is-at-least
if is-at-least "$minReqOS" "$osVersion"; then
    echo "$macModelFull running ${osVersion}, starting install..."
else
    echo "$macModelFull running ${osVersion}, macOS Catalina or later required"
    echo "Exiting...."
    exit 1
fi
# If found, remove previous version of Pro Tools
if [[ -d "/Applications/Pro Tools.app" ]]; then
    echo "Pro Tools already installed"
    echo "Removing currently version..."
    rm -rf "/Applications/Pro Tools.app"
    if [[ ! -d "/Applications/Pro Tools.app" ]]; then
        echo "Previous version of Pro Tools removed, proceed with install"
    else
        echo "Previous version removal FAILED!"
        exit 1
    fi
else
    echo "No existing install of Pro Tools found, proceed with install"
fi
# Delete any previous outset once plist for the logged in user to make sure new scripts run
if [[ -f "$outsetOncePlist" ]]; then
    echo "Outset Once plist found for ${loggedInUser}"
    rm -f "$outsetOncePlist"
    if [[ ! -f "$outsetOncePlist" ]]; then
        echo "Outset Once plist deleted successfully"
        echo "Outset Once content will run for ${loggedInUser}"
    else
        echo "Failed to delete Outset Once plist for ${loggedInUser}"
        echo "No new Outset Once content will run"
    fi
fi
exit 0