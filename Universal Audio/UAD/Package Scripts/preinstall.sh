#!/bin/bash

########################################################################
#       Uninversal Audio Digital Software, Firmware and Plugins        #
############################# preinstall ###############################
####################### Written by Phil Walker #########################
########################################################################

# Most of the below has been taken from the vendors package
# I have removed sections/parts that are not required and sections/parts that are not designed for package deployment
# Additions have been made to make it suitable for enterprise and deployment.
# As this is preinstall cleanup script I have not been through every step the vendor included to see if it's necessary in our environment

# The package from the vendor included 9 scripts and multiple steps that are considered bad practice from an enterprise perspective
# Their package is very much aimed at a user with a personal Mac so I have re-engineered it to be more suitable for enterprise deployment

########################################################################
#                            Variables                                 #
########################################################################

# Get the logged in user
loggedInUser=$(stat -f %Su /dev/console)
# OS Version (Short)
osShort=$(sw_vers -productVersion | awk -F. '{print $2}')

########################################################################
#                         Script starts here                           #
########################################################################

# Shut down LUNA - kill the process
lunaPID=$(ps -A | grep -v grep | grep "LUNA" | awk '{print $1}')
if [[ "$lunaPID" != "" ]]; then
    kill -9 "$lunaPID"
    sleep 2
    if [[ "$(ps -A | grep -v grep | grep "LUNA")" == "" ]]; then
        echo "LUNA process killed"
    else
        echo "Warning: Failed to kill LUNA process!"
    fi
fi

# Shut down UAD Meter - kill the process
uadMeterPID=$(ps -A | grep -v grep | grep "UAD Meter & Control Panel" | awk '{print $1}')
if [[ "$uadMeterPID" != "" ]]; then
    kill -9 "$uadMeterPID"
    sleep 2
    if [[ "$(ps -A | grep -v grep | grep "UAD Meter & Control Panel")" == "" ]]; then
        echo "UAD Meter process killed"
    else
        echo "Warning: Failed to kill UAD Meter process!"
    fi
fi

# Shut down the Console Shell App - kill the process
consolePID=$(ps -A | grep -v grep | grep "/Applications/Universal Audio/Console.app" | awk '{print $1}')
if [[ "$consolePID" != "" ]]; then
    kill -9 "$consolePID"
    sleep 2
    if [[ "$(ps -A | grep -v grep | grep "/Applications/Universal Audio/Console.app")" == "" ]]; then
        echo "Console Shell App killed"
    else
        echo "Warning: Failed to kill Console Shell App process!"
    fi
fi

# Shut down the mixer server - kill the process
mixerServerPID=$(ps -A | grep -v grep | grep "UA Mixer Engine" | awk '{print $1}')
if [[ "$mixerServerPID" != "" ]]; then
    kill -9 "$mixerServerPID"
    sleep 2
    if [[ "$(ps -A | grep -v grep | grep "UA Mixer Engine")" == "" ]]; then
        echo "Mixer Server process killed"
    else
        echo "Warning: Failed to kill Mixer Server process!"
    fi
fi

# Shut down the Realtime Rack - kill the process
realtimeRackPID=$(ps -A | grep -v grep | grep "Realtime Rack" | awk '{print $1}')
if [[ "$realtimeRackPID" != "" ]]; then
    kill -9 "$realtimeRackPID"
    sleep 2
    if [[ "$(ps -A | grep -v grep | grep "Realtime Rack")" == "" ]]; then
        echo "Realtime Rack process killed"
    else
        echo "Warning: Failed to kill Realtime Rack process!"
    fi
fi

# Remove the UAD Mixer Engine login item
if [[ -d "/Library/Application Support/Universal Audio/Apollo/UA Mixer Engine.app" ]]; then
    sudo -u "$loggedInUser" "/Library/Application Support/Universal Audio/Apollo/UA Mixer Engine.app/Contents/MacOS/UA Mixer Engine" -removelogin
fi

# Remove the pre-release startup item if present
if [[ -d "/Library/Application Support/Universal Audio/Apollo/UAD Mixer Engine.app" ]]; then
    sudo -u "$loggedInUser" "/Library/Application Support/Universal Audio/Apollo/UAD Mixer Engine.app/Contents/MacOS/UAD Mixer Engine" -removelogin
fi

if [[ -d "/Library/Application Support/Universal Audio/UAD Updater.app" ]]; then
    sudo -u "$loggedInUser" "/Library/Application Support/Universal Audio/UAD Updater.app/Contents/MacOS/UAD Updater" -n
fi

# Remove Meter Launcher
rm -rf "/Library/Application Support/Universal Audio/UAD Meter Launcher.app" 2>/dev/null

# Remove the contents of the Apollo directory
rm -rf "/Library/Application Support/Universal Audio/Apollo/UA CoreAudio Control Panel.app" 2>/dev/null
rm -rf "/Library/Application Support/Universal Audio/Apollo/UAD CoreAudio Control Panel.app" 2>/dev/null #pre-release name
rm -rf "/Library/Application Support/Universal Audio/Apollo/UA Mixer Engine.app" 2>/dev/null
rm -rf "/Library/Application Support/Universal Audio/Apollo/UAD Mixer Engine.app" 2>/dev/null #pre-release name

# Remove UA Media Engine
rm -rf "/Applications/Universal Audio/UA Media Engine.app" 2>/dev/null

# Remove Realtime Rack
rm -rf "/Applications/Universal Audio/Realtime Rack.app" 2>/dev/null
rm -rf "/Applications/Universal Audio/Live Rack.app" 2>/dev/null
rm -rf "/Library/Application Support/Universal Audio/Plug-In Icons" 2>/dev/null

# Remove the console
rm -rf "/Applications/Universal Audio/Console.app" 2>/dev/null
rm -rf "/Applications/Powered Plug-Ins Tools/Console.app" 2>/dev/null # pre-7.4 path
rm -rf "/Applications/Powered Plug-Ins Tools/UAD Console.app" 2>/dev/null # pre-release name

# Remove VST, AU and RTAS Console Recall plugins
rm -rf "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/Console Recall.vst" 2>/dev/null
rm -rf "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/UAD Console Recall.vst" 2>/dev/null # pre-release name

rm -rf "/Library/Audio/Plug-Ins/Components/Console Recall.component" 2>/dev/null
rm -rf "/Library/Audio/Plug-Ins/Components/UAD Console Recall.component" 2>/dev/null # pre-release name

rm -rf "/Library/Application Support/Digidesign/Plug-Ins/Universal Audio/Console Recall.dpm" 2>/dev/null
rm -rf "/Library/Application Support/Digidesign/Plug-Ins/Universal Audio/UAD Console Recall.dpm" 2>/dev/null # pre-release name

# Remove any JUCE lock files that may have been created
rm -f "$HOME/Library/Caches/Juce/juceAppLock_UA*" 2>/dev/null
rm -f "$HOME/Library/Caches/Juce/juceAppLock_Console*" 2>/dev/null
rm -f "$HOME/Library/Caches/Juce/MixerServerControlLock" 2>/dev/null

