#!/bin/zsh

########################################################################
#     Install Cisco AnyConnect Secure Mobility Client - preinstall     #
################### Written by Phil Walker Sep 2020 ####################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Legacy kernel extension
legacyKext="/Library/Extensions/acsock.kext"
# Legacy kernel extension 4.9.03047 or later
legacyKextLatest="/Library/Application Support/Cisco/AnyConnect Secure Mobility Client/acsock.kext"
# Cisco client uninstall script
clientUninstall="/opt/cisco/anyconnect/bin/vpn_uninstall.sh"
# Cisco DART uninstall script
dartUninstall="/opt/cisco/anyconnect/bin/dart_uninstall.sh"
# Cisco DART app
dartApp="/Applications/Cisco/Cisco AnyConnect DART.app"
# Cisco config directory
configDir="/opt/cisco"

########################################################################
#                            Functions                                 #
########################################################################

function forgetCiscoReceipts ()
{
# Previous version receipt
previousReceipts=$(pkgutil --pkgs | grep -i "cisco")
if [[ "$previousReceipts" != "" ]]; then
    echo "Removing previous Cisco package receipts..."
    while IFS= read -r line; do 
        pkgutil --forget "$line"
    done <<< "$previousReceipts"
else
    echo "No previous Cisco package receipts found"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

# Remove all previous versions
# If found, run the Cisco AnyConnect client uninstaller
if [[ -f "$clientUninstall" ]]; then
    # Cisco uninstall script print status
	bash "$clientUninstall"
    sleep 2
else
	echo "No previous Cisco AnyConnect Secure Mobility Client found"
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
	echo "Removing previous Cisco client preferences..."
	rm -rf "$configDir"
    if [[ ! -d "$configDir" ]]; then
        echo "Previous Cisco client preferences removed"
    else
        echo "Failed to remove previous Cisco client preferences"
    fi
else
	echo "No previous Cisco client preferences found"
fi
# Remove previous package receipts
forgetCiscoReceipts

# If required, unload and remove the kernel extension
if [[ -d "$legacyKext" || -d "$legacyKextLatest" ]]; then
    # Kext status
    kextCheck=$(kextstat -l | grep "com.cisco.kext.acsock" | awk '{print $6}')
    if [[ "$kextCheck" != "" ]]; then
        echo "Unloading the Cisco AnyConnect kext..."
        while [[ "$kextCheck" != "" ]]; do
            /sbin/kextunload -b "com.cisco.kext.acsock" 2>/dev/null
            sleep 2
            # re-populate variable
            kextCheck=$(kextstat -l | grep "com.cisco.kext.acsock" | awk '{print $6}')
        done
        echo "Cisco AnyConnect kext successfully unloaded"
        rm -rf "$legacyKext" >/dev/null 2>&1
        rm -rf "$legacyKextLatest" >/dev/null 2>&1
    else
        echo "Cisco AnyConnect kext unloaded"
        rm -rf "$legacyKext" >/dev/null 2>&1
        rm -rf "$legacyKextLatest" >/dev/null 2>&1
    fi
    if [[ ! -d "$legacyKext" && ! -d "$legacyKextLatest" ]]; then
        echo "Cisco AnyConnect kext removed successfully"
    else
        echo "Failed to remove the Cisco AnyConnect kext"
    fi
else
    echo "Legacy kernel extension not found, nothing to do"
fi

exit 0