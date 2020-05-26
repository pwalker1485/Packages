#!/bin/bash

########################################################################
#          Pro Tools Bundle - iLok License Manager postinstall         #
#################### Written by Phil Walker Jan 2020 ###################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Package receipt
pkgReceipt=$(pkgutil --pkgs | grep "com.paceap.pkg.eden.iLokLicenseManager")
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
# jamf Helper to advise that iLok License Manager failed to install
"$jamfHelper" -windowType utility -icon "$helperIcon" -title "$helperTitle" \
-heading "$helperHeading" -description "iLok License Manager failed to install successfully❗️

No further software included in the Pro Tools bundle will be installed

Please contact the IT Service Desk on 0345 058 4444 for assistance" -timeout 60 -button1 "Ok" -defaultButton "1"
}

########################################################################
#                         Script starts here                           #
########################################################################

if [[ "$pkgReceipt" != "" ]]; then
    # Install was successful, call the next policy
    /usr/local/bin/jamf policy -event pt_bundle_eLicenserManager
else
    echo "iLok License Manager package failed to install successfully"
    echo "Pro Tools bundle installation stopped!"
    # Advise user that the install has failed
    jamfHelperFailed
    exit 1
fi

exit 0
