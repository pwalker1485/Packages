#!/bin/zsh

########################################################################
#          Package containing User Template data - preflight           #
################## Written by Phil Walker Sep 2020 #####################
########################################################################
# Required due to the User Template location change in macOS Catalina
# Catalina or later only

########################################################################
#                            Variables                                 #
########################################################################

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