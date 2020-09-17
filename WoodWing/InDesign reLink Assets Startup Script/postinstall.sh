#!/bin/bash

########################################################################
#         Install WoodWing Adobe InDesign relink Asset script          #
#                  Written by Phil Walker Sep 2020                     #
######################## postinstall script ############################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Find which versions of InDesign are installed
adobeInDesign=$(find /Applications/Adobe\ InDesign*/Scripts/startup\ scripts/ -type d -maxdepth 0 > /tmp/InDesignInstalls.txt)
# Script temp location
startupScript="/usr/local/WoodWing/relinkAssetAfterPlaceEvent.jsx"

########################################################################
#                            Functions                                 #
########################################################################

function cleanUp ()
{
# Clean up temporary files and directories
rm -f "/tmp/InDesignInstalls.txt"
rm -rf "/usr/local/WoodWing/"
if [[ ! -f "/tmp/InDesignInstalls.txt" ]] && [[ ! -d "/usr/local/WoodWing/" ]]; then
  echo "All temporary files and directories removed"
else
  echo "Clean up failed, manual clean up required"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

# Install the plugin for all versions of InDesign found
while IFS= read -r line; do
    cp -R -p -f "$startupScript" "$line"
    echo "Copied WoodWing reLink Asset script to ${line}"
done < /tmp/InDesignInstalls.txt
# Remove all temp files
cleanUp

exit 0