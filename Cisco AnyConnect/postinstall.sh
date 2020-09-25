#!/bin/bash

########################################################################
#     Install Cisco AnyConnect Secure Mobility Client - postinstall    #
################### Written by Phil Walker Sep 2020 ####################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Cisco client uninstall script
clientUninstall="/opt/cisco/anyconnect/bin/vpn_uninstall.sh"
# Cisco DART uninstall script
dartUninstall="/opt/cisco/anyconnect/bin/dart_uninstall.sh"
# Cisco app
ciscoApp="/Applications/Cisco/Cisco AnyConnect Secure Mobility Client.app"
# Cisco DART app
dartApp="/Applications/Cisco/Cisco AnyConnect DART.app"
# Cisco config directory
configDir="/opt/cisco"
# Temp install location
installDir="/usr/local/ciscoanyconnect"
# Zip
packageZip="UK_Cisco_AnyConnect_4.8.02045.pkg.zip"
# Package
ciscoPackage="UK_Cisco_AnyConnect_4.8.02045.pkg"
# Previous version receipt
previousReceipt="ciscoanyconnect4.6.02074"

########################################################################
#                         Script starts here                           #
########################################################################

# Remove all previous versions
# If found, run the Cisco AnyConnect client uninstaller
if [[ -f "$clientUninstall" ]]; then
	echo "Removing previous Cisco AnyConnect client..."
	bash "$clientUninstall"
	pkgutil --forget com.cisco.pkg.anyconnect.vpn >/dev/null 2>&1
    pkgutil --forget com.cisco.pkg.anyconnect.posture >/dev/null 2>&1
    pkgutil --forget "$previousReceipt" >/dev/null 2>&1
    sleep 2
    if [[ ! -d "$ciscoApp" ]]; then
        echo "Previous Cisco AnyConnect client removed"
    else
        echo "Failed to remove previous Cisco AnyConnect client"
    fi
else
	echo "No previous Cisco Client found"
fi
# If found, run the Cisco AnyConnect DART uninstaller
if [[ -f "$dartUninstall" ]]; then
	echo "Removing Cisco AnyConnect DART..."
	bash "$dartUninstall"
    sleep 2
    if [[ ! -d "$dartApp" ]]; then
        echo "Previous Cisco AnyConnect DART client removed"
    else
        echo "Failed to remove previous Cisco AnyConnect DART client"
    fi        
else
	echo "No previous Cisco AnyConnect DART found"
fi
# If found, remove previous Cisco preferences
if [[ -d "$configDir" ]]; then
	echo "Removing previous Cisco preferences..."
	rm -rf "$configDir"
    if [[ ! -d "$configDir" ]]; then
        echo "Previous Cisco preferences removed"
    else
        echo "Failed to remove previous Cisco preferences"
    fi
    pkgutil --forget com.cisco.pkg.anyconnect.vpn >/dev/null 2>&1
    pkgutil --forget com.cisco.pkg.anyconnect.posture >/dev/null 2>&1
    pkgutil --forget "$previousReceipt" >/dev/null 2>&1
else
	echo "No previous Cisco preferences found"
fi

# Install current package
# Unzip the package
echo "Installing Cisco AnyConnect..."
unzip -q "${installDir}/${packageZip}" -d "$installDir"
sleep 2
if [[ -e "${installDir}/${ciscoPackage}" ]]; then
    # Run Cisco AnyConnect installer with install switches from xml
    /usr/sbin/installer -applyChoiceChangesXML "${installDir}/anyconnect4-choices-vpn-only.xml" -pkg "${installDir}/${ciscoPackage}" -target /
    # wait for 10 seconds for install to complete
    sleep 10
    echo "Settings client preferences..."
    # Install client prefs to disable auto start on login and set connection address to myvpn.bauermedia.co.uk
    ditto -v "${installDir}/new.xml" "${configDir}/anyconnect/profile/"
    if [[ -f "${configDir}/anyconnect/profile/new.xml" ]]; then
        echo "Cisco AnyConnect preferences set"
    else
        echo "Failed to set Cisco AnyConnect preferences"
        exit 1
    fi
else
    echo "Cisco AnyConnect package not found, exiting"
    exit 1
fi

# Clean up
rm -rf "$installDir"
if [[ ! -d "$installDir" ]]; then
    echo "Temp files cleaned up"
else
    echo "Failed to cleanup temp files, manual cleanup required"
fi
exit 0