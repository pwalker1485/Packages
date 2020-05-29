#!/bin/bash

########################################################################
#     Pro Tools Bundle - Effects and Virtual Instruments Preinstall    #
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

function jamfHelperDownloadInProgress ()
{
# Download in progress helper window
"$jamfHelper" -windowType utility -icon "$helperIcon" -title "$helperTitle" \
-heading "$helperHeading" -alignHeading natural -description "Downloading Effects and Virtual Instruments bundle..." -alignDescription natural &
}

########################################################################
#                         Script starts here                           #
########################################################################

# Show a message via Jamf Helper that the package is being downloaded
jamfHelperDownloadInProgress

exit 0
