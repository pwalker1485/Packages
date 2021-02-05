#!/bin/zsh

########################################################################
#       Install Duik Bassel.2 Scripts for Adobe After Effects          #
#################### Written by Phil Walker Jan 2021 ###################
######################## postinstall script ############################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Find which versions of After Effects are installed
adobeAfterEffects=$(find /Applications/Adobe\ After\ Effects*/Scripts/ScriptUI\ Panels -type d -maxdepth 0)
# Script temp location
duikScripts="/usr/local/Duik_Bassel.2"

########################################################################
#                            Functions                                 #
########################################################################

function cleanUp ()
{
# Clean up temp directory
rm -rf "$duikScripts"
if [[ ! -d "$duikScripts" ]]; then
  echo "Temporary directory removed"
else
  echo "Clean up failed, manual clean up required"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

# Copy the scripts into the ScriptUI Panels directory
for appVersion in ${(f)adobeAfterEffects}; do
    ditto ${duikScripts}/Duik* "$appVersion"
    echo "Copied all Duik Bassel.2 scripts to ${appVersion}"
done
# Remove temp content
cleanUp
exit 0