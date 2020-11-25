#!/bin/bash

########################################################################
#        Pro Tools Bundle - eLicenser Control Center Preinstall        #
#################### Written by Phil Walker May 2020 ###################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# Helper icon
if [[ -d "/tmp/ProAudioAppIcons" ]]; then
    helperIcon="/tmp/ProAudioAppIcons/eLicenser.icns"
else
    helperIcon="/Library/Application Support/JAMF/bin/Management Action.app/Contents/Resources/Self Service.icns"
fi
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
"$jamfHelper" -windowType utility -icon "$helperIcon" -title "$helperTitle" \
-heading "$helperHeading" -alignHeading natural -description \
"eLicenser Control Center installation in progress..." -alignDescription natural &
}

########################################################################
#                         Script starts here                           #
########################################################################

# Show a message via jamf Helper that the install is in progress
jamfHelperInstallInProgress

exit 0