rm -f "/Users/$loggedInUser/Library/Caches/Juce/juceAppLock_UA*" 2>/dev/null
rm -f "/Users/$loggedInUser/Library/Caches/Juce/juceAppLock_Console*" 2>/dev/null
rm -f "/Users/$loggedInUser/Library/Caches/Juce/MixerServerControlLock" 2>/dev/null

# Remove the Apollo plug-in directory, if it exists
rm -rf "/Library/Application Support/Universal Audio/Apollo/Plugins" 2>/dev/null

# Remove TCAT components only installed by the TCAT installer
rm -rf "/Library/Audio/MIDI Drivers/UAFWAudioMIDIDriver" 2>/dev/null
rm -rf "/Library/Audio/MIDI Drivers/UAFWAudio.bundle" 2>/dev/null
rm -rf "/Library/Audio/MIDI Drivers/UAFWAudio.plugin" 2>/dev/null
rm -rf "/System/Library/PreferencePanes/UAFWAudio.prefPane" 2>/dev/null
rm -rf "/bin/UAFWAudio" 2>/dev/null
rm -rf "/Library/StartupItems/UAFWAudio" 2>/dev/null
rm -rf "/Library/Application Support/UAFWAudio/UAFWAudio" 2>/dev/null

# Remove TCAT components installed by our installer
rm -f "/Library/LaunchDaemons/com.uaudio.UAFWAudio.plist" 2>/dev/null
rm -rf "/Library/Application Support/UAFWAudio" 2>/dev/null

# Remove All previous content
# Always remove older-named versions of drivers, but not the current version
if [[ -d "/System/Library/Extensions/UADDriver.kext" ]] || [[ -d "/System/Library/Extensions/UADDriver.kext" ]]; then
    rm -rf "/System/Library/Extensions/UADDriver.kext" 2>/dev/null
    rm -rf "/System/Library/Extensions/UAD2Pcie.kext" 2>/dev/null
fi
rm -rf "/Library/Frameworks/UAD GUI Library.framework" 2>/dev/null
rm -rf "/Library/Frameworks/UAD-2 GUI Support.framework" 2>/dev/null
rm -rf "/Library/Frameworks/UAD-2 Plugin Support.framework" 2>/dev/null
rm -rf "/Library/Frameworks/UAD-2 SDK Support.framework" 2>/dev/null
rm -rf "/Library/Frameworks/UA Juce*" 2>/dev/null
rm -rf "/Library/Frameworks/UADHelper.app" 2>/dev/null
rm -f "/Library/CFMSupport/UAD GUI Library X" 2>/dev/null
rm -f "/Library/CFMSupport/UADHelper" 2>/dev/null
rm -rf "/Library/StartupItems/UADDriverLoader" 2>/dev/null

# do not remove directory if there are unexpected contents
if [[ -d "/Library/Application Support/Universal Audio" ]]; then
    rm -rf "/Library/Application Support/Universal Audio/UAD-1 Powered Plug-Ins/UAD*.vst"
    rm -f "/Library/Application Support/Universal Audio/UAD-1 Powered Plug-Ins/.DS_Store"
    rm -f "/Library/Application Support/Universal Audio/UAD-1 Powered Plug-Ins/Icon?"
    if [[ -d "/Library/Application Support/Universal Audio/UAD-1 Powered Plug-Ins" ]]; then
        rmdir "/Library/Application Support/Universal Audio/UAD-1 Powered Plug-Ins"
    fi

#do not remove directory if there are unexpected contents
    rm -rf "/Library/Application Support/Universal Audio/UAD-2 Powered Plug-Ins/UAD*.vst"
    rm -f "/Library/Application Support/Universal Audio/UAD-2 Powered Plug-Ins/.DS_Store"
    rm -f "/Library/Application Support/Universal Audio/UAD-2 Powered Plug-Ins/Icon?"
    if [[ -d "/Library/Application Support/Universal Audio/UAD-2 Powered Plug-Ins" ]]; then
        rmdir "/Library/Application Support/Universal Audio/UAD-2 Powered Plug-Ins"
    fi

#do not remove directory if there are unexpected contents
    if [[ -d "/Library/Application Support/Universal Audio/Apollo" ]]; then
        rmdir "/Library/Application Support/Universal Audio/Apollo"
    fi

    rm -rf "/Library/Application Support/Universal Audio/Firmware/UAD-2/FirmwareUpdate*"
    rm -f "/Library/Application Support/Universal Audio/Firmware/UAD-2/.DS_Store"
    if [[ -d "/Library/Application Support/Universal Audio/Firmware/UAD-2" ]]; then
        rmdir "/Library/Application Support/Universal Audio/Firmware/UAD-2"
    fi
    rm -f "/Library/Application Support/Universal Audio/Firmware/.DS_Store"
    if [[ -d "/Library/Application Support/Universal Audio/Firmware" ]]; then
        rmdir "/Library/Application Support/Universal Audio/Firmware"
    fi
    rm -f "/Library/Application Support/Universal Audio/Icon?"
    rm -f "/Library/Application Support/Universal Audio/.DS_Store"

  # clean up RTAS files
    rm -rf "/Library/Application Support/Universal Audio/com.Universal Audio.fxshared.bundle"
    if [[ -d "/Library/Application Support/Universal Audio/RTAS" ]]; then
        rm -Rf "/Library/Application Support/Universal Audio/RTAS/Template.dpm"
        rm -f "/Library/Application Support/Universal Audio/RTAS/.DS_Store"
        rmdir "/Library/Application Support/Universal Audio/RTAS"
    fi

  # clean up .irz files
  if [[ -d "/Library/Application Support/Universal Audio/Data" ]]; then
      rm -f "/Library/Application Support/Universal Audio/Data/Ocean Way Studios/OceanWayStudios.irz"
      rm -f "/Library/Application Support/Universal Audio/Data/Ocean Way Studios/.DS_Store"
      rmdir "/Library/Application Support/Universal Audio/Data/Ocean Way Studios"
	    rm -f "/Library/Application Support/Universal Audio/Data/Capitol Chambers/CapitolChambers.irz"
      rm -f "/Library/Application Support/Universal Audio/Data/Capitol Chambers/.DS_Store"
      rmdir "/Library/Application Support/Universal Audio/Data/Capitol Chambers"
      rm -f "/Library/Application Support/Universal Audio/Data/.DS_Store"
      rmdir "/Library/Application Support/Universal Audio/Data"
  fi

fi

# Delete "/Applications/Universal Audio" files

