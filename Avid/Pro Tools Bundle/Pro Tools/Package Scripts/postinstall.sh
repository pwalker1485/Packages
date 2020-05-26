#!/bin/bash

########################################################################
#                   Postinstall - Install Avid Pro Tools               #
##################### Written by Phil Walker Mar 2020 ##################
########################################################################

# Pro Tools DMG is copied to local machine via Package
# DMG provided by Avid contains several packages

########################################################################
#                         Script starts here                           #
########################################################################

# Mount the the DMG silently
hdiutil mount -noverify -nobrowse "/usr/local/Pro Tools/Pro_Tools_2020.3.0_Mac.dmg"

# Install all packages/apps in correct order
# Pro Tools
installer -pkg "/Volumes/Pro Tools/Install Pro Tools 2020.3.0.pkg" -target /
# Codecs LE
installer -pkg "/usr/local/Pro Tools/UK_Avid_CodecsLE_2.7.3.pkg" -target /
# HD Driver
installer -pkg "/Volumes/Pro Tools/Driver Installers/Install Avid HD Driver.pkg" -target /
# Avid Link Update
installer -pkg "/usr/local/Pro Tools/UK_Avid_AvidLink_20.4.pkg" -target /

# Unmount the DMG
hdiutil unmount -force "/Volumes/Pro Tools/"
# Remove Install DMG's and packages
rm -rf "/usr/local/Pro Tools/"

if [[ ! -d "/usr/local/Pro Tools/" ]]; then
    echo "Clean up has been successful"
else
    echo "Clean up FAILED, please delete the folder /usr/local/Pro Tools/ manually"
fi

exit 0