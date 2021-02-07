#!/bin/zsh

########################################################################
#        Install Motion 3 Extension for Adobe After Effects            #
################## Written by Phil Walker Feb 2021 #####################
######################## postinstall script ############################
########################################################################
# vendor URL: https://www.mtmograph.com/products/motion-3

########################################################################
#                            Variables                                 #
########################################################################

# Temp directory
tempDir="/private/var/tmp/Motion"
# Temp location of Extension Manager CLI
exManCLI="${tempDir}/ExManCmdMac/Contents/MacOS/ExManCmd"
# Temp location of the Extension 
tempExtensionPath="${tempDir}/Motion3Ext_3.34.zxp"

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
echo "Removing any previous version of the Motion 3 Extension for AEFT..."
"$exManCLI" --remove "com.mtmograph.motion-next" >/dev/null 2>&1
# Install Motion 3 Extension
echo "Installing latest Motion 3 Extension for AEFT..."
"$exManCLI" --install "$tempExtensionPath"
# Check the install was successful
commandResult="$?"
if [[ "$commandResult" -eq "0" ]]; then
    echo "Motion 3 Extension for AEFT installed successfully"
    # Remove all temp files
    cleanUp
else
    echo "Motion 3 Extension for AEFT installation FAILED!"
    # Remove all temp files
    cleanUp
    exit 1
fi
exit 0