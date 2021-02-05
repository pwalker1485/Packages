#!/bin/bash

########################################################################
#           Install Purple Export Extension for InDesign CC            #
################## Written by Phil Walker Sept 2019 ####################
########################################################################
# Edit Feb 2021

########################################################################
#                            Variables                                 #
########################################################################

# Temp directory
tempDir="/private/var/tmp/PurpleExtension"
# Temp location of Extension Manager CLI
exManCLI="${tempDir}/ExManCmdMac/Contents/MacOS/ExManCmd"
# Temp location of the Purple Export Extension for InDesign CC 
tempExtensionPath="${tempDir}/PurpleExtension-1.4.9.zxp"

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
echo "Removing any previous version of the Purple Export Extension for InDesign..."
"$exManCLI" --remove "Purple InDesign Extension" >/dev/null 2>&1
# Install Purple Extension
echo "Installing latest Purple Export Extension for InDesign..."
"$exManCLI" --install "$tempExtensionPath"
# Check the install was successful
commandResult="$?"
if [[ "$commandResult" -eq "0" ]]; then
    echo "Purple Export Extension for InDesign installed successfully"
    # Remove all temp files
    cleanUp
else
    echo "Purple Export Extension for InDesign installation FAILED!"
    # Remove all temp files
    cleanUp
    exit 1
fi
exit 0