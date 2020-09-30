#!/bin/bash

########################################################################
#                      Preinstall - Avid Pro Tools                     #
#################### Written by Phil Walker Nov 2019 ###################
########################################################################

# Edit May 2020

# Remove any previous version of Pro Tools to allow for upgrades or fresh installs

########################################################################
#                         Script starts here                           #
########################################################################

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

exit 0