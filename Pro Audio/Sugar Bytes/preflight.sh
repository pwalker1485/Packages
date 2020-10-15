#!/bin/zsh

########################################################################
#              Install Sugar Bytes Plugins - preflight                 #
################## Written by Phil Walker Sep 2020 #####################
########################################################################
# All Packages have been designed for macOS Catalina or later and include
# user template data. If the OS version is not at least 10.15, the
# package will fail before copying any data

########################################################################
#                            Variables                                 #
########################################################################

# Mac model
macModelFull=$(system_profiler SPHardwareDataType | grep "Model Name" | sed 's/Model Name: //' | xargs)
# OS version
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