if [[ -d "/Applications/Universal Audio" ]]; then
    rm -f "/Applications/Universal Audio/ReadMe.rtf"
    if [[ -d "/Applications/Universal Audio/Documentation" ]]; then
        rm -f "/Applications/Universal Audio/Documentation/UAD System Manual.pdf"
        rm -f "/Applications/Universal Audio/Documentation/UAD Plug-Ins Manual.pdf"
        rm -f "/Applications/Universal Audio/Documentation/Apollo Hardware Manual.pdf"
        rm -f "/Applications/Universal Audio/Documentation/Apollo A16 Hardware Manual.pdf"
        rm -f "/Applications/Universal Audio/Documentation/Apollo Twin Hardware Manual.pdf"
        rm -f "/Applications/Universal Audio/Documentation/Apollo Software Manual.pdf"
        rm -f "/Applications/Universal Audio/Documentation/Apollo Software Manual - FireWire.pdf"
        rm -f "/Applications/Universal Audio/Documentation/Apollo Software Manual - Thunderbolt.pdf"
        rm -f "/Applications/Universal Audio/Documentation/Apollo Software Manual - USB.pdf"
        rmdir "/Applications/Universal Audio/Documentation"
    fi

    rm -rf "/Applications/Universal Audio/UAD Meter & Control Panel.app"
    rm -rf "/Library/Application Support/Universal Audio/UAD Updater.app"
    rm -rf "/Applications/Universal Audio/Console.app"
    rm -f "/Applications/Universal Audio/Icon?"
    rm -f "/Applications/Universal Audio/.DS_Store"
    rm -f "/Applications/Universal Audio/UA.xml"
    rm -rf "/Applications/Universal Audio/Uninstall Universal Audio Software.app"
    # Remove incorrect uninstaller folder that might have been created (see DAV-129)
    rm -rf "/Applications/Universal Audio/Uninstall Universal Audio Software.localized"
    rmdir "/Applications/Universal Audio"
fi

# Delete all pre-7.4 "/Applications/Powered Plug-Ins Tools" files

if [[ -d "/Applications/Powered Plug-Ins Tools" ]]; then
    rm -f "/Applications/Powered Plug-Ins Tools/UADManual.pdf"
    rm -f "/Applications/Powered Plug-Ins Tools/UAD-Xpander.pdf"
    rm -f "/Applications/Powered Plug-Ins Tools/ReadMe.rtf"
    if [[ -d "/Applications/Powered Plug-Ins Tools/Documentation" ]]; then
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/UAD System Manual.pdf"
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/UAD Plug-Ins Manual.pdf"
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/Apollo Hardware Manual.pdf"
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/Apollo Software Manual.pdf"
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/ATA_Manual.pdf"
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/bx_digital V2 Manual.pdf"
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/bx_digital V2 Mono Manual.pdf"
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/SPL Vitalizer MK2-T Manual.pdf"
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/UADManual.pdf"
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/UAD RTAS ReadMe.rtf"
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/Oxford EQ Manual.pdf"
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/Oxford Plug-Ins Toolbar and Preset Manager Manual.pdf"
        rm -f "/Applications/Powered Plug-Ins Tools/Documentation/*.pdf"
        rmdir "/Applications/Powered Plug-Ins Tools/Documentation"
    fi
    rm -f "/Applications/Powered Plug-Ins Tools/ATA_Manual.pdf" #old location
    rm -f "/Applications/Powered Plug-Ins Tools/UAD RTAS ReadMe.rtf" #old location
    rm -f "/Applications/Powered Plug-Ins Tools/QuickStart.pdf"
    rm -f "/Applications/Powered Plug-Ins Tools/ReadMe-VST.rtf"
    rm -f "/Applications/Powered Plug-Ins Tools/QuickStart-VST.pdf"
    rm -f "/Applications/Powered Plug-Ins Tools/ReadMe-AU.rtf"
    rm -f "/Applications/Powered Plug-Ins Tools/QuickStart-AU.pdf"
    rm -f "/Applications/Powered Plug-Ins Tools/ReadMe-RTAS.rtf"
    rm -f "/Applications/Powered Plug-Ins Tools/QuickStart-RTAS.pdf"
    rm -rf "/Applications/Powered Plug-Ins Tools/UAD-1 Meter.app"
    rm -rf "/Applications/Powered Plug-Ins Tools/UAD Meter.app"
    rm -rf "/Applications/Powered Plug-Ins Tools/UAD Meter & Control Panel.app"
    rm -rf "/Applications/Powered Plug-Ins Tools/Console.app"
    rm -rf "/Applications/Powered Plug-Ins Tools/UAD Console.app" # pre-release name

    rm -rf "/Applications/Powered Plug-Ins Tools/UA RTAS Utility.app"
    if [[ -d "/Applications/Powered Plug-Ins Tools/UAD-1 Driver Utility Folder" ]]; then
        rm -rf "/Applications/Powered Plug-Ins Tools/UAD-1 Driver Utility Folder/UA RTAS Utility.app"
        rm -rf "/Applications/Powered Plug-Ins Tools/UAD-1 Driver Utility Folder/UAD-1 Driver Utility.app"
        rm -f "/Applications/Powered Plug-Ins Tools/UAD-1 Driver Utility Folder/UAD-1 Driver Utility ReadMe.rtf"
        rm -f "/Applications/Powered Plug-Ins Tools/UAD-1 Driver Utility Folder/Icon?"
        rm -f "/Applications/Powered Plug-Ins Tools/UAD-1 Driver Utility Folder/.DS_Store"
        rmdir "/Applications/Powered Plug-Ins Tools/UAD-1 Driver Utility Folder"
    fi
    rm -f "/Applications/Powered Plug-Ins Tools/UAD-1 Installer Log"
    if [[ -d "/Applications/Powered Plug-Ins Tools/RTAS" ]]; then
        rm -f "/Applications/Powered Plug-Ins Tools/RTAS/*"
        rm -f "/Applications/Powered Plug-Ins Tools/RTAS/.DS_Store"
        rm -rf "/Applications/Powered Plug-Ins Tools/RTAS/VST to RTAS Adapter Config.app"
        rm -rf "/Applications/Powered Plug-Ins Tools/RTAS/UAD RTAS Installer.app"
        rmdir "/Applications/Powered Plug-Ins Tools/RTAS"
    fi
    if [[ -d "/Applications/Powered Plug-Ins Tools/UAD Driver Utility Folder" ]]; then
        rm -rf "/Applications/Powered Plug-Ins Tools/UAD Driver Utility Folder/UA RTAS Utility.app"
        rm -rf "/Applications/Powered Plug-Ins Tools/UAD Driver Utility Folder/UAD-1 Driver Utility.app"
        rm -rf "/Applications/Powered Plug-Ins Tools/UAD Driver Utility Folder/UAD-2 Driver Utility.app"
        rm -f "/Applications/Powered Plug-Ins Tools/UAD Driver Utility Folder/UAD Driver Utility ReadMe.rtf"
        rm -f "/Applications/Powered Plug-Ins Tools/UAD Driver Utility Folder/Icon?"
        rm -f "/Applications/Powered Plug-Ins Tools/UAD Driver Utility Folder/.DS_Store"
        rmdir "/Applications/Powered Plug-Ins Tools/UAD Driver Utility Folder"
    fi
    rm -f "/Applications/Powered Plug-Ins Tools/Icon?"
    rm -f "/Applications/Powered Plug-Ins Tools/.DS_Store"
    #delete directory only if no unexpected contents
    rm -f "/Applications/Powered Plug-Ins Tools/UA.xml"
    rmdir "/Applications/Powered Plug-Ins Tools"
fi

# remove UAD Meter that was mistakenly placed in Applications for some internal builds
if [[ -d "/Applications/UAD Meter & Control Panel.app" ]]; then
    rm -Rf "/Applications/UAD Meter & Control Panel.app"
fi

# remove mono wrappers
if [[ -d "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/Mono" ]]; then
    rm -rf "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/Mono/UAD*"
    rm -f "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/Mono/.DS_Store"
    rm -f "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/Mono/Icon?"
    rmdir "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/Mono"
