#!/bin/zsh

########################################################################
#              Install WoodWing Place JSON Text script                 #
################### Written by Phil Walker Nov 2020 ####################
######################## postinstall script ############################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Find which versions of InDesign are installed
adobeInDesign=$(find /Applications/Adobe\ InDesign*/Scripts/ -type d -maxdepth 0 > /tmp/InDesignInstalls.txt)
# Script temp location
woodwingScriptDir="/usr/local/WoodWing/placejsontext"

########################################################################
#                            Functions                                 #
########################################################################

function cleanUp ()
{
# Clean up temporary files and directories
rm -f "/tmp/InDesignInstalls.txt"
rm -rf "/usr/local/WoodWing"
if [[ ! -f "/tmp/InDesignInstalls.txt" ]] && [[ ! -d "/usr/local/WoodWing" ]]; then
    echo "All temporary files and directories removed"
else
    echo "Clean up failed, manual clean up required"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

while IFS= read -r line; do
    ditto "$woodwingScriptDir" "$line"
    echo "Copied WoodWing Place JSON text script directory to $line..."
done < /tmp/InDesignInstalls.txt
cleanUp

exit 0