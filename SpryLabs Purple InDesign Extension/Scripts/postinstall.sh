#!/bin/bash

########################################################################
#           Install Purple Export Extension for InDesign CC            #
################## Written by Phil Walker Sept 2019 ####################
########################################################################
# Edit June 2020

########################################################################
#                            Variables                                 #
########################################################################

# Temp location of Extension Manager CLI
exManCLI="/private/var/tmp/PurpleExtension/ExManCmd_mac/Contents/MacOS/ExManCmd"
# Check current status of Purple Export Extension for InDesign CC
extensionStatus=$("$exManCLI" --list all | grep "Purple InDesign Extension")
# Temp location of the Purple Export Extension for InDesign CC 
tempExtensionPath="/private/var/tmp/PurpleExtension/CC/PurpleExtension-1.4.9.zxp"

########################################################################
#                            Functions                                 #
########################################################################

function cleanUp ()
{
# Clean up installation files
if [[ -d "/private/var/tmp/PurpleExtension" ]]; then
    rm -rf "/private/var/tmp/PurpleExtension"
    if [[ ! -d "/private/var/tmp/PurpleExtension" ]]; then
        echo "Temp install files deleted successfully"
    else
        echo "Failed to clean-up temp files, manual clean-up required"
    fi
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

# Check for previous version installed
if [[ "$extensionStatus" != "" ]]; then
    # Remove previous version
    echo "Purple Export Extension for InDesign CC found"
    "$exManCLI" --remove "Purple InDesign Extension"
    if [[ "$("$exManCLI" --list all | grep "Purple InDesign Extension")" != "" ]]; then
        echo "Purple Export Extension for InDesign CC removal failed!"
        echo "Continuing anyway..."
    fi
else
    echo "Purple Export Extension for InDesign CC not found, nothing to remove"
fi

# Install Purple Extension
echo "Installing Purple Export Extension for InDesign CC..."
"$exManCLI" --install "$tempExtensionPath"

# Check the installation was successful
if [[ "$("$exManCLI" --list all | grep "Purple InDesign Extension")" != "" ]]; then
    echo "Purple Export Extension for InDesign CC installed successfully"
    # Remove all temp files
    cleanUp
else
    echo "Purple Export Extension for InDesign CC installation FAILED!"
    # Remove all temp files
    cleanUp
    exit 1
fi

exit 0