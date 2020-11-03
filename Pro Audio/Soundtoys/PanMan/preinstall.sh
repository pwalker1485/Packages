#!/bin/bash

########################################################################
#                Install SoundToys PanMan - preinstall                 #
################### Written by Phil Walker Nov 2020 ####################
########################################################################
# repackaged and rewritten preinstall script as the vendors packages included iLok and a poorly written preinstall script

########################################################################
#                            Variables                                 #
########################################################################

# SoundToys app directory
soundtoysApp="/Applications/Soundtoys"
# PanMan Component
pmComponent="/Library/Audio/Plug-Ins/Components/PanMan.component"
# PanMan Plugin
pmPlugin="/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/PanMan.aaxplugin"
# PanMan DPM
pmDPM="/Library/Application Support/Digidesign/Plug-Ins/Soundtoys/PanMan.dpm"
# PanMan VST
pmVST="/Library/Audio/Plug-Ins/VST/Soundtoys/PanMan.vst"

########################################################################
#                         Script starts here                           #
########################################################################

# Remove any previous version of the app
if [[ -d "$soundtoysApp" ]]; then
    echo "Removing previous version of the SoundToys app..."
    rm -rf "$soundtoysApp" >/dev/null 2>&1
    if [[ ! -d "$soundtoysApp" ]]; then
        echo "Previous version of Soundtoys app removed successfully"
    else
        echo "Failed to remove previous version of Soundtoys!"
    fi
else
    echo "Previous version of Soundtoys app not found"
fi

# Remove the previous SoundToys PanMan component
if [[ -e "$pmComponent" ]]; then
    rm -rf "$pmComponent" >/dev/null 2>&1
    if [[ ! -e "$pmComponent" ]]; then
        echo "${pmComponent} deleted"
    else
        echo "Failed to delete ${pmComponent}"
    fi
fi

# Remove the previous SoundToys PanMan plugins
if [[ -e "$pmPlugin" ]] || [[ -e "$pmDPM" ]]; then
    rm -rf "$pmPlugin" >/dev/null 2>&1
    rm -rf "$pmDPM" >/dev/null 2>&1
    if [[ ! -e "$pmPlugin" ]] && [[ ! -e "$pmDPM" ]]; then
        echo "${pmPlugin} deleted"
        echo "${pmDPM} deleted"
    else
        echo "Failed to delete ${pmPlugin}"
        echo "Failed to delete ${pmDPM}"
    fi
fi

# Remove the previous SoundToys PanMan VST
if [[ -e "$pmVST" ]]; then
    rm -rf "$pmVST" >/dev/null 2>&1
    if [[ ! -e "$pmVST" ]]; then
        echo "${pmVST} deleted"
    else
        echo "Failed to delete ${pmVST}"
    fi
fi
echo "All previous SoundToys plugins removed"
exit 0
