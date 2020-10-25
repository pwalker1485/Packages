#!/bin/bash

########################################################################
#                  Censhare Client Package - preinstall                #
#################### Written by Phil Walker Sept 2020 ##################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Legacy Kext
censhareLegacyKext="/System/Library/Extensions/CenshareFS.kext"
# Current Kext
censhareKext="/Library/Extensions/CenshareFS.kext"
# Application
censhareApp="/Applications/censhare Client.app"
# Kext status
kextCheck=$(kextstat -l | grep "com.censhare.vfs.CenshareFS" | awk '{print $6}')
# Censhare VFS launch daemon
vfsLaunchD="/Library/LaunchDaemons/com.censhare.vfs.launchd.plist"
# Censhare VFS helper launch daemon
vfsHelper="/Library/LaunchDaemons/com.censhare.vfs.Helper.plist"
# Censhare VFS launch daemons status
vfsLaunchDStatus=$(launchctl list | grep -c "com.censhare.vfs")
# InDesign CC 2019 Plugins
indesign2019Plugins="Applications/Adobe InDesign CC 2019/Plug-Ins/Censhare/"

########################################################################
#                         Script starts here                           #
########################################################################

# Unmount the censhare file system
if [[ "$(mount | grep "CenshareFS")" != "" ]]; then
    echo "Unmounting the Censhare file system..."
    mount -t 'CenshareFS' | sed 's/\(.*\)\( on \/\).*/umount -f \"\1\"/' | sh
    sleep 2
    if [[ "$(mount | grep "CenshareFS")" == "" ]]; then
        echo "Successfully unmounted the Censhare file system"
    else
        echo "Failed to unload the Censhare file system!"
    fi
fi

if [[ "$kextCheck" != "" ]]; then
    echo "Unloading the Censhare kext..."
    for kext in $kextCheck; do
        /sbin/kextunload -b "${kext}" 2>/dev/null
    done
    echo "Censhare kext successfully unloaded"
fi

# If the Censhare client is open, kill the process
if [[ $(pgrep "censhare Client") != "" ]]; then
    pkill -9 "censhare Client"
    sleep 5
    if [[ $(pgrep "censhare Client") == "" ]]; then
        echo "Censhare client closed"
    fi
fi

# Unload the Censhare Launch Daemons
if [[ "$vfsLaunchDStatus" -eq "2" ]]; then
    /bin/launchctl unload -w "$vfsLaunchD" > /dev/null 2>&1
    /bin/launchctl unload -w "$vfsHelper" > /dev/null 2>&1
    sleep 2
    # re-populate variable
    vfsLaunchDStatus=$(launchctl list | grep -c "com.censhare.vfs")
    if [[ "$vfsLaunchDStatus" -eq "0" ]]; then
        echo "All Censhare launch daemons successfully unloaded"
    else
        echo "Failed to unload Censhare launch daemons!"
    fi
fi

# Delete previous versions of the launch daemons
if [[ -f "$vfsLaunchD" ]] || [[ -f "$vfsHelper" ]]; then
    rm -f "$vfsLaunchD"
    rm -f "$vfsHelper"
    if [[ ! -f "$vfsLaunchD" ]] || [[ ! -f "$vfsHelper" ]]; then
        echo "Previous versions of the Censhare launch daemons removed successfully"
    else
        echo "Failed to remove previous versions of the Censhare launch daemons"
    fi
fi

# Delete previous versions of the Censhare kext
if [[ -d "$censhareLegacyKext" ]]; then
    rm -rf "$censhareLegacyKext"
    if [[ ! -d "$censhareLegacyKext" ]]; then
        echo "Previous version of the Censhare kext removed successfully"
    else
        echo "Failed to remove the previous version of the Censhare kext!"
    fi
fi
if [[ -d "$censhareKext" ]]; then
    rm -rf "$censhareKext"
    if [[ ! -d "$censhareKext" ]]; then
        echo "Previous version of the Censhare kext removed successfully"
    else
        echo "Failed to remove the previous version of the Censhare kext!"
    fi
fi

# Remove previous version of the app
if [[ -d "$censhareApp" ]]; then
    rm -rf "$censhareApp"
    sleep 2
    if [[ ! -d "$censhareApp" ]]; then
        echo "Previous version of the Censhare client removed successfully"
    else
        echo "Failed to remove the previous version of the client!"
    fi
fi

# Delete previous versions of the Adobe InDesign CC 2019 Plugins
if [[ -d "$indesign2019Plugins" ]]; then
    rm -rf "$indesign2019Plugins"
    if [[ ! -d "$indesign2019Plugins" ]]; then
        echo "Previous versions of the Censhare InDesign CC 2019 Plugins removed successfully"
    else
        echo "Failed to remove previos versions of the Censhare InDesign CC 2019 Plugins"
    fi
fi
exit 0