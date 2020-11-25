#!/bin/bash

########################################################################
#                   Postinstall - Install Avid Pro Tools               #
##################### Written by Phil Walker Mar 2020 ##################
########################################################################

# Edit May 2020
# Edit Sep 2020 (Updated and removed installer of Avid Codecs LE and Avid Link Updater packages)

# Pro Tools DMG is copied to local machine via Package
# DMG provided by Avid contains several packages

# Requirements for Outset
# Outset (https://github.com/chilcote/outset)
# macOS 10.15+
# python 3.7+ (https://github.com/macadmins/python)

########################################################################
#                            Variables                                 #
########################################################################

# Outset binary
outsetBinary="/usr/local/outset/outset"

########################################################################
#                         Script starts here                           #
########################################################################

# Mount the the DMG silently
hdiutil mount -noverify -nobrowse "/usr/local/Pro Tools/Pro_Tools_2020.11.0_Mac.dmg"
# Install all packages in correct order
# Pro Tools
installer -pkg "/Volumes/Pro Tools/Install Pro Tools 2020.11.0.pkg" -target /
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
# Copy user settings for the currently logged in user
# Make sure Outset is installed
if [[ -e "$outsetBinary" ]]; then
    echo "Outset binary found"
    # Run all login-privileged scripts to copy user content
    echo "Running all login-privileged scripts..."
    "$outsetBinary" --login-privileged
    echo "All login-privileged scripts completed"
    echo "Check the logs in /Library/Logs/Bauer/Outset for more detail"
else
    echo "Outset binary not found!"
    echo "Unable to copy any Pro Audio user settings"
    exit 1
fi
exit 0