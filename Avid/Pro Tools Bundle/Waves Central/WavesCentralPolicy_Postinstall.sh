#!/bin/bash

########################################################################
#             Pro Tools Bundle - Waves Central Postinstall             #
#################### Written by Phil Walker Jan 2020 ###################
########################################################################

# Edit May 2020

########################################################################
#                            Variables                                 #
########################################################################

# Package receipt
pkgReceipt=$(pkgutil --pkgs | grep "ukwaveswavescentral11.0.60")
# Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# Helper problem icon 
helperProblemIcon="/System/Library/CoreServices/Problem Reporter.app/Contents/Resources/ProblemReporter.icns"
# Helper SS icon
helperSelfServiceIcon="/Library/Application Support/JAMF/bin/Management Action.app/Contents/Resources/Self Service.icns"
# Helper title
helperTitle="Message from Bauer IT"
# Helper heading
helperHeading="Pro Tools Bundle"

########################################################################
#                            Functions                                 #
########################################################################

function jamfHelperFailed ()
{
# # jamf Helper to advise that Waves Central failed to install
"$jamfHelper" -windowType utility -icon "$helperProblemIcon" -title "$helperTitle" \
-heading "$helperHeading" -description "Waves Central failed to install successfully❗️

No further software included in the Pro Tools bundle will be installed

Please contact the IT Service Desk on 0345 058 4444 for assistance" -timeout 60 -button1 "Ok" -defaultButton "1"
}

function jamfHelperUpdateComplete ()
{
# Show a message via Jamf Helper that the install has completed
"$jamfHelper" -windowType utility -icon "$helperSelfServiceIcon" -title "$helperTitle" \
-heading "$helperHeading" -description "Installation complete ✅

Your Mac will now be rebooted" -alignDescription natural -timeout 15 -button1 "Ok" -defaultButton "1"
}

########################################################################
#                         Script starts here                           #
########################################################################

# Kill the install in progess jamf Helper window
killall jamfHelper 2>/dev/null

if [[ "$pkgReceipt" != "" ]]; then
    # Install was successful, Mac will now be rebooted
    jamfHelperUpdateComplete
else
    echo "Waves Central package failed to install successfully"
    echo "Pro Tools bundle installation did not complete successfully"
    echo "Waves Central can be deployed via Jamf Remote, if required"
    # Advise user that the install has failed
    jamfHelperFailed
    exit 1
fi

exit 0
