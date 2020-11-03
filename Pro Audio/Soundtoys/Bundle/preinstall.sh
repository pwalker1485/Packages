#!/bin/bash

########################################################################
#                  Install Soundtoys 5 - preinstall                    #
################### Written by Phil Walker Sep 2020 ####################
########################################################################
# repackaged and rewritten preinstall script as the vendors packages included iLok and a poorly written preinstall script

########################################################################
#                            Variables                                 #
########################################################################

# Soundtoys app directory
soundtoysApp="/Applications/Soundtoys"
# Soundtoys 4 factory presets
soundtoys4Presets="/Library/Application Support/SoundToys" 
# Soundtoys 5 factory presets
soundtoys5Presets="/Users/Shared/Soundtoys/Soundtoys 5"
# Array listing Soundtoys Plug-Ins (Components)
previousComponents=( "/Library/Audio/Plug-Ins/Components/Crystallizer.component" "/Library/Audio/Plug-Ins/Components/Decapitator.component" \
"/Library/Audio/Plug-Ins/Components/EchoBoy.component" "/Library/Audio/Plug-Ins/Components/FilterFreak1.component" \
"/Library/Audio/Plug-Ins/Components/FilterFreak2.component" "/Library/Audio/Plug-Ins/Components/PanMan.component" \
"/Library/Audio/Plug-Ins/Components/PhaseMistress.component" "/Library/Audio/Plug-Ins/Components/Tremolator.component" \
"/Library/Audio/Plug-Ins/Components/Devil-Loc_Deluxe.component" "/Library/Audio/Plug-Ins/Components/Radiator.component" \
"/Library/Audio/Plug-Ins/Components/MicroShift.component" "/Library/Audio/Plug-Ins/Components/Devil-Loc.component" \
"/Library/Audio/Plug-Ins/Components/LittleRadiator.component" "/Library/Audio/Plug-Ins/Components/LittleMicroShift.component" \
"/Library/Audio/Plug-Ins/Components/LittlePrimalTap.component" "/Library/Audio/Plug-Ins/Components/PrimalTap.component" \
"/Library/Audio/Plug-Ins/Components/EffectRack.component" "/Library/Audio/Plug-Ins/Components/LittleAlterBoy.component" \
"/Library/Audio/Plug-Ins/Components/SieQ.component" "/Library/Audio/Plug-Ins/Components/EchoBoyJr.component" \
"/Library/Audio/Plug-Ins/Components/LittlePlate.component" "/Library/Audio/Plug-Ins/Components/FilterFreak.component" )
# Array listing Soundtoys Plug-Ins
previousPlugins=( "/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/Crystallizer.aaxplugin" "/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/Decapitator.aaxplugin" \
"/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/EchoBoy.aaxplugin" "/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/FilterFreak1.aaxplugin" \
"/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/FilterFreak2.aaxplugin" "/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/PanMan.aaxplugin" \
"/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/PhaseMistress.aaxplugin" "/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/Tremolator.aaxplugin" \
"/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/Devil-Loc_Deluxe.aaxplugin" "/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/Radiator.aaxplugin" \
"/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/MicroShift.aaxplugin" "/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/Devil-Loc.aaxplugin" \
"/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/LittleRadiator.aaxplugin" "/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/LittleMicroShift.aaxplugin" \
"/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/LittlePrimalTap.aaxplugin" "/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/PrimalTap.aaxplugin" \
"/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/EffectRack.aaxplugin" "/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/LittleAlterBoy.aaxplugin" \
"/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/SieQ.aaxplugin" "/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/EchoBoyJr.aaxplugin" \
"/Library/Application Support/Avid/Audio/Plug-Ins/Soundtoys/LittlePlate.aaxplugin" "/Library/Application Support/Digidesign/Plug-Ins/SoundToys/FilterFreak.dpm" )
# Array listing Soundtoys Plug-Ins (VST)
previousVST=( "/Library/Audio/Plug-Ins/VST/Soundtoys/Crystallizer.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/Decapitator.vst" \
"/Library/Audio/Plug-Ins/VST/Soundtoys/EchoBoy.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/FilterFreak1.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/FilterFreak2.vst" \
"/Library/Audio/Plug-Ins/VST/Soundtoys/PanMan.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/PhaseMistress.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/Tremolator.vst" \
"/Library/Audio/Plug-Ins/VST/Soundtoys/Devil-Loc_Deluxe.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/Radiator.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/MicroShift.vst"
"/Library/Audio/Plug-Ins/VST/Soundtoys/Devil-Loc.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/LittleRadiator.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/LittleMicroShift.vst" \
"/Library/Audio/Plug-Ins/VST/Soundtoys/LittlePrimalTap.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/PrimalTap.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/EffectRack.vst" \
"/Library/Audio/Plug-Ins/VST/Soundtoys/LittleAlterBoy.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/SieQ.vst" "/Library/Audio/Plug-Ins/VST/Soundtoys/EchoBoyJr.vst" \
"/Library/Audio/Plug-Ins/VST/Soundtoys/LittlePlate.vst" )

########################################################################
#                         Script starts here                           #
########################################################################

# Remove any previous version of the app
if [[ -d "$soundtoysApp" ]]; then
    echo "Removing previous version of Soundtoys app..."
    rm -rf "$soundtoysApp" >/dev/null 2>&1
    if [[ ! -d "$soundtoysApp" ]]; then
        echo "Previous version of Soundtoys app removed successfully"
    else
        echo "Failed to remove previous version of Soundtoys!"
    fi
else
    echo "Previous version of Soundtoys app not found"
fi

# Remove any previous factory presets
if [[ -d "$soundtoys4Presets" ]] || [[ -d "$soundtoys5Presets" ]]; then
    echo "Removing previous factory presets..."
    rm -rf "$soundtoys4Presets" >/dev/null 2>&1
    rm -rf "$soundtoys5Presets" >/dev/null 2>&1
    if [[ ! -d "$soundtoys4Presets" ]] && [[ ! -d "$soundtoys5Presets" ]]; then
        echo "Previous factory presets removed successfully"
    else
        echo "Failed to remove previous factory presets!"
    fi
else
    echo "Previous factory presets not found"
fi

# Remove all previous Soundtoys plugins
# Loop through the array of plug-in components removing any that are found
for component in "${previousComponents[@]}"; do
    if [[ -e "$component" ]]; then
        rm -rf "$component" >/dev/null 2>&1
        if [[ ! -e "$component" ]]; then
            echo "$component deleted"
        else
            echo "Failed to delete $component"
        fi
    fi
done

# Loop through the array of plug-ins removing any that are found
for plugin in "${previousPlugins[@]}"; do
    if [[ -e "$plugin" ]]; then
        rm -rf "$plugin" >/dev/null 2>&1
        if [[ ! -e "$plugin" ]]; then
            echo "$plugin deleted"
        else
            echo "Failed to delete $plugin"
        fi
    fi
done

# Loop through the array of VSTs removing any that are found
for vst in "${previousVST[@]}"; do
    if [[ -e "$vst" ]]; then
        rm -rf "$vst" >/dev/null 2>&1
        if [[ ! -e "$vst" ]]; then
            echo "$vst deleted"
        else
            echo "Failed to delete $vst"
        fi
    fi
done
echo "All previous Soundtoys plugins removed"
exit 0