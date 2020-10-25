#!/bin/zsh

########################################################################
#           Install a Zipped Non-Flat Package - postinstall            #
################### Written by Phil Walker Oct 2020 ####################
########################################################################
# Amend pkgZip/pkgName and friendlyName variables per package

########################################################################
#                            Variables                                 #
########################################################################

# Temp directory non-flat package will be installed to
installDir="/usr/local/NonFlatPackages"
# Package zip
pkgZip="UK_Vendor_App_Version.pkg.zip"
# Package name
pkgName="UK_Vendor_App_Version.pkg"
# Package friendly name
friendlyName="Vendor App Version"

########################################################################
#                         Script starts here                           #
########################################################################

# If found, install the package
if [[ -e "${installDir}/${pkgZip}" ]]; then
    echo "Package zip found, unzipping..."
    unzip -q "${installDir}/${pkgZip}" -d "$installDir"
    echo "Installing ${friendlyName}..."
    /usr/sbin/installer -pkg "${installDir}/${pkgName}" -target /
    installResult="$?"
    if [[ "$installResult" -eq "0" ]]; then
        echo "Successfully installed ${friendlyName}"
    else
        echo "Failed to install ${friendlyName}, please check the logs for further details"
        exit 1
    fi
else
    echo "Package not found!, exiting..."
    exit 1
fi

# Cleanup the temp directory
if [[ -d "$installDir" ]]; then
    rm -rf "$installDir"
    if [[ ! -d "$installDir" ]]; then
        echo "Removed temp directory"
    else
        echo "Failed to remove temp directory"
        echo "Manual clean up required"
    fi
else
    echo "Temp directory not found, nothing to do"
fi
exit 0