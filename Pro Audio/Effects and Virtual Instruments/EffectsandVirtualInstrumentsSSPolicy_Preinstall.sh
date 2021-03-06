#!/bin/bash

########################################################################
#         Effects and Virtual Instruments Preinstall Jamf Helper       #
#################### Written by Phil Walker Jan 2020 ###################
########################################################################

# Edit May 2020

########################################################################
#                            Variables                                 #
########################################################################

# Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# Helper icon
helperIcon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Sync.icns"
# Helper title
helperTitle="Message from Bauer IT"
# Helper heading
helperHeading="Effects and Virtual Instruments Bundle"

########################################################################
#                            Functions                                 #
########################################################################

function jamfHelperDownloadInProgress ()
{
# Download in progress helper window
"$jamfHelper" -windowType utility -icon "$helperIcon" -title "$helperTitle" \
-heading "$helperHeading" -alignHeading natural -description "Downloading Effects and Virtual Instruments Bundle..." -alignDescription natural &
}

########################################################################
#                         Script starts here                           #
########################################################################

# Show a message via Jamf Helper that the package is being downloaded
jamfHelperDownloadInProgress

exit 0
