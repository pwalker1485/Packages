#!/bin/bash

########################################################################
#            Install Purple Export Extension for InDesign CS6          #
################## Written by Phil Walker June 2020 ####################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Get the logged in user
loggedInUser=$(stat -f %Su /dev/console)
# Adobe Extension Manager CS6
extensionManager="/Applications/Adobe Extension Manager CS6/Adobe Extension Manager CS6.app/Contents/MacOS/Adobe Extension Manager CS6"
# Temp location of the Purple Export Extension for InDesign CS6 
tempExtensionPath="/private/var/tmp/PurpleExtension/CS6/PurpleExtension-1.4.2-s.zxp"
# Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# Helper icon
helperIcon="/Applications/Adobe Extension Manager CS6/Adobe Extension Manager CS6.app/Contents/Resources/ExtensionManager.icns"
# Helper problem icon 
helperProblemIcon="/System/Library/CoreServices/Problem Reporter.app/Contents/Resources/ProblemReporter.icns"
# Helper title
helperTitle="Message from Bauer IT"
# Helper heading
helperHeading="    Purple Export Extension for InDesign CS6    "

########################################################################
#                            Functions                                 #
########################################################################

function jamfHelperInstallProgress ()
{
#Download in progress
"$jamfHelper" -windowType utility -icon "$helperIcon" -title "$helperTitle" \
-heading "$helperHeading" -alignHeading natural -description "Installing Purple Export Extension for InDesign CS6

This may take up to 20 minutes to complete" -alignDescription natural &
}

function jamfHelperFailed ()
{
#jamf Helper to advise that the install has failed
"$jamfHelper" -windowType utility -icon "$helperProblemIcon" -title "$helperTitle" \
-heading "$helperHeading" -description "Installation failed❗️

Please contact the IT Service Desk on 0345 058 4444 for assistance" -timeout 60 -button1 "Ok" -defaultButton "1"
}

function jamfHelperComplete ()
{
#Show a message via Jamf Helper that the install has completed
"$jamfHelper" -windowType utility -icon "$helperIcon" -title "$helperTitle" \
-heading "$helperHeading" -description "Installation complete ✅" -alignDescription natural -timeout 15 -button1 "Ok" -defaultButton "1"
}

function cleanUp ()
{
# Clean up installation files
if [[ -d "/private/var/tmp/PurpleExtension" ]]; then
    rm -rf "/private/var/tmp/PurpleExtension"
    if [[ ! -d "/private/var/tmp/PurpleExtension" ]]; then
        echo "Temp install files deleted successfully"
    else
        echo "Failed to clean-up temp files, manual clean-up required"
    fi
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

echo "Removing any previously installed Purple Export Extension for InDesign CS6..."
# Remove any existing Purple InDesign CS6 Extension installs
"$extensionManager" -suppress -remove product="InDesign CS6" extension="Purple"

if [[ -e "$tempExtensionPath" ]]; then
    if [[ "$loggedInUser" == "" ]] || [[ "$loggedInUser" == "root" ]]; then
        echo "Installing Purple Export Extension for InDesign CS6 ..."
        # Install Purple InDesign CS6 Extension
        "$extensionManager" -suppress -install zxp="$tempExtensionPath"
        if [[ "$?" == "0" ]]; then
            echo "Purple Export Extension for InDesign CS6 installed successfully"
            cleanUp
        else
            echo "Failed to install Purple Export Extension for InDesign CS6"
            cleanUp
            exit 1
        fi
    else
        jamfHelperInstallProgress
        echo "Installing Purple Export Extension for InDesign CS6..."
        # Install Purple InDesign CS6 Extension
        "$extensionManager" -suppress -install zxp="$tempExtensionPath"
        if [[ "$?" == "0" ]]; then
            # Kill the install in progress helper
            killall jamfHelper
            echo "Purple Export Extension for InDesign CS6 installed successfully"
            jamfHelperComplete
            cleanUp
        else
            # Kill the install in progress helper
            killall jamfHelper
            echo "Failed to install Purple Export Extension for InDesign CS6"
            jamfHelperFailed
            cleanUp
            exit 1
        fi
    fi
else
    echo "Purple Export Extension for InDesign CS6 not found, unable to complete installation"
    cleanUp
    exit 1
fi

exit 0