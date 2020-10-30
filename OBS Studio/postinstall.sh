#!/bin/zsh

########################################################################
#                      OBS Studio - postinstall                        #
################## Written by Phil Walker Oct 2020 #####################
########################################################################
# Install relevant Non Flat package including user template content
# dependent on OS version

########################################################################
#                            Variables                                 #
########################################################################

# Mac model
macModelFull=$(system_profiler SPHardwareDataType | grep "Model Name" | sed 's/Model Name: //' | xargs)
# OS Version
osVersion=$(sw_vers -productVersion)
# macOS Catalina version number
catalinaOS="10.15"
# Temp directory non-flat package will be installed to
installDir="/usr/local/NonFlatPackages"
# Package zip pre Catalina
pkgZipPre="UK_OBS_Project_OBS_Studio_26.0.2_Pre_Catalina_Only.pkg.zip"
# Package name pre Catalina
pkgNamePre="UK_OBS_Project_OBS_Studio_26.0.2_Pre_Catalina_Only.pkg"
# Package zip post Catalina
pkgZipPost="UK_OBS_Project_OBS_Studio_26.0.2_Catalina_or_Later.pkg.zip"
# Package name post Catalina
pkgNamePost="UK_OBS_Project_OBS_Studio_26.0.2_Catalina_or_Later.pkg"
# Package friendly name
friendlyName="OBS Studio 26.0.2"

########################################################################
#                         Script starts here                           #
########################################################################

autoload is-at-least
if ! is-at-least "$catalinaOS" "$osVersion"; then
    echo "$macModelFull running ${osVersion}, installing ${pkgNamePre}"
    # If found, install the package
    if [[ -e "${installDir}/${pkgZipPre}" ]]; then
        echo "Package zip found, unzipping..."
        unzip -q "${installDir}/${pkgZipPre}" -d "$installDir"
        echo "Installing ${friendlyName}..."
        /usr/sbin/installer -pkg "${installDir}/${pkgNamePre}" -target /
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
else
    echo "$macModelFull running ${osVersion}, installing ${pkgNamePost}"
    # If found, install the package
    if [[ -e "${installDir}/${pkgZipPost}" ]]; then
        echo "Package zip found, unzipping..."
        unzip -q "${installDir}/${pkgZipPost}" -d "$installDir"
        echo "Installing ${friendlyName}..."
        /usr/sbin/installer -pkg "${installDir}/${pkgNamePost}" -target /
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