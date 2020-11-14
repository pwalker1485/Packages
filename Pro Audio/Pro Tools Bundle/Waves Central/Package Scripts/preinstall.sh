#!/bin/zsh

########################################################################
#                     Waves Central - Preinstall                       #
################## Written by Phil Walker Nov 2020 #####################
########################################################################
# Package contains Outset scripts
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
exit 0