#!/bin/zsh

########################################################################
#              Install Olympus DSS Player - preinstall                 #
################### Written by Phil Walker Nov 2020 ####################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# App directory
dssPlayer="/Applications/DSS Player"
# Version 6 install info
version6Info="/Library/Application Support/Olympus/DSSPlayer/DSSPlayer.conf"
# Patch info directory
patchDir="/Library/Application Support/Olympus/DSSPlayer/Patch"
# Frameworks
IFS=$'\n'
dssFrameworks=( $(find "/Library/Frameworks/" | grep -i "Olympus" 2>/dev/null) )
unset IFS
# Component plugin
dssComponent="/Library/Audio/Plug-Ins/Components/OlympusDSSEffect.component"
# Preference Pane
prefPane="/Library/PreferencePanes/Device Detector.prefPane"
# Legacy kext
legacyKext="/System/Library/Extensions/OlympusDSSDriver.kext"
# Current kext
currentKext="/Library/Extensions/OlympusDSSDriver.kext"

########################################################################
#                         Script starts here                           #
########################################################################

# Remove all previous version of the app
if [[ -d "$dssPlayer" ]]; then
    echo "Previous version of DSS Player found"
    rm -rf "$dssPlayer"
    if [[ ! -d "$dssPlayer" ]]; then
        echo "Successfully removed previous DSS Player version"
    else
        echo "Failed to remove previous version of DSS Player"
    fi
else
    echo "No previous version of DSS Player found"
fi
# Remove V6 install info
if [[ -d "$version6Info" ]]; then
    echo "Version 6 install config found"
    rm -rf "$version6Info"
    if [[ ! -d "$version6Info" ]]; then
        echo "Successfully removed DSS Player version 6 install config"
    else
        echo "Failed to removed DSS Player version 6 install config"
    fi
else
    echo "No DSS Player version 6 install config found"
fi
# Remove patch info directory
if [[ -d "$patchDir" ]]; then
    echo "DSS Player patch info directory found"
    rm -rf "$patchDir"
    if [[ ! -d "$patchDir" ]]; then
        echo "Successfully removed DSS Player patch info directory"
    else
        echo "Failed to remove DSS Player patch info directory"
    fi
else
    echo "No DSS Player patch info directory found"
fi
# Remove frameworks
for framework in "${dssFrameworks[@]}"; do
    if [[ -e "$framework" ]]; then
        rm -rf "$framework"
        echo "Removed framework: $framework"
    fi
done
# Remove Component plugin
if [[ -d "$dssComponent" ]]; then
    echo "DSS Player component plugin found"
    rm -rf "$dssComponent"
    if [[ ! -d "$dssComponent" ]]; then
        echo "Successfully removed DSS Player component plugin"
    else
        echo "Failed to remove DSS Player component plugin"
    fi
else
    echo "No DSS Player component plugin found"
fi
# Remove Preference Pane
if [[ -d "$prefPane" ]]; then
    echo "DSS Player Preference Pane found"
    rm -rf "$prefPane"
    if [[ ! -d "$prefPane" ]]; then
        echo "Successfully removed DSS Player Preference Pane"
    else
        echo "Failed to remove DSS Player Preference Pane"
    fi
else
    echo "No DSS Player Preference Pane found"
fi
# If required, unload and remove the kernel extension
if [[ -d "$legacyKext" || -d "$currentKext" ]]; then
    # Kext status
    kextCheck=$(kextstat -l | grep "com.olympus.DSSBlockCommandsDevice" | awk '{print $6}')
    if [[ "$kextCheck" != "" ]]; then
        echo "Unloading the Olympus DSS Player kext..."
        /sbin/kextunload -b "com.olympus.DSSBlockCommandsDevice" 2>/dev/null
        echo "Olympus DSS Player kext successfully unloaded"
        rm -rf "$legacyKext" >/dev/null 2>&1
        rm -rf "$currentKext" >/dev/null 2>&1
    else
        echo "Olympus DSS Player kext not currently loaded"
        rm -rf "$legacyKext" >/dev/null 2>&1
        rm -rf "$currentKext" >/dev/null 2>&1
    fi
    if [[ ! -d "$legacyKext" && ! -d "$currentKext" ]]; then
        echo "Olympus DSS Player kext removed successfully"
    else
        echo "Failed to remove the Olympus DSS Player kext"
    fi
else
    echo "Olympus DSS Player kernel extension not found"
fi
exit 0

