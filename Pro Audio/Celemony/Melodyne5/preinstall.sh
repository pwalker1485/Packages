#!/bin/zsh

########################################################################
#              Install Celemony Melodyne - preinstall                  #
################## Written by Phil Walker Nov 2020 #####################
########################################################################

# All content is from the vendors package with pre and post checks added

########################################################################
#                            Variables                                 #
########################################################################

# Avid Plugins
IFS=$'\n'
avidPlugins=( $(find "/Library/Application Support/Avid/Audio/Plug-Ins" | grep -i "Melodyne" 2>/dev/null) )
# Component plugins
componentPlugins=( $(find "/Library/Audio/Plug-Ins/Components" | grep -i "Melodyne" 2>/dev/null) )
# VSTs Plugins
vstPlugins=( $(find "/Library/Audio/Plug-Ins/VST3" | grep -i "Melodyne" 2>/dev/null) )
unset IFS

########################################################################
#                         Script starts here                           #
########################################################################

# Remove Celemony App Support directory to cleanup
if [[ -d "/Library/Application Support/Celemony" ]]; then
    echo "Celemony App Support directory found"
    rm -rf "/Library/Application Support/Celemony"
    if [[ ! -d "/Library/Application Support/Celemony" ]]; then
        echo "Removed Celemony App Support directory"
    else
        echo "Failed to remove Celemony App Support directory, previous content may need to be removed manually"
    fi
else
    echo "Celemony App Support directory not found"
fi

# Remove Melodyne "legacy" package artifacts
# Package receipts
pkgutil --force --forget com.celemony.melodyne.rewiredevice 2>/dev/null
pkgutil --force --forget com.celemony.melodyne.rtas 2>/dev/null
pkgutil --force --forget com.celemony.melodyne.vst 2>/dev/null
# Melodyne ReWire Device bundle
if [[ -e "/Library/Application Support/Propellerhead Software/ReWire/MelodyneReWireDevice.bundle" ]]; then
    echo "Legacy Melodyne ReWire Device bundle found"
    rm -rf "/Library/Application Support/Propellerhead Software/ReWire/MelodyneReWireDevice.bundle"
    if [[ ! -e "/Library/Application Support/Propellerhead Software/ReWire/MelodyneReWireDevice.bundle" ]]; then
        echo "Legacy Melodyne ReWire Device bundle removed"
    else
        echo "Failed to remove legacy Melodyne ReWire Device bundle"
        echo "Manual removal required"
    fi
fi
# Melodyne DPM
if [[ -e "/Library/Application Support/Digidesign/Plug-Ins/Melodyne.dpm" ]]; then
    echo "Legacy Melodyne DPM found"
    rm -rf "/Library/Application Support/Digidesign/Plug-Ins/Melodyne.dpm"
    if [[ ! -e "/Library/Application Support/Digidesign/Plug-Ins/Melodyne.dpm" ]]; then
        echo "Legacy Melodyne DPM removed"
    else
        echo "Failed to remove legacy Melodyne DPM"
        echo "Manual removal required"
    fi
fi
# Melodyne VST
if [[ -e "/Library/Audio/Plug-Ins/VST/Melodyne.vst" ]]; then
    echo "Legacy Melodyne VST found"
    rm -rf "/Library/Audio/Plug-Ins/VST/Melodyne.vst"
    if [[ ! -e "/Library/Audio/Plug-Ins/VST/Melodyne.vst" ]]; then
        echo "Legacy Melodyne VST removed"
    else
        echo "Failed to remove legacy Melodyne VST"
        echo "Manual removal required"
    fi
fi

# Remove certain incompatible binaries
# Package receipt
pkgutil --force --forget com.celemony.melodyne.singletrack 2>/dev/null
# Content
if [[ -e "/Applications/Melodyne singletrack" ]]; then
    echo "Melodyne singletrack found"
    rm -rf "/Applications/Melodyne singletrack"
    if [[ ! -e "/Applications/Melodyne singletrack" ]]; then
        echo "Melodyne singletrack removed"
    else
        echo "Failed to remove Melodyne singletrack"
        echo "Manual removal required"
    fi
fi
if [[ -e "/Applications/Melodyne 4" ]]; then
    echo "Melodyne 4 found"
    rm -rf "/Applications/Melodyne 4"
    if [[ ! -e "/Applications/Melodyne 4" ]]; then
        echo "Melodyne 4 removed"
    else
        echo "Failed to remove Melodyne 4"
        echo "Manual removal required"
    fi
fi

# Remove old versions of the plugins
# Avid plugins
for plugin in "${avidPlugins[@]}"; do
    if [[ -e "$plugin" ]]; then
        rm -rf "$plugin"
        echo "Removed plugin: $plugin"
    fi
done
# Components
for plugin in "${componentPlugins[@]}"; do
    if [[ -e "$plugin" ]]; then
        rm -rf "$plugin"
        echo "Removed plugin: $plugin"
    fi
done
# VSTs
for plugin in "${vstPlugins[@]}"; do
    if [[ -e "$plugin" ]]; then
        rm -rf "$plugin"
        echo "Removed plugin: $plugin"
    fi
done
exit 0