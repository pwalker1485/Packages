#!/bin/bash

########################################################################
#                   Postinstall - Install Avid Pro Tools               #
##################### Written by Phil Walker Mar 2020 ##################
########################################################################

# Edit May 2020
# Edit Sep 2020 (Updated and removed installer of Avid Codecs LE and Avid Link Updater packages)

# Pro Tools DMG is copied to local machine via Package
# DMG provided by Avid contains several packages

########################################################################
#                         Script starts here                           #
########################################################################

# Mount the the DMG silently
hdiutil mount -noverify -nobrowse "/usr/local/Pro Tools/Pro_Tools_2020.9.1_Mac.dmg"

# Install all packages in correct order
# Pro Tools
installer -pkg "/Volumes/Pro Tools/Install Pro Tools 2020.9.1.pkg" -target /
# HD Driver
installer -pkg "/Volumes/Pro Tools/Driver Installers/Install Avid HD Driver.pkg" -target /

# Unmount the DMG
hdiutil unmount -force "/Volumes/Pro Tools/"
# Remove Install DMG's and packages
rm -rf "/usr/local/Pro Tools"

if [[ ! -d "/usr/local/Pro Tools" ]]; then
    echo "Clean up has been successful"
else
    echo "Clean up FAILED, please delete the folder /usr/local/Pro Tools/ manually"
fi

exit 0