fi

# remove VST plug-ins
if [[ -d "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins" ]]; then
    rm -rf "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/UAD*"
    rm -rf "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/Console Recall.vst"
    rm -f "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/.DS_Store"
    rm -f "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/Icon?"
    rmdir "/Library/Audio/Plug-Ins/VST/Powered Plug-Ins"
fi

# remove AU plug-ins
rm -rf "/Library/Audio/Plug-Ins/Components/UAD*.component"
rm -rf "/Library/Audio/Plug-Ins/Components/Console Recall.component"

# remove RTAS plug-ins
rm -rf "/Library/Application Support/Digidesign/Plug-Ins/VW_UAD*"
if [[ -d "/Library/Application Support/Digidesign/Plug-Ins/RTAS Powered Plug-Ins" ]]; then
    rm -rf "/Library/Application Support/Digidesign/Plug-Ins/RTAS Powered Plug-Ins/UAD*.dpm"
    rmdir "/Library/Application Support/Digidesign/Plug-Ins/RTAS Powered Plug-Ins"
fi
if [[ -d "/Library/Application Support/Digidesign/Plug-Ins/Universal Audio" ]]; then
    rm -rf "/Library/Application Support/Digidesign/Plug-Ins/Universal Audio/UAD*.dpm"
    rm -rf "/Library/Application Support/Digidesign/Plug-Ins/Universal Audio/Console Recall.dpm"
    rm -f "/Library/Application Support/Digidesign/Plug-Ins/Universal Audio/.DS_Store"
    rm -f "/Library/Application Support/Digidesign/Plug-Ins/Universal Audio/Icon?"
    rmdir "/Library/Application Support/Digidesign/Plug-Ins/Universal Audio"
fi

# remove AAX plug-ins
if [[ -d "/Library/Application Support/Avid/Audio/Plug-Ins/Universal Audio" ]]; then
    rm -rf "/Library/Application Support/Avid/Audio/Plug-Ins/Universal Audio/UAD*.aaxplugin"
    rm -rf "/Library/Application Support/Avid/Audio/Plug-Ins/Universal Audio/Console Recall.aaxplugin"
    rm -f "/Library/Application Support/Avid/Audio/Plug-Ins/Universal Audio/.DS_Store"
    rm -f "/Library/Application Support/Avid/Audio/Plug-Ins/Universal Audio/Icon?"
    rmdir "/Library/Application Support/Avid/Audio/Plug-Ins/Universal Audio"
fi

rm -f "/Library/Application Support/Digidesign/Plug-Ins/test.bin"
rm -rf "/Library/Application Support/FXpansion/com.fxpansion.fxshared2.bundle"

rm -f "/Library/Application Support/Universal Audio/UA.xml"
rm -rf "/Library/Application Support/Universal Audio/com.Universal Audio.fxshared.bundle"


# Unload and Delete KEXTs
# If any UAD KEXTs are loaded, unload them
kextCheck=$(kextstat | grep "UAD\|UAF" | awk '{print $6}')
if [[ "$kextCheck" != "" ]]; then
    for kext in "$kextCheck"; do
        /sbin/kextunload -b "${kext}" 2>/dev/null
    done
fi

# Remove existing KEXTs
# Pre Catalina
rm -rf "/System/Library/Extensions/UAD2System.kext" 2>/dev/null
rm -rf "/System/Library/Extensions/UAFWAudio.kext" 2>/dev/null
# Catalina or later
rm -rf "/Library/Extensions/UAD2System.kext" 2>/dev/null
rm -rf "/Library/Extensions/UAFWAudio.kext" 2>/dev/null


# Check if the KEXTs exist in /Library/StagedExtensions/System/Library/Extensions/
# If they exist then the Mac has been upgraded to Catalina with UAD installed
if [[ "$osShort" -ge "15" ]]; then
    if [[ -d "/Library/StagedExtensions/System/Library/Extensions/UAD2System.kext" ]]; then
        echo "Clearing Staged Extensions"
        kextcache -clear-staging
        echo "Rebuilding the kextcache"
        kextcache -u / -f >/dev/null 2>&1
    fi
fi

# delete uad1-only mono
#UAD-1 only mono
VSTMONODIR="/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/Mono"

