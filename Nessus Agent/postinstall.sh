#!/bin/sh

########################################################################
#                   Install and Link Nessus Agent                      #
################## Written by Phil Walker June 2020 ####################
########################################################################

# postinstall

########################################################################
#                            Variables                                 #
########################################################################

nessusCLI="/Library/NessusAgent/run/sbin/nessuscli"
computerName=$(scutil --get HostName)
domain="Your Domain"
group="Device Group"
key="The Key"
host="The Host"
port="The Port"

########################################################################
#                         Script starts here                           #
########################################################################

# First check for the nessus agent. If found, unlink it
if [[ -e "$nessusCLI" ]]; then
    "$nessusCLI" agent unlink >/dev/null 2>&1
    # Check if the unlink command was successful
    commandResult=$(echo "$?")
    if [[ "$commandResult" -eq "0" ]]; then
        echo "$computerName has been successfully unlinked"
    elif [[ "$commandResult" -eq "2" ]]; then
        echo "No host information found, unlink not required"
    else
        echo "Failed to unlink $computerName"
        exit 1
    fi
fi

# Mount the disk image
/usr/bin/hdiutil mount -noverify -nobrowse /usr/local/Nessus/NessusAgent-7.6.3.dmg

# Install the package
/usr/sbin/installer -pkg "/Volumes/Nessus Agent Install/Install Nessus Agent.pkg" -target /

# Unmount the disk image
/usr/bin/hdiutil unmount -force "/Volumes/Nessus Agent Install"

# Allow time for the agent to start
sleep 3

# Delete the disk image
rm -rf "/usr/local/Nessus/"

# Link the agent to the server
"$nessusCLI" agent link --key="$key" --name="$computerName"."$domain" --groups="$group" --host="$host"."$domain" --port="$port" >/dev/null 2>&1

# Check if the computer is now successfully linked
if [[ "$?" -eq "0" ]]; then
    echo "$computerName has been successfully linked to $host.$domain"
    echo "Device Group: $group"
else
    echo "Failed to link $computerName to $host.$domain"
    exit 1
fi

exit 0