#!/bin/bash

########################################################################
#                  Censhare Client Package - postinstall               #
#################### Written by Phil Walker Sept 2020 ##################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Get the logged in user
loggedInUser=$(stat -f %Su /dev/console)
# Censhare preferene directory
prefDirectory="/Users/${loggedInUser}/Library/Preferences/censhare"
# InDesign CC 2019
idCC2019="/Applications/Adobe InDesign CC 2019"
# InDesign CC 2019 Plugins directory
pluginDir="/Applications/Adobe InDesign CC 2019/Plug-Ins/Censhare/"
# Kext status
kextCheck=$(kextstat -l | grep "com.censhare.vfs.CenshareFS" | awk '{print $6}')
# Censhare VFS launch daemon
vfsLaunchD="/Library/LaunchDaemons/com.censhare.vfs.launchd.plist"
# Censhare VFS helper launch daemon
vfsHelper="/Library/LaunchDaemons/com.censhare.vfs.Helper.plist"
# Censhare VFS launch daemons status
vfsLaunchDStatus=$(launchctl list | grep -c "com.censhare.vfs")

########################################################################
#                            Functions                                 #
########################################################################

function setServerSettings ()
{
read -r -d '' serverSettings <<"EOF"
<?xml version="1.0" encoding="UTF-8"?>
<root xmlns:corpus="http://www.censhare.com/xml/3.0.0/corpus" xmlns:new-fct="http://www.censhare.com/xml/3.0.0/new-fct" xmlns:new-val="http://www.censhare.com/xml/3.0.0/new-val">
  <hosts>
    <host name="Censhare 1" databasename="bauerdb" authentication-method="" disable-trust-manager="true" compressionlevel="0" url="frmis://lxappcenprod01.bauer-uk.bauermedia.group:30546/corpus.RMIServerSSL">
      <censhare-vfs use="1"/>
      <proxy use="0"/>
    </host>
  </hosts>
</root>
EOF
su -l "$loggedInUser" -c "/bin/cat > ${prefDirectory}/hosts.xml<<<'$serverSettings'"
}

function checkServerSettings ()
{
serverSettings=$(cat < "${prefDirectory}"/hosts.xml | grep "lxappcenprod01")
if [[ "$serverSettings" != "" ]]; then
    echo "Censhare server settings set successfully"
    echo "Censhare 1 will be available in the client"
else
    echo "Failed to set Censhare server settings"
fi
}

########################################################################
#                         Script starts here                           #
########################################################################

if [[ -d "$idCC2019" ]]; then
    echo "InDesign CC 2019 is installed, installing InDesign CC 2019 plugins..."
    # Check if the Censhare folder in plugins has already been created, if not create it, change the permissions and copy the plugin into the folder
    if [[ ! -d "$pluginDir" ]]; then
        mkdir "$pluginDir"
        chmod 775 "$pluginDir"
        if [[ -d "$pluginDir" ]]; then
            echo "Censhare folder for plugins created"
        else
            echo "Censhare folder plugins folder NOT CREATED"
        fi
    fi

    # Copy plugins to the InDesign CC plugins folder from temp location if not already there
    if [[ ! -d "/Applications/Adobe InDesign CC 2019/Plug-Ins/Censhare/censhare-XMLCommand-CC-2019-UI.InDesignPlugin" ]]; then
  	    cp -R -p -f "/usr/local/censhare/censhare-XMLCommand-CC-2019-UI.InDesignPlugin" "$pluginDir"
        if [[ -d "/Applications/Adobe InDesign CC 2019/Plug-Ins/Censhare/censhare-XMLCommand-CC-2019-UI.InDesignPlugin" ]]; then
            echo "Copied Censhare UI InDesign Plugin to InDesign Plugins folder"
        else
            echo "FAILED to copy Censhare UI InDesign Plugin"
            exit 1
        fi
    else
        echo "Censhare UI InDesign Plugin already installed"
    fi

    if [[ ! -d "/Applications/Adobe InDesign CC 2019/Plug-Ins/Censhare/censhare-XMLCommand-CC-2019.InDesignPlugin" ]]; then
        cp -R -p -f "/usr/local/censhare/censhare-XMLCommand-CC-2019.InDesignPlugin" "$pluginDir"
        if [[ -d "/Applications/Adobe InDesign CC 2019/Plug-Ins/Censhare/censhare-XMLCommand-CC-2019.InDesignPlugin" ]]; then
            echo "Copied Censhare InDesign Plugin to InDesign Plugins folder"
        else
            echo "FAILED to copy Censhare InDesign Plugin"
            exit 1
        fi
    else
        echo "Censhare InDesign Plugin already installed"
    fi

else
    echo "InDesign CC 2019 is not installed, plugins will not be installed"
fi

# Set correct permissions for the kext
/usr/sbin/chown -R root:wheel /Library/Extensions/CenshareFS.kext
# Load the kext
if [[ "$kextCheck" == "" ]]; then
    echo "Loading the Censhare kext..."
    /sbin/kextload -b "com.censhare.vfs.CenshareFS" 2>/dev/null
    echo "Censhare kext successfully loaded"
fi

# Load the Censhare Launch Daemons
if [[ "$vfsLaunchDStatus" -lt "2" ]]; then
    /bin/launchctl load -w "$vfsLaunchD" > /dev/null 2>&1
    /bin/launchctl load -w "$vfsHelper" > /dev/null 2>&1
    sleep 2
    # re-populate variable
    vfsLaunchDStatus=$(launchctl list | grep -c "com.censhare.vfs")
    if [[ "$vfsLaunchDStatus" -eq "2" ]]; then
        echo "All Censhare launch daemons successfully loaded"
    else
        echo "Failed to load the Censhare launch daemons!"
    fi
fi
# Set the correct permissions for the helper tool
/bin/chmod +x /Library/PrivilegedHelperTools/com.censhare.vfs.Helper

# Set server settings for logged in user, if required
if [[ "$loggedInUser" == "" ]] || [[ "$loggedInUser" == "root" ]]; then
	echo "No user currently logged in, unable to set or check server settings"
else
    if [[ ! -d "$prefDirectory" ]]; then
        sudo -u "$loggedInUser" mkdir "$prefDirectory"
        if [[ -d "$prefDirectory" ]]; then
            echo "Censhare preference directory created for ${loggedInUser}"
            echo "Settings Censhare server settings..."
            setServerSettings
            checkServerSettings
        fi
    else
        if [[ -f "${prefDirectory}/hosts.xml" ]]; then
            echo "Hosts file found for ${loggedInUser}, server settings will not be changed"
        else
            echo "Hosts file not found for ${loggedInUser}, settings Censhare server settings..."
            setServerSettings
            checkServerSettings
        fi
    fi
fi

# Clean up and remove plugins from temp location
rm -r /usr/local/censhare/

exit 0
