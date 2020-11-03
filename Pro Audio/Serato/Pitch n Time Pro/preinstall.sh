#!/bin/zsh

########################################################################
#                Install Pitch 'n Time Pro - preinstall                #
################### Written by Phil Walker Nov 2020 ####################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# legacy DPM plugin
legacyPlugin="/Library/Application Support/Digidesign/Plug-Ins/Pitch 'n Time Pro.dpm"

########################################################################
#                         Script starts here                           #
########################################################################

# Remove old dpm plugin
if [[ -e "$legacyPlugin" ]]; then
    rm -rf "$legacyPlugin" >/dev/null 2>&1
    if [[ ! -e "$legacyPlugin" ]]; then
        echo "Successfully removed legacy Pitch 'n Time Pro dpm plugin"
    else
        echo "Failed to remove legacy Pitch 'n Time Pro dpm plugin"
    fi
else
    echo "Legacy Pitch 'n Time Pro dpm plugin not found, nothing to do"
fi
exit 0