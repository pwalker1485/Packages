#!/bin/bash

########################################################################
#    UAD Audio Interface Software, Firmware and Plugins Postinstall    #
#################### Written by Phil Walker Jan 2020 ###################
########################################################################

# Edit May 2020

########################################################################
#                            Variables                                 #
########################################################################

# Package receipt
pkgReceipt=$(pkgutil --pkgs | grep "ukuadsoftwarefirmwareplugins9.12.1")
# OS Version Full and Short
osFull=$(sw_vers -productVersion)
osShort=$(sw_vers -productVersion | awk -F. '{print $2}')
# Mac model full name
macModelFull=$(system_profiler SPHardwareDataType | grep "Model Name" | sed 's/Model Name: //' | xargs)
# Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# Helper problem icon 
helperProblemIcon="/System/Library/CoreServices/Problem Reporter.app/Contents/Resources/ProblemReporter.icns"
# Helper SS icon
helperSelfServiceIcon="/Library/Application Support/JAMF/bin/Management Action.app/Contents/Resources/Self Service.icns"
# Helper title
helperTitle="Message from Bauer IT"
# Helper heading
helperHeading="UAD Software, Firmware and Plugins"

########################################################################
#                            Functions                                 #
########################################################################

function jamfHelperFailed ()
{
#jamf Helper to advise that the install has failed
"$jamfHelper" -windowType utility -icon "$helperProblemIcon" -title "$helperTitle" \
-heading "$helperHeading" -description "Installation failed❗️

Please contact the IT Service Desk on 0345 058 4444 for assistance" -timeout 60 -button1 "Ok" -defaultButton "1"
}

function jamfHelperUpdateComplete ()
{
#Show a message via Jamf Helper that the install has completed
"$jamfHelper" -windowType utility -icon "$helperSelfServiceIcon" -title "$helperTitle" \
-heading "$helperHeading" -description "Installation complete ✅

Your Mac will now be rebooted" -alignDescription natural -timeout 15 -button1 "Ok" -defaultButton "1"
}

########################################################################
#                         Script starts here                           #
########################################################################

# Check OS version and install relevant user preference package (User Template)
# Different packages due to the directory moving to /Library/User Template/ in Catalina
echo "Checking User Template package requirements..."
if [[ "$osShort" -le "14" ]]; then
    echo "${macModelFull} running macOS ${osFull}"
    /usr/local/jamf/bin/jamf policy -event uad_preferences_pre_catalina
elif [[ "$osShort" -ge "15" ]]; then
    echo "${macModelFull} running macOS ${osFull}"
    /usr/local/jamf/bin/jamf policy -event uad_preferences
else
    echo "${macModelFull} running macOS ${osFull}, no User Template package requirement"
fi

#Kill the install in progess jamf Helper window
killall jamfHelper

if [[ "$pkgReceipt" != "" ]]; then
    # Install was successful, the Mac will now be rebooted
    jamfHelperUpdateComplete
else
    echo "UAD Soundcard Software, Firmware and Plugins package failed to install successfully"
    # Advise user that the install has failed
    jamfHelperFailed
    exit 1
fi

exit 0
