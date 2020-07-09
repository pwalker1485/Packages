#!/bin/bash

########################################################################
#               Install Bauer Media Preflight Settings                 #
################## Written by Phil Walker June 2020 ####################
###################### postinstall script ##############################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

#Find which versions of InDesign are installed
adobeInDesign=$(find /Applications/Adobe\ InDesign*/Scripts/Preflight/ -type d -maxdepth 0 > /tmp/InDesignInstalls.txt)
#Script temp location
preflightSettings="/private/var/tmp/Preflight/Bauer_Media.idpp"

########################################################################
#                            Functions                                 #
########################################################################

function cleanUp ()
{
# Clean up temporary files and directories
if [[ -f "/tmp/InDesignInstalls.txt" ]] || [[ -d "/private/var/tmp/Preflight" ]]; then
    rm -f "/tmp/InDesignInstalls.txt"
    rm -rf "/private/var/tmp/Preflight"
    if [[ ! -f "/tmp/InDesignInstalls.txt" ]] && [[ ! -d "/private/var/tmp/Preflight" ]]; then
        echo "All temporary files and directories removed"
    else
        echo "Clean up failed, manual clean up required"
    fi
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

# Install the settings for all versions of InDesign found
while IFS= read -r line; do
    cp -R -p -f "$preflightSettings" "$line"
    echo "Copied Preflight setttings to ${line}"
done < /tmp/InDesignInstalls.txt
# Remove all temp files
cleanUp

exit 0