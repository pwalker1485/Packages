#!/bin/bash

########################################################################
#      Install Adobe InDesign Colour Profile Check Startup Script      #
#################### Written by Phil Walker May 2020 ###################
########################################################################

# postinstall script

########################################################################
#                            Variables                                 #
########################################################################

# Find which versions of InDesign are installed
adobeInDesign=$(find /Applications/Adobe\ InDesign*/Scripts/startup\ scripts/ -type d -maxdepth 0 > /tmp/InDesignInstalls.txt)
# Script temp location
startupScript="/usr/local/ColourProfileCheck/InDesign_Colour_Profile_Check.scpt"

########################################################################
#                            Functions                                 #
########################################################################

function cleanUp ()
{
# Clean up temporary files and directories
rm -f "/tmp/InDesignInstalls.txt"
rm -rf "/usr/local/ColourProfileCheck/"
if [[ ! -f "/tmp/InDesignInstalls.txt" ]] && [[ ! -d "/usr/local/ColourProfileCheck" ]]; then
  echo "All temporary files and directories removed"
else
  echo "Clean up failed, manual clean up required"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

while IFS= read -r line; do
    cp -p -f "$startupScript" "$line"
    echo "Copied Adobe InDesign Colour Profile Check script to ${line}"
done < /tmp/InDesignInstalls.txt

cleanUp

exit 0
