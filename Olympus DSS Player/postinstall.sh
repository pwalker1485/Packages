#!/bin/zsh

########################################################################
#              Install Olympus DSS Player - postinstall                #
################### Written by Phil Walker Nov 2020 ####################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Current kext
dssPlayerKext="/Library/Extensions/OlympusDSSDriver.kext"

########################################################################
#                         Script starts here                           #
########################################################################

# load the DSS Player kernel extension
if [[ -d "$dssPlayerKext" ]]; then
    # Kext status
    kextCheck=$(kextstat -l | grep "com.olympus.DSSBlockCommandsDevice" | awk '{print $6}')
    if [[ "$kextCheck" != "" ]]; then
        echo "Loading the Olympus DSS Player kext..."
        /sbin/kextload -b "com.olympus.DSSBlockCommandsDevice" 2>/dev/null
        echo "Olympus DSS Player kext successfully loaded"
    else
        echo "Olympus DSS Player kext successfully loaded"
    fi
else
    echo "Olympus DSS Player kext not found, reinstall required!"
    exit 1
fi
exit 0