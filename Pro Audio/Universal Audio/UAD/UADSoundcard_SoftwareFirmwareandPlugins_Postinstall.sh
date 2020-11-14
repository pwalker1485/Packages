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
# Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# Helper problem icon 
helperProblemIcon="/System/Library/CoreServices/Problem Reporter.app/Contents/Resources/ProblemReporter.icns"
# Helper success icon
if [[ -d "/tmp/ProAudioAppIcons" ]]; then
    helperSuccessIcon="/tmp/ProAudioAppIcons/UAD.icns"
else
    helperSuccessIcon="/Library/Application Support/JAMF/bin/Management Action.app/Contents/Resources/Self Service.icns"
fi
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
"$jamfHelper" -windowType utility -icon "$helperSuccessIcon" -title "$helperTitle" \
-heading "$helperHeading" -description "Installation complete ✅

Your Mac will now be rebooted" -alignDescription natural -timeout 15 -button1 "Ok" -defaultButton "1"
}

########################################################################
#                         Script starts here                           #
########################################################################

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
