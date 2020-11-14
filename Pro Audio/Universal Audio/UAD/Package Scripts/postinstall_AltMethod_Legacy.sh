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

# This method follows the method used by the vendor in copying the KEXTs into the relevant Extensions directory depending on the OS version

########################################################################
#                            Variables                                 #
########################################################################

# Get the logged in user
loggedInUser=$(stat -f %Su /dev/console)
# dockutil
dockutilLoc="/usr/local/bin/dockutil"
# Dock Items Array
dockItems=( "com.uaudio.uad_meter" "com.uaudio.console" "com.uaudio.ua_realtime_rack" "com.uaudio.uninstaller" )
# OS Version (Short)
osShort=$(sw_vers -productVersion | awk -F. '{print $2}')
# Extensions directory pre Catalina
kextPreCatalina="/System/Library/Extensions"
# Extensions directory Catalina or later
kextCatalinaLater="/Library/Extensions"

########################################################################
#                            Functions                                 #
########################################################################

function loadKEXT ()
{
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
}

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

# Move the KEXTs into correct Extensions directory

# Check the KEXTs are there
if [[ -d "/usr/local/UAD/UAD2System.kext" ]] && [[ -d "/usr/local/UAD/UAFWAudio.kext" ]]; then
	# Copy the to the correct Extensions directory based on the OS version
	echo "Moving KEXTs to correct Extensions directory..."
	# Catalina or later use /Library/Extensions/
	if [[ "$osShort" -ge "15" ]]; then
		# Doule check the previous KEXTs have been deleted
		rm -rf "${kextCatalinaLater}/UAD2System.kext" 2>/dev/null
		rm -rf "${kextCatalinaLater}/UAFWAudio.kext" 2>/dev/null
		# Move the latest versions from the temp location
		mv "/usr/local/UAD/UAD2System.kext" "${kextCatalinaLater}"
		mv "/usr/local/UAD/UAFWAudio.kext" "${kextCatalinaLater}"
		# Check the copy was successfull and set the correct permissions
		if [[ -d "${kextCatalinaLater}/UAD2System.kext" ]] && [[ -d "${kextCatalinaLater}/UAFWAudio.kext" ]]; then
			/usr/sbin/chown -R root:wheel "${kextCatalinaLater}/UAD2System.kext"
			/usr/sbin/chown -R root:wheel "${kextCatalinaLater}/UAFWAudio.kext"
			echo "KEXTs copied successfully"
			loadKEXT
		else
			echo "FAILED to copy KEXTs, install failed!"
			exit 1
		fi
	else
		# Pre Catalina use /System/Library/Extensions/
		# Doule check the previous KEXTs have been deleted
		rm -rf "${kextPreCatalina}/UAD2System.kext" 2>/dev/null
		rm -rf "${kextPreCatalina}/UAFWAudio.kext" 2>/dev/null
		# Move the latest versions from the temp location
		mv "/usr/local/UAD/UAD2System.kext" "${kextPreCatalina}"
		mv "/usr/local/UAD/UAFWAudio.kext" "${kextPreCatalina}"
		# Check the copy was successfull and set the correct permissions
		if [[ -e "${kextPreCatalina}/UAD2System.kext" ]] && [[ -e "${kextPreCatalina}/UAFWAudio.kext" ]]; then
			/usr/sbin/chown -R root:wheel "${kextPreCatalina}/UAD2System.kext"
			/usr/sbin/chown -R root:wheel "${kextPreCatalina}/UAFWAudio.kext"
			echo "KEXTs copied successfully"
			loadKEXT
		else
			echo "FAILED to copy KEXTs, install failed!"
			exit 1
		fi
	fi
else
	echo "KEXTs not found, install FAILED!"
	exit 1
fi

# Delete Meter Cache

rm -rf "/Users/$loggedInUser/Library/Caches/UAD Meter & Control Panel" 2>/dev/null

# Clean-up temp files

if [[ -d "/usr/local/UAD" ]] || [[ -e "$dockutilLoc" ]]; then
	rm -rf "/usr/local/UAD" 2>/dev/null
	rm -f "$dockutilLoc" 2>/dev/null
	if [[ ! -d "/usr/local/UAD" ]] || [[ ! -e "$dockutilLoc" ]]; then
		echo "Clean-up successful, all temp content deleted"
	else
		echo "Clean-up FAILED, manual clean-up required"
	fi
fi

exit 0