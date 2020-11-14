#!/bin/zsh

########################################################################
#     Install Cisco AnyConnect Secure Mobility Client - postinstall    #
################### Written by Phil Walker Sep 2020 ####################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# OS Version
osVersion=$(sw_vers -productVersion)
# macOS Big Sur version number
bigSur="11"
# Cisco config directory
configDir="/opt/cisco"
# Temp install location
installDir="/usr/local/ciscoanyconnect"
# Zip
packageZip="AnyConnect.pkg.zip"
# Package
ciscoPackage="AnyConnect.pkg"
# Legacy kernel extension
legacyKext="/Library/Application Support/Cisco/AnyConnect Secure Mobility Client/acsock.kext"
# Stage extension
legacyStaged="/Library/StagedExtensions/Library/Application Support/Cisco/AnyConnect Secure Mobility Client/acsock.kext"

########################################################################
#                         Script starts here                           #
########################################################################

# Install current package
# Unzip the package
unzip -q "${installDir}/${packageZip}" -d "$installDir"
sleep 2
if [[ -e "${installDir}/${ciscoPackage}" ]]; then
    echo "Installing Cisco AnyConnect Secure Mobility Client..."
    # Run Cisco AnyConnect installer with install switches from xml
    /usr/sbin/installer -applyChoiceChangesXML "${installDir}/anyconnect4-choices-vpn-only.xml" -pkg "${installDir}/${ciscoPackage}" -target /
    # wait for 10 seconds for install to complete
    sleep 10
    echo "Settings client preferences..."
    # Install client prefs to disable auto start on login and set connection address to myvpn.bauermedia.co.uk
    ditto -v "${installDir}/new.xml" "${configDir}/anyconnect/profile/"
    if [[ -f "${configDir}/anyconnect/profile/new.xml" ]]; then
        echo "Client preferences set successfully"
    else
        echo "Failed to set client preferences"
        exit 1
    fi
else
    echo "Cisco AnyConnect Secure Mobility Client package not found, exiting"
    exit 1
fi

# Move or remove the legacy kernel extension
# macOS Big Sur uses a system extension but all previous versions of macOS use the kernel extension
autoload is-at-least
if ! is-at-least "$bigSur" "$osVersion"; then
    if [[ -d "$legacyKext" ]]; then
        # Kext status
        kextCheck=$(kextstat -l | grep "com.cisco.kext.acsock" | awk '{print $6}')
        if [[ "$kextCheck" == "" ]]; then
            echo "Loading the Cisco AnyConnect kext..."
                while [[ "$kextCheck" == "" ]]; do
                    /sbin/kextload -b "com.cisco.kext.acsock" 2>/dev/null
                    sleep 2
                    # re-populate variable
                    kextCheck=$(kextstat -l | grep "com.cisco.kext.acsock" | awk '{print $6}')
                done
            echo "Cisco AnyConnect kext successfully loaded"
        else
            echo "Cisco AnyConnect kext loaded"
        fi
    else
        echo "Legacy kernel extension not found"
        echo "Cisco AnyConnect will not function correctly without the kext, reinstall the application"
        exit 1
    fi
else
    # If found, remove the legacy extension
    if [[ -d "$legacyKext" ]]; then
        echo "Removing legacy kernel extension"
        rm -rf "/Library/Application Support/Cisco"
        if [[ ! -d "$legacyKext" ]]; then
            echo "Legacy kernel extension removed"
        else
            echo "Failed to remove the legacy kernel extension"
        fi
    else
        echo "Legacy kernel extension not found"
    fi
fi

# If required, clear staged extensions and rebuild the kextcache
if [[ -d "$legacyStaged" ]]; then
    echo "Staged legacy extension found"
    echo "Clearing staged Cisco kernel extension"
    kextcache -prune-staging
fi

# Clean up temp content
rm -rf "$installDir"
if [[ ! -d "$installDir" ]]; then
    echo "Temp files cleaned up"
else
    echo "Failed to cleanup temp files, manual cleanup required"
fi
exit 0