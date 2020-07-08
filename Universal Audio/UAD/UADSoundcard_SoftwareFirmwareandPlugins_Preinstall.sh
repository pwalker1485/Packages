#!/bin/bash

########################################################################
#    UAD Audio Interface Software, Firmware and Plugins Preinstall     #
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
helperHeading="UAD Software, Firmware and Plugins"

########################################################################
#                            Functions                                 #
########################################################################

function jamfHelperDownloadInProgress ()
{
#Download in progress
"$jamfHelper" -windowType utility -icon "$helperIcon" -title "$helperTitle" \
-heading "$helperHeading" -alignHeading natural -description "All software, firmware and plugins required \
for a Universal Audio Apollo Twin Solo or Duo Audio Interface is currently being installed

This may take up to 20 minutes to complete" -alignDescription natural &
}

########################################################################
#                         Script starts here                           #
########################################################################

#Show a message via Jamf Helper that the package is being downloaded
jamfHelperDownloadInProgress

exit 0
