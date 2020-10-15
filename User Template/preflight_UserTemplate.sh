#!/bin/zsh

########################################################################
#          Package containing User Template data - preflight           #
################## Written by Phil Walker Sep 2020 #####################
########################################################################
# Required due to the User Template location change in macOS Catalina
# Mojave or earlier only

########################################################################
#                            Variables                                 #
########################################################################

# Mac model
macModelFull=$(system_profiler SPHardwareDataType | grep "Model Name" | sed 's/Model Name: //' | xargs)
# OS Version
osVersion=$(sw_vers -productVersion)
# macOS Catalina version number
catalinaOS="10.15"

########################################################################
#                         Script starts here                           #
########################################################################

autoload is-at-least
if ! is-at-least "$catalinaOS" "$osVersion"; then
    echo "$macModelFull running ${osVersion}, starting install..."
else
    echo "$macModelFull running ${osVersion}, macOS Mojave or earlier required"
    echo "Exiting...."
    exit 1
fi
exit 0