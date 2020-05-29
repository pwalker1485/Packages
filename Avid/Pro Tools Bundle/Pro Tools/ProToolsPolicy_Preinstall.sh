#!/bin/bash

########################################################################
#                Pro Tools Bundle - Pro Tools Preinstall               #
#################### Written by Phil Walker Jan 2020 ###################
########################################################################

# Edit May 2020

########################################################################
#                            Variables                                 #
########################################################################

# Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# Helper icon
helperIcon="/Library/Application Support/JAMF/bin/Management Action.app/Contents/Resources/Self Service.icns"
# Helper title
helperTitle="Message from Bauer IT"
# Helper heading
helperHeading="Pro Tools Bundle"

########################################################################
#                            Functions                                 #
########################################################################

function jamfHelperInstallInProgress ()
{
# Install is in progress
"$jamfHelper" -windowType utility -icon "$helperIcon" -windowPosition ur -title "$helperTitle" \
-heading "$helperHeading" -alignHeading natural -description "Pro Tools installation in progress...

This may take up to 15 minutes to complete

When prompted to send anonymous usage data to Avid, please select either Yes or No to allow the installation to continue" -alignDescription natural &
}

########################################################################
#                         Script starts here                           #
########################################################################

# Show a message via jamf Helper that the install is in progress
jamfHelperInstallInProgress

exit 0