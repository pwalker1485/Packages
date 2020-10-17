#!/bin/bash

########################################################################
#               Pro Tools Bundle - Pro Tools Postinstall               #
#################### Written by Phil Walker Jan 2020 ###################
########################################################################

# Edit May 2020

########################################################################
#                            Variables                                 #
########################################################################

# OS Version Full and Short
osFull=$(sw_vers -productVersion)
osShort=$(sw_vers -productVersion | awk -F. '{print $2}')
# Mac model full name
macModelFull=$(system_profiler SPHardwareDataType | grep "Model Name" | sed 's/Model Name: //' | xargs)
# Package receipt
pkgReceipt=$(pkgutil --pkgs | grep "ukavidprotools2020.9.1")
# Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# Helper icon
helperIcon="/System/Library/CoreServices/Problem Reporter.app/Contents/Resources/ProblemReporter.icns"
# Helper title
helperTitle="Message from Bauer IT"
# Helper heading
helperHeading="Pro Tools Bundle"

########################################################################
#                            Functions                                 #
########################################################################

function jamfHelperFailed ()
{
# jamf Helper to advise that Pro Tools failed to install
"$jamfHelper" -windowType utility -icon "$helperIcon" -title "$helperTitle" \
-heading "$helperHeading" -description "Pro Tools failed to install successfully❗️

No further software included in the Pro Tools bundle will be installed

Please contact the IT Service Desk on 0345 058 4444 for assistance" -timeout 60 -button1 "Ok" -defaultButton "1"
}

########################################################################
#                         Script starts here                           #
########################################################################

# Check OS version and install relevant user preference package (User Template)
# Different packages due to the directory moving to /Library/User Template/ in Catalina
echo "Checking User Template package requirements..."
if [[ "$osShort" -le "14" ]]; then
    echo "${macModelFull} running macOS ${osFull}"
    /usr/local/jamf/bin/jamf policy -event pt_bundle_preferences_mojave
elif [[ "$osShort" -ge "15" ]]; then
    echo "${macModelFull} running macOS ${osFull}"
    /usr/local/jamf/bin/jamf policy -event pt_bundle_preferences
else
    echo "${macModelFull} running macOS ${osFull}, no User Template package requirement"
fi

# Kill the install in progess jamf Helper window
killall jamfHelper 2>/dev/null

if [[ "$pkgReceipt" != "" ]]; then
    # Install was successful, call the next policy
    /usr/local/bin/jamf policy -event pt_bundle_iLokManager
else
    echo "Pro Tools package failed to install successfully"
    echo "Pro Tools bundle installation stopped!"
    # Advise user that the install has failed
    jamfHelperFailed
    exit 1
fi

exit 0