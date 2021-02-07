#!/bin/zsh

########################################################################
#  Install MoPack Extension for Adobe After Effects and Premiere Pro   #
################## Written by Phil Walker Feb 2021 #####################
######################## postinstall script ############################
########################################################################
# Vendor URL: https://videohive.net/item/mopack/29918969

########################################################################
#                            Variables                                 #
########################################################################

# Temp directory
tempDir="/private/var/tmp/MoPack"
# Temp location of Extension Manager CLI
exManCLI="${tempDir}/ExManCmdMac/Contents/MacOS/ExManCmd"
# Temp location of the MoPack Extension 
tempExtensionPath="${tempDir}/MoPack_v1.1.zxp"

########################################################################
#                            Functions                                 #
########################################################################

function cleanUp ()
{
# Clean up installation files
if [[ -d "$tempDir" ]]; then
    rm -rf "$tempDir"
    if [[ ! -d "$tempDir" ]]; then
        echo "Temp install files deleted successfully"
    else
        echo "Failed to clean-up temp files, manual clean-up required"
    fi
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

# Remove previous version
echo "Removing any previous version of the MoPack Extension for AEFT and PPRO..."
"$exManCLI" --remove "MoPack" >/dev/null 2>&1
# Install MoPack Extension
echo "Installing latest MoPack Extension for AEFT and PPRO..."
"$exManCLI" --install "$tempExtensionPath"
# Check the install was successful
commandResult="$?"
if [[ "$commandResult" -eq "0" ]]; then
    echo "MoPack Extension for AEFT and PPRO installed successfully"
    # Remove all temp files
    cleanUp
else
    echo "MoPack Extension for AEFT and PPRO installation FAILED!"
    # Remove all temp files
    cleanUp
    exit 1
fi
exit 0