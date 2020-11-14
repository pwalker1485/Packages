#!/bin/zsh

########################################################################
#           Package containing Outset scripts - preinstall             #
################## Written by Phil Walker Nov 2020 #####################
########################################################################
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

autoload is-at-least
if is-at-least "$minReqOS" "$osVersion"; then
    echo "$macModelFull running ${osVersion}, starting install..."
else
    echo "$macModelFull running ${osVersion}, macOS Catalina or later required"
    echo "Exiting...."
    exit 1
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