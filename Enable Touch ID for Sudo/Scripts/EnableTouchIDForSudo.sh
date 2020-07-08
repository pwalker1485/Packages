#!/bin/zsh

########################################################################
#       Add Touch ID to PAM (Pluggable Authentication Module)          #
################## Written by Phil Walker Apr 2020 #####################
########################################################################

# Enable Touch ID for sudo auth requests
# Used with a Launch Daemon to apply the change post update install

########################################################################
#                            Variables                                 #
########################################################################

# PAM module sudo file
sudoFile="/etc/pam.d/sudo"
# Enable TouchID
enableTouchID="auth       sufficient     pam_tid.so"
# Check for Touch ID
touchIDCheck=$(/usr/bin/grep "$enableTouchID" "$sudoFile")
# Log file
logFile="/var/tmp/EnableTouchIDForSudo.log"
# Date and time
datetime=$(date +%d-%m-%Y\ %T)

########################################################################
#                            Functions                                 #
########################################################################

function addTouchID ()
{
local preCheck=$(ls /etc/pam.d/.sudo* 2>/dev/null | wc -l)
# Create a backup before making changes
backupFile=$(dirname $sudoFile)/.$(basename $sudoFile).$(echo $(ls $(dirname $sudoFile)/{,.}$(basename $sudoFile)* 2>/dev/null | wc -l))
cp "$sudoFile" "$backupFile"
local postCheck=$(ls /etc/pam.d/.sudo* 2>/dev/null | wc -l)
if [[ "$postCheck" -gt "$preCheck" ]]; then
    echo "${datetime}: Backup file created successfully"  >> "$logFile"
else
    echo "${datetime}: Failed to create a backup file, exiting..."  >> "$logFile"
    exit 0
fi
# Add Touch ID to PAM for sudo requests
/usr/bin/sed -i '' -e "1s/^//p; 1s/^.*/${enableTouchID}/" "$sudoFile"
}

########################################################################
#                         Script starts here                           #
########################################################################

if [[ "$touchIDCheck" != "" ]]; then
    echo "Touch ID aleady enabled for sudo requests"
    exit 0
else
    echo "${datetime}: Enabling Touch ID for sudo requests"  >> "$logFile"
    addTouchID
    # re-populate variable
    touchIDCheck=$(/usr/bin/grep "$enableTouchID" "$sudoFile")
    if [[ "$touchIDCheck" != "" ]]; then
        echo "${datetime}: Touch ID enabled for sudo requests"  >> "$logFile"
        exit 0
    else
        echo "${datetime}: Failed to enable TouchID for sudo requests"  >> "$logFile"
        exit 1
    fi
fi