#!/bin/bash

########################################################################
#       Uninversal Audio Digital Software, Firmware and Plugins        #
############################# postinstall ##############################
####################### Written by Phil Walker #########################
########################################################################

# Some of the below has been taken from the vendors package, most has not! :)
# I have removed sections/parts that are not required and sections/parts that are not designed for package deployment

# The package from the vendor included 9 scripts and multiple steps that are considered bad practice from an enterprise perspective
# Their package is very much aimed at a user with a personal Mac so I have re-engineered it to be more suitable for enterprise deployment

########################################################################
#                            Variables                                 #
########################################################################

# Get the logged in user
loggedInUser=$(stat -f %Su /dev/console)
# dockutil
dockutilLoc="/usr/local/bin/dockutil"
# Dock Items Array
dockItems=( "com.uaudio.uad_meter" "com.uaudio.console" "com.uaudio.ua_realtime_rack" "com.uaudio.uninstaller" )
# UAD Meter Launcher app path
meterLauncher="/Library/Application Support/Universal Audio/UAD Meter Launcher.app"
# UA Mixer Engine app path
mixerEngine="/Library/Application Support/Universal Audio/Apollo/UA Mixer Engine.app"

########################################################################
#                         Script starts here                           #
########################################################################

# Remove previous versions items from the Dock

if [[ -e "$dockutilLoc" ]]; then
	echo "Removing previous versions Dock items..."
	for dockitem in "${dockItems[@]}"; do
		"$dockutilLoc" --remove "$dockitem" --allhomes >/dev/null 2>&1
	done
	echo "Removed all previous Dock items"
else
	echo "dockutil not found, unable to remove items from the Dock"
fi

# Update firmware

# Run Meter passing firmware check command line switch.
# This command must be run as the user, not as root, or else it will
# leave a Juce lock file in ~/Library/Caches/Juce that will prevent
# non-root users from launching the meter
su "${loggedInUser}" -c '"/Applications/Universal Audio/UAD Meter & Control Panel.app/Contents/MacOS/UAD Meter & Control Panel" -fw'

# Delete Juce Cache Files

rm -f "$HOME/Library/Caches/Juce/juceAppLock_Console" 2>/dev/null
rm -f "$HOME/Library/Caches/Juce/juceAppLock_UAD Meter" 2>/dev/null
rm -f "$HOME/Library/Caches/Juce/juceAppLock_Console Shell" 2>/dev/null

rm -f "/Users/$loggedInUser/Library/Caches/Juce/juceAppLock_Console" 2>/dev/null
rm -f "/Users/$loggedInUser/Library/Caches/Juce/juceAppLock_UAD Meter" 2>/dev/null
rm -f "/Users/$loggedInUser/Library/Caches/Juce/juceAppLock_Console Shell" 2>/dev/null

# Load the KEXTs

# Check the KEXTs are there and then load them
if [[ -d "/Library/Extensions/UAD2System.kext" ]] && [[ -d "/Library/Extensions/UAFWAudio.kext" ]]; then
    # Set correct permission
	/usr/sbin/chown -R root:wheel "/Library/Extensions/UAD2System.kext"
	/usr/sbin/chown -R root:wheel "/Library/Extensions/UAFWAudio.kext"
    # Load the KEXTs
    /sbin/kextload -b "com.uaudio.driver.UAD2System" 2>/dev/null
    /sbin/kextload -b "com.uaudio.driver.UAFWAudio" 2>/dev/null
    sleep 2
    # Check the KEXTs have been loaded
    kextCheck=$(kextstat | grep "UAD\|UAF" | awk '{print $6}' | wc -l)
    if [[ "$kextCheck" -eq "2" ]]; then
	    echo "KEXTs loaded successfully"
    else
	    echo "Failed to load both KEXTs, restart needed"
    fi
else
	echo "KEXTs not found, vital components missing!"
	exit 1
fi

# Delete Meter Cache

rm -rf "/Users/$loggedInUser/Library/Caches/UAD Meter & Control Panel" 2>/dev/null

# Launch UAD Meter Launcher and UA Mixer Engine

# Check if the UAD Meter Launcher and UA Mixer Engine applications are installed
if [[ -d "$meterLauncher" ]] && [[ -d "$mixerEngine" ]]; then
    # If found, launch the apps
	echo "UAD Meter Launcher and UA Mixer Engine apps found"
	sudo -u "$loggedInUser" open -F "$meterLauncher"
	sudo -u "$loggedInUser" open -F "$mixerEngine"
	sleep 3
    # Confirm that the apps were launched successfully
	meterLauncherProc=$(ps -A | grep -v grep | grep "UAD Meter & Control Panel")
	mixerEnginerProc=$(ps -A | grep -v grep | grep "UA Mixer Engine")
	if [[ "$meterLauncherProc" != "" ]] && [[ "$meterLauncherProc" != "" ]]; then
		echo "UAD Meter Launcher and UA Mixer Engine launched successfully"
	else
		echo "Failed to launch UAD Meter Launcher and UA Mixer Engine, logout required"
	fi
else
# If not found, do nothing
	echo "UAD Meter Launcher and UA Mixer Engine apps not found, nothing to do"
fi

# Clean-up temp files

if [[ -e "$dockutilLoc" ]]; then
	rm -f "$dockutilLoc" 2>/dev/null
	if [[ ! -e "$dockutilLoc" ]]; then
		echo "Clean-up successful, all temp content deleted"
	else
		echo "Clean-up FAILED, manual clean-up required"
	fi
fi

exit 0