if [[ -d "${VSTMONODIR}/UAD DelayComp(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD DelayComp(m).vst"
fi
# this is NOT a UAD-1 only plug, disabling due to issue with a crash
if [[ -d "${VSTMONODIR}/UAD Fairchild Mono.vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Fairchild Mono.vst"
fi
if [[ -d "${VSTMONODIR}/UAD GateComp(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD GateComp(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD ModFilter(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD ModFilter(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD Nigel(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Nigel(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD Phasor(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Phasor(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD Preflex(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Preflex(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD TrackAdv(m).vst" ]]; then
  rm -rf "${VSTMONODIR}/UAD TrackAdv(m).vst"
fi

if [[ -d "${VSTMONODIR}/UAD TremModEcho(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD TremModEcho(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD Tremolo(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Tremolo(m).vst"
fi

# delete uad1-only vst
#UAD-1 only vst wrapped plugins
VSTDIR="/Library/Audio/Plug-Ins/VST/Powered Plug-Ins"

if [[ -d "${VSTDIR}/UAD DelayComp.vst" ]]; then
    rm -rf "${VSTDIR}/UAD DelayComp.vst"
fi
if [[ -d "${VSTDIR}/UAD GateComp.vst" ]]; then
    rm -rf "${VSTDIR}/UAD GateComp.vst"
fi
if [[ -d "${VSTDIR}/UAD ModFilter.vst" ]]; then
    rm -rf "${VSTDIR}/UAD ModFilter.vst"
fi
if [[ -d "${VSTDIR}/UAD Nigel.vst" ]]; then
    rm -rf "${VSTDIR}/UAD Nigel.vst"
fi
if [[ -d "${VSTDIR}/UAD Phasor.vst" ]]; then
    rm -rf "${VSTDIR}/UAD Phasor.vst"
fi
if [[ -d "${VSTDIR}/UAD Preflex.vst" ]]; then
    rm -rf "${VSTDIR}/UAD Preflex.vst"
fi
if [[ -d "${VSTDIR}/UAD TrackAdv.vst" ]]; then
    rm -rf "${VSTDIR}/UAD TrackAdv.vst"
fi
if [[ -d "${VSTDIR}/UAD TremModEcho.vst" ]]; then
    rm -rf "${VSTDIR}/UAD TremModEcho.vst"
fi
if [[ -d "${VSTDIR}/UAD Tremolo.vst" ]]; then
    rm -rf "${VSTDIR}/UAD Tremolo.vst"
fi

# delete uad1-only au
#UAD-1 AU only vst wrapped plugins
AUCOMPDIR="/Library/Audio/Plug-Ins/Components"

if [[ -d "${AUCOMPDIR}/UAD DelayComp.component" ]]; then
    rm -rf "${AUCOMPDIR}/UAD DelayComp.component"
fi
if [[ -d "${AUCOMPDIR}/UAD Fairchild Mono.component" ]]; then
    rm -rf "${AUCOMPDIR}/UAD Fairchild Mono.component"
fi
if [[ -d "${AUCOMPDIR}/UAD GateComp.component" ]]; then
    rm -rf "${AUCOMPDIR}/UAD GateComp.component"
fi
if [[ -d "${AUCOMPDIR}/UAD ModFilter.component" ]]; then
    rm -rf "${AUCOMPDIR}/UAD ModFilter.component"
fi
if [[ -d "${AUCOMPDIR}/UAD Nigel.component" ]]; then
    rm -rf "${AUCOMPDIR}/UAD Nigel.component"
fi
if [[ -d "${AUCOMPDIR}/UAD Phasor.component" ]]; then
    rm -rf "${AUCOMPDIR}/UAD Phasor.component"
fi
if [[ -d "${AUCOMPDIR}/UAD Preflex.component" ]]; then
    rm -rf "${AUCOMPDIR}/UAD Preflex.component"
fi
if [[ -d "${AUCOMPDIR}/UAD TrackAdv.component" ]]; then
    rm -rf "${AUCOMPDIR}/UAD TrackAdv.component"
fi
if [[ -d "${AUCOMPDIR}/UAD TremModEcho.component" ]]; then
    rm -rf "${AUCOMPDIR}/UAD TremModEcho.component"
fi
if [[ -d "${AUCOMPDIR}/UAD Tremolo.component" ]]; then
    rm -rf "${AUCOMPDIR}/UAD Tremolo.component"
fi

# delete uad2-only mono ---
#UAD-2 Mono only VST plugins delete
VSTMONODIR="/Library/Audio/Plug-Ins/VST/Powered Plug-Ins/Mono"

if [[ -d "${VSTMONODIR}/UAD Cooper Time Cube(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Cooper Time Cube(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD EL7 FATSO Jr(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD EL7 FATSO Jr(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD EL7 FATSO Sr(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD EL7 FATSO Sr(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD EMT 250(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD EMT 250(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD Manley Massive Passive(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Manley Massive Passive(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD Manley Massive Passive MST(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Manley Massive Passive MST(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD Precision Enhancer Hz(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Precision Enhancer Hz(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD EP-34 Tape Echo(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD EP-34 Tape Echo(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD Studer A800(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Studer A800(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD SSL E Channel Strip(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD SSL E Channel Strip(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD SSL G Bus Compressor(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD SSL G Bus Compressor(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD Lexicon 224(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Lexicon 224(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD SPL Vitalizer MK2-T(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD SPL Vitalizer MK2-T(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD bx_digital V2 Mono(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD bx_digital V2 Mono(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD Ampex ATR-102(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Ampex ATR-102(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD Little Labs VOG(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD Little Labs VOG(m).vst"
fi
if [[ -d "${VSTMONODIR}/UAD MXR Flanger-Doubler(m).vst" ]]; then
    rm -rf "${VSTMONODIR}/UAD MXR Flanger-Doubler(m).vst"
fi

# delete uad2-only vst ---
#UAD-2 only plugins
VSTDIR="/Library/Audio/Plug-Ins/VST/Powered Plug-Ins"

if [[ -d "${VSTDIR} Cooper Time Cube.vst" ]]; then
    rm -rf "${VSTDIR} Cooper Time Cube.vst"
fi
if [[ -d "${VSTDIR} EL7 FATSO Jr.vst" ]]; then
    rm -rf "${VSTDIR} EL7 FATSO Jr.vst"
fi
if [[ -d "${VSTDIR} EL7 FATSO Sr.vst" ]]; then
    rm -rf "${VSTDIR} EL7 FATSO Sr.vst"
fi
if [[ -d "${VSTDIR} EMT 250.vst" ]]; then
    rm -rf "${VSTDIR} EMT 250.vst"
fi
if [[ -d "${VSTDIR} Manley Massive Passive.vst" ]]; then
    rm -rf "${VSTDIR} Manley Massive Passive.vst"
fi
if [[ -d "${VSTDIR} Manley Massive Passive MST.vst" ]]; then
    rm -rf "${VSTDIR} Manley Massive Passive MST.vst"
fi
if [[ -d "${VSTDIR} Precision Enhancer Hz.vst" ]]; then
    rm -rf "${VSTDIR} Precision Enhancer Hz.vst"
fi
if [[ -d "${VSTDIR} EP-34 Tape Echo.vst" ]]; then
    rm -rf "${VSTDIR} EP-34 Tape Echo.vst"
fi
if [[ -d "${VSTDIR} Studer A800.vst" ]]; then
    rm -rf "${VSTDIR} Studer A800.vst"
fi
if [[ -d "${VSTDIR} SSL E Channel Strip.vst" ]]; then
    rm -rf "${VSTDIR} SSL E Channel Strip.vst"
fi
if [[ -d "${VSTDIR} SSL G Bus Compressor.vst" ]]; then
    rm -rf "${VSTDIR} SSL G Bus Compressor.vst"
fi
if [[ -d "${VSTDIR} Lexicon 224.vst" ]]; then
    rm -rf "${VSTDIR} Lexicon 224.vst"
fi
if [[ -d "${VSTDIR} SPL Vitalizer MK2-T.vst" ]]; then
    rm -rf "${VSTDIR} SPL Vitalizer MK2-T.vst"
fi
if [[ -d "${VSTDIR} bx_digital V2.vst" ]]; then
    rm -rf "${VSTDIR} bx_digital V2.vst"
fi
if [[ -d "${VSTDIR} bx_digital V2 Mono.vst" ]]; then
    rm -rf "${VSTDIR} bx_digital V2 Mono.vst"
fi
if [[ -d "${VSTDIR} Ampex ATR-102.vst" ]]; then
    rm -rf "${VSTDIR} Ampex ATR-102.vst"
fi
if [[ -d "${VSTDIR} Little Labs VOG.vst" ]]; then
    rm -rf "${VSTDIR} Little Labs VOG.vst"
fi
if [[ -d "${VSTDIR} MXR Flanger-Doubler.vst" ]]; then
    rm -rf "${VSTDIR} MXR Flanger-Doubler.vst"
fi

# delete uad2-only au ---
#UAD-2 AU only plugins
AUCOMPDIR="/Library/Audio/Plug-Ins/Components"

if [[ -d "${AUCOMPDIR} Cooper Time Cube.vst" ]]; then
    rm -rf "${AUCOMPDIR} Cooper Time Cube.vst"
fi
if [[ -d "${AUCOMPDIR} EL7 FATSO Jr.vst" ]]; then
    rm -rf "${AUCOMPDIR} EL7 FATSO Jr.vst"
fi
if [[ -d "${AUCOMPDIR} EL7 FATSO Sr.vst" ]]; then
    rm -rf "${AUCOMPDIR} EL7 FATSO Sr.vst"
fi
if [[ -d "${AUCOMPDIR} EMT 250.vst" ]]; then
    rm -rf "${AUCOMPDIR} EMT 250.vst"
fi
if [[ -d "${AUCOMPDIR} Manley Massive Passive.vst" ]]; then
    rm -rf "${AUCOMPDIR} Manley Massive Passive.vst"
fi
if [[ -d "${AUCOMPDIR} Manley Massive Passive MST.vst" ]]; then
    rm -rf "${AUCOMPDIR} Manley Massive Passive MST.vst"
fi
if [[ -d "${AUCOMPDIR} Precision Enhancer Hz.vst" ]]; then
    rm -rf "${AUCOMPDIR} Precision Enhancer Hz.vst"
fi
if [[ -d "${AUCOMPDIR} EP-34 Tape Echo.vst" ]]; then
    rm -rf "${AUCOMPDIR} EP-34 Tape Echo.vst"
fi
if [[ -d "${AUCOMPDIR} Studer A800.vst" ]]; then
    rm -rf "${AUCOMPDIR} Studer A800.vst"
fi
if [[ -d "${AUCOMPDIR} SSL E Channel Strip.vst" ]]; then
    rm -rf "${AUCOMPDIR} SSL E Channel Strip.vst"
fi
if [[ -d "${AUCOMPDIR} SSL G Bus Compressor.vst" ]]; then
    rm -rf "${AUCOMPDIR} SSL G Bus Compressor.vst"
fi
if [[ -d "${AUCOMPDIR} Lexicon 224.vst" ]]; then
    rm -rf "${AUCOMPDIR} Lexicon 224.vst"
fi
if [[ -d "${AUCOMPDIR} SPL Vitalizer MK2-T.vst" ]]; then
    rm -rf "${AUCOMPDIR} SPL Vitalizer MK2-T.vst"
fi
if [[ -d "${AUCOMPDIR} bx_digital V2.vst" ]]; then
    rm -rf "${AUCOMPDIR} bx_digital V2.vst"
fi
if [[ -d "${AUCOMPDIR} bx_digital V2 Mono.vst" ]]; then
    rm -rf "${AUCOMPDIR} bx_digital V2 Mono.vst"
fi
if [[ -d "${AUCOMPDIR} Ampex ATR-102.vst" ]]; then
    rm -rf "${AUCOMPDIR} Ampex ATR-102.vst"
fi
if [[ -d "${AUCOMPDIR} Little Labs VOG.vst" ]]; then
    rm -rf "${AUCOMPDIR} Little Labs VOG.vst"
fi
if [[ -d "${AUCOMPDIR} MXR Flanger-Doubler.vst" ]]; then
    rm -rf "${AUCOMPDIR} MXR Flanger-Doubler.vst"
fi

# delete apollo-only
UADIR="/Library/Application Support/Universal Audio/UAD-2 Powered Plug-Ins"
VSTDIR="/Library/Audio/Plug-Ins/VST/Powered Plug-Ins"
AUCOMPDIR="/Library/Audio/Plug-Ins/Components"

if [[ -d "${UADIR}/Console Recall.vst" ]]; then
    rm -rf "${UADIR}/Console Recall.vst"
fi

if [[ -d "${VSTDIR}/Console Recall.vst" ]]; then
    rm -rf "${VSTDIR}/Console Recall.vst"
fi

if [[ -d "${AUCOMPDIR}/Console Recall.component" ]]; then
    rm -rf "${AUCOMPDIR}/Console Recall.component"
fi

# delete old documentation
rm -f "/Applications/Universal Audio/Documentation/"*.pdf
rm -f "/Applications/Universal Audio/ReadMe.rtf"
rmdir "/Applications/Universal Audio/Documentation"

# clean up of pre 7.4 doc
rm -f "/Applications/Powered Plug-Ins Tools/Documentation/UAD RTAS ReadMe.rtf"

rm -f "/Applications/Powered Plug-Ins Tools/UADManual.pdf"

rm -f "/Applications/Powered Plug-Ins Tools/SPL Vitalizer MK2-T Manual.pdf"
rm -f "/Applications/Powered Plug-Ins Tools/bx_digital V2 Manual.pdf"
rm -f "/Applications/Powered Plug-Ins Tools/bx_digital V2 Mono Manual.pdf"

rm -f "/Applications/Powered Plug-Ins Tools/UAD RTAS ReadMe.rtf"
rm -f "/Applications/Powered Plug-Ins Tools/ATA_Manual.pdf"

# clean up of post 6.4 doc
rm -f "/Applications/Powered Plug-Ins Tools/Documentation/"*.pdf

# delete RTAS pre-install
rm -f "/Applications/Powered Plug-Ins Tools/RTAS/*"
# the 5.8 release shipped with these two RTAS dummy files as folders rather than files
if [[ -d "/Applications/Powered Plug-Ins Tools/RTAS/68" ]]; then
    rmdir "/Applications/Powered Plug-Ins Tools/RTAS/68"
fi
if [[ -d "/Applications/Powered Plug-Ins Tools/RTAS/69" ]]; then
    rmdir "/Applications/Powered Plug-Ins Tools/RTAS/69"
fi
rm -f "/Applications/Powered Plug-Ins Tools/RTAS/.DS_Store"
rm -rf "/Applications/Powered Plug-Ins Tools/RTAS/VST to RTAS Adapter Config.app"
if [[ -d "/Applications/Powered Plug-Ins Tools/RTAS" ]]; then
    rmdir "/Applications/Powered Plug-Ins Tools/RTAS"
fi
rm -f "/Library/Application Support/Digidesign/Plug-Ins/test.bin"
#remove 5.9.1 and earlier UA wrapped plugs
rm -rf "/Library/Application Support/Digidesign/Plug-Ins/VW_UAD*"
if [[ -d "/Library/Application Support/Digidesign/Plug-Ins/RTAS Powered Plug-Ins" ]]; then
    rm -rf "/Library/Application Support/Digidesign/Plug-Ins/RTAS Powered Plug-Ins/UAD*"
    rm -f "/Library/Application Support/Digidesign/Plug-Ins/RTAS Powered Plug-Ins/.DS_Store"
    rmdir "/Library/Application Support/Digidesign/Plug-Ins/RTAS Powered Plug-Ins"
fi

#this should not be needed, used for bug 4170
#earlier v600 builds had left this folder on an uninstall
if [[ -d "/Applications/Universal Audio" ]];then
    rm -rf "/Applications/Universal Audio"
fi

# rtas plug-in settings rename
if [[ -d "/Library/Application Support/Digidesign/Plug-In Settings" ]]; then
    cd "/Library/Application Support/Digidesign/Plug-In Settings"
    if [[ -d "VST UAD 4K Buss " ]]; then
        if [[ ! -d "UAD 4K Bus Comp" ]]; then
	          mv -f "VST UAD 4K Buss "		"UAD 4K Bus Comp"
        fi
    fi
    if [[ -d "VST UAD 4K Chann" ]]; then
        if [[ ! -d "UAD 4K Chn Strip" ]]; then
	          mv -f "VST UAD 4K Chann"		"UAD 4K Chn Strip"
        fi
    fi
    if [[ -d "VST UAD 1176LN" ]]; then
        if [ ! -d "UAD 1176LN" ]]; then
	          mv -f "VST UAD 1176LN"			"UAD 1176LN"
        fi
    fi
    if [[ -d "VST UAD 1176SE" ]]; then
        if [[ ! -d "UAD 1176SE" ]]; then
	          mv -f "VST UAD 1176SE"			"UAD 1176SE"
        fi
    fi
    if [[ -d "VST UAD Cambridg" ]]; then
        if [[ ! -d "UAD Cambridge" ]]; then
	          mv -f "VST UAD Cambridg"		"UAD Cambridge"
        fi
    fi
    if [[ -d "VST UAD Cooper T" ]]; then
        if [[ ! -d "UAD CooprTmCbe" ]]; then
	          mv -f "VST UAD Cooper T"		"UAD CooprTmCbe"
        fi
    fi
    if [[ -d "VST UAD CS-1" ]]; then
        if [[ ! -d "UAD CS-1" ]]; then
	          mv -f "VST UAD CS-1"			"UAD CS-1"
        fi
    fi
    if [[ -d "VST UAD dbx 160" ]]; then
        if [[ ! -d "UAD dbx 160" ]]; then
	          mv -f "VST UAD dbx 160"			"UAD dbx 160"
        fi
    fi
    if [[ -d "VST UAD DelayCom" ]]; then
        if [[ ! -d "UAD DelayComp" ]]; then
	          mv -f "VST UAD DelayCom"		"UAD DelayComp"
        fi
    fi
    if [[ -d "VST UAD DM-1" ]]; then
        if [[ ! -d "UAD DM-1" ]]; then
	          mv -f "VST UAD DM-1"			"UAD DM-1"
        fi
    fi
    if [[ -d "VST UAD DM-1L" ]]; then
        if [[ ! -d "UAD DM-1L" ]]; then
	          mv -f "VST UAD DM-1L"			"UAD DM-1L"
        fi
    fi
    if [[ -d "VST UAD DreamVer" ]]; then
        if [[ ! -d "UAD DreamVerb" ]]; then
	          mv -f "VST UAD DreamVer"    	"UAD DreamVerb"
        fi
    fi
    if [[ -d "VST UAD EL7 FATS" ]]; then
        if [[ ! -d "UAD EL7 FATSO" ]]; then
	          mv -f "VST UAD EL7 FATS"	"UAD EL7 FATSO"
	          cd "UAD EL7 FATSO"
	          mv -f "EL7 FATSO Jr"		"UAD EL7 FATSO Jr"
	          mv -f "EL7 FATSO Sr"		"UAD EL7 FATSO Sr"
	          cd ..
	          if [[ ! -d "UAD EL7 FATSO Jr" ]]; then
	              mv -f "UAD EL7 FATSO/UAD EL7 FATSO Jr"		"UAD EL7 FATSO Jr"
            fi
	          if [[ ! -d "UAD EL7 FATSO Sr" ]]; then
	              mv -f "UAD EL7 FATSO/UAD EL7 FATSO Sr"		"UAD EL7 FATSO Sr"
            fi
        fi
    fi
    if [[ -d "VST UAD EMT 140" ]]; then
        if [[ ! -d "UAD EMT 140" ]]; then
	          mv -f "VST UAD EMT 140"			"UAD EMT 140"
        fi
    fi
    if [[ -d "VST UAD EMT 250" ]]; then
        if [[ ! -d "UAD EMT 250" ]]; then
	          mv -f "VST UAD EMT 250"			"UAD EMT 250"
        fi
    fi
    if [[ -d "VST UAD EP-34 Ta" ]]; then
        if [[ ! -d "UAD EP-34 Echo" ]]; then
	          mv -f "VST UAD EP-34 Ta"    	"UAD EP-34 Echo"
        fi
    fi
    if [[ -d "VST UAD EX-1" ]]; then
        if [[ ! -d "UAD EX-1" ]]; then
	          mv -f "VST UAD EX-1"			"UAD EX-1"
        fi
    fi
    if [[ -d "VST UAD Fairchil" ]]; then
        if [[ ! -d "UAD Fairchild" ]]; then
	          mv -f "VST UAD Fairchil"    	"UAD Fairchild"
        fi
    fi
    if [[ -d "VST UAD GateComp" ]]; then
        if [[ ! -d "UAD GateComp" ]]; then
	          mv -f "VST UAD GateComp"    	"UAD GateComp"
        fi
    fi
    if [[ -d "VST UAD Harrison" ]]; then
        if [[ ! -d "UAD Harrison 32C" ]]; then
	          mv -f "VST UAD Harrison"		"UAD Harrison 32C"
        fi
    fi
    if [[ -d "VST UAD Helios 6" ]]; then
        if [[ ! -d "UAD Helios 69" ]]; then
	          mv -f "VST UAD Helios 6"		"UAD Helios 69"
        fi
    fi
    if [[ -d "VST UAD LA2A" ]]; then
        if [[ ! -d "UAD LA2A" ]]; then
	          mv -f "VST UAD LA2A"			"UAD LA2A"
        fi
    fi
    if [[ -d "VST UAD LA3A" ]]; then
        if [[ ! -d "UAD LA3A" ]]; then
	          mv -f "VST UAD LA3A"			"UAD LA3A"
        fi
    fi
    if [[ -d "VST UAD Lex 224" ]]; then
        if [[ ! -d "UAD Lexicon 224" ]]; then
	          mv -f "VST UAD Lex 224"			"UAD Lexicon 224"
        fi
    fi
    if [[ -d "VST UAD Little L" ]]; then
        if [[ ! -d "UAD LilLabs IBP" ]]; then
	          mv -f "VST UAD Little L"    	"UAD LilLabs IBP"
        fi
    fi
    if [[ -d "VST UAD MMP" ]]; then
        if [[ ! -d "UAD MasPassive" ]]; then
	          mv -f "VST UAD MMP"				"UAD MasPassive"
        fi
    fi
    if [[ -d "VST UAD MMP MST" ]]; then
        if [[ ! -d "UAD MasPasMST" ]]; then
	          mv -f "VST UAD MMP MST"			"UAD MasPasMST"
        fi
    fi
    if [[ -d "VST UAD ModFilte" ]]; then
        if [[ ! -d "UAD ModFilter" ]]; then
	          mv -f "VST UAD ModFilte"		"UAD ModFilter"
        fi
    fi
    if [[ -d "VST UAD Moog Fil" ]]; then
        if [[ ! -d "UAD Moog Filter" ]]; then
	      mv -f "VST UAD Moog Fil"		"UAD Moog Filter"
        fi
    fi
    if [[ -d "VST UAD Neve 88R" ]]; then
        if [[ ! -d "UAD Neve 88RS" ]]; then
	          mv -f "VST UAD Neve 88R"		"UAD Neve 88RS"
        fi
    fi
    if [[ -d "VST UAD Neve 107" ]]; then
        if [[ ! -d "UAD Neve 1073" ]]; then
	          mv -f "VST UAD Neve 107"		"UAD Neve 1073"
        fi
    fi
    if [[ -d "VST UAD Neve 108" ]]; then
        if [[ ! -d "UAD Neve 1081" ]]; then
	          mv -f "VST UAD Neve 108"		"UAD Neve 1081"
        fi
    fi
    if [[ -d "VST UAD Neve 311" ]]; then
        if [[ ! -d "UAD Neve 31102" ]]; then
	          mv -f "VST UAD Neve 311"		"UAD Neve 31102"
        fi
    fi
    if [[ -d "VST UAD Neve 336" ]]; then
        if [[ ! -d "UAD Neve 33609" ]]; then
	          mv -f "VST UAD Neve 336"		"UAD Neve 33609"
        fi
    fi
    if [[ -d "VST UAD Nigel" ]]; then
        if [[ ! -d "UAD Nigel" ]]; then
	          mv -f "VST UAD Nigel"			"UAD Nigel"
        fi
    fi
    if [[ -d "VST UAD Phasor" ]]; then
        if [[ ! -d "UAD Phasor" ]]; then
	          mv -f "VST UAD Phasor"			"UAD Phasor"
        fi
    fi
    if [[ -d "VST UAD Prec Hz" ]]; then
        if [[ ! -d "UAD P Enh Hz" ]]; then
	          mv -f "VST UAD Prec Hz"			"UAD P Enh Hz"
        fi
    fi
    if [[ -d "VST UAD Precisio" ]]; then
        if [[ ! -d "UAD Precision" ]]; then
	          mv -f "VST UAD Precisio"		"UAD Precision"
	          cd "UAD Precision"
	          mv -f "Precision Buss Comp"		"UAD P BusComp"
	          mv -f "Precision DeEsser"		"UAD P De-Esser"
	          mv -f "Precision Enhancer kHz"	"UAD P Enh kHz"
	          mv -f "Precision EQ"			"UAD P Equalizer"
	          mv -f "Precision Limiter"		"UAD P Limiter"
	          mv -f "Precision Maximizer"		"UAD P Maximizer"
	          mv -f "Precision Multiband"		"UAD P Multiband"
	          cd ..
	          if [[ ! -d "UAD P BusComp" ]]; then
	              mv -f "UAD Precision/UAD P BusComp"		"UAD P BusComp"
            fi
	          if [[ ! -d "UAD P De-Esser" ]]; then
	              mv -f "UAD Precision/UAD P De-Esser"		"UAD P De-Esser"
            fi
	          if [[ ! -d "UAD P Enh kHz" ]]; then
	              mv -f "UAD Precision/UAD P Enh kHz"		"UAD P Enh kHz"
            fi
	          if [[ ! -d "UAD P Equalizer" ]]; then
	              mv -f "UAD Precision/UAD P Equalizer"		"UAD P Equalizer"
            fi
	          if [[ ! -d "UAD P Limiter" ]]; then
	              mv -f "UAD Precision/UAD P Limiter"		"UAD P Limiter"
            fi
	          if [[ ! -d "UAD P Maximizer" ]]; then
	              mv -f "UAD Precision/UAD P Maximizer"		"UAD P Maximizer"
            fi
	          if [[ ! -d "UAD P Multiband" ]]; then
	              mv -f "UAD Precision/UAD P Multiband"		"UAD P Multiband"
            fi
        fi
    fi
    if [[ -d "VST UAD Preflex" ]]; then
        if [[ ! -d "UAD Preflex" ]]; then
	          mv -f "VST UAD Preflex"			"UAD Preflex"
        fi
    fi
    if [[ -d "VST UAD Pultec" ]]; then
        if [[ ! -d "UAD Pultec" ]]; then
	          mv -f "VST UAD Pultec"			"UAD Pultec"
        fi
    fi
    if [[ -d "VST UAD Pultec-P" ]]; then
        if [[ ! -d "UAD Pultec-Pro" ]]; then
	          mv -f "VST UAD Pultec-P"	    "UAD Pultec-Pro"
        fi
    fi
    if [[ -d "VST UAD RealVerb" ]]; then
        if [[ ! -d "UAD RealVerb-Pro" ]]; then
	          mv -f "VST UAD RealVerb"	    "UAD RealVerb-Pro"
        fi
    fi
    if [[ -d "VST UAD Roland C" ]]; then
        if [[ ! -d "UAD Roland CE-1" ]]; then
	          mv -f "VST UAD Roland C"		"UAD Roland CE-1"
        fi
    fi
    if [[ -d "VST UAD Roland D" ]]; then
        if [[ ! -d "UAD Roland Dim D" ]]; then
	          mv -f "VST UAD Roland D"		"UAD Roland Dim D"
        fi
    fi
    if [[ -d "VST UAD Roland R" ]]; then
        if [[ ! -d "UAD Roland RE201" ]]; then
	          mv -f "VST UAD Roland R"	    "UAD Roland RE201"
        fi
    fi
    if [[ -d "VST UAD RS-1" ]]; then
        if [[ ! -d "UAD RS-1" ]]; then
	          mv -f "VST UAD RS-1"			"UAD RS-1"
        fi
    fi
    if [[ -d "VST UAD SPL Tran" ]]; then
        if [[ ! -d "UAD SPL Trans D" ]]; then
	          mv -f "VST UAD SPL Tran"		"UAD SPL Trans D"
        fi
    fi
    if [[ -d "VST UAD SSL E Ch" ]]; then
        if [[ ! -d "UAD SSL E ChnStp" ]]; then
	          mv -f "VST UAD SSL E Ch"		"UAD SSL E ChnStp"
        fi
    fi
    if [[ -d "VST UAD SSL G Bu" ]]; then
        if [[ ! -d "UAD SSL G BusCmp" ]]; then
	          mv -f "VST UAD SSL G Bu"		"UAD SSL G BusCmp"
        fi
    fi
    if [[ -d "VST UAD Studer A" ]]; then
        if [[ ! -d "UAD Studer A800" ]]; then
	          mv -f "VST UAD Studer A"		"UAD Studer A800"
        fi
    fi
    if [[ -d "VST UAD TrackAdv" ]]; then
        if [[ ! -d "UAD TrackAdv" ]]; then
	          mv -f "VST UAD TrackAdv"		"UAD TrackAdv"
        fi
    fi
    if [[ -d "VST UAD TremModE" ]]; then
        if [[ ! -d "UAD TremModEcho" ]]; then
	          mv -f "VST UAD TremModE"		"UAD TremModEcho"
        fi
    fi
    if [[ -d "VST UAD Tremolo" ]]; then
        if [[ ! -d "UAD Tremolo" ]]; then
	          mv -f "VST UAD Tremolo"			"UAD Tremelo"
        fi
    fi
    if [[ -d "VST UAD Trident " ]]; then
        if [[ ! -d "UAD Trident" ]]; then
	          mv -f "VST UAD Trident " 		"UAD Trident"
        fi
    fi
fi

# rtas OWS preset rename
# change for OCNSTU-400
# rename old placeholder OWS preset folder named "UAD OWS" to "UAD Ocean Way"

RTASPRESET_DIR="/Library/Application Support/Digidesign/Plug-In Settings"
SRCOWS_DIR="UAD OWS"
DESTOWS_DIR="UAD Ocean Way"


if [[ -d "$RTASPRESET_DIR" ]]; then
    cd "$RTASPRESET_DIR"
    if [[ -d "$SRCOWS_DIR" ]]; then
        if [[ ! -d "$DESTOWS_DIR" ]]; then
            mv -f "$SRCOWS_DIR" "$DESTOWS_DIR"
        else
            cd "$SRCOWS_DIR"
            find . | cpio -pmdv "$RTASPRESET_DIR/$DESTOWS_DIR"
            cd "$RTASPRESET_DIR"
            rm -rf "$RTASPRESET_DIR/$SRCOWS_DIR"
        fi
    fi
fi

exit 0