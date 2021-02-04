#!/bin/zsh

########################################################################
#     Install Cisco AnyConnect Secure Mobility Client - preinstall     #
################### Written by Phil Walker Dec 2020 ####################
########################################################################

########################################################################
#                            Variables                                 #
########################################################################

# Cisco AnyConnect VPN binary
vpnBinary="/opt/cisco/anyconnect/bin/vpn"

########################################################################
#                         Script starts here                           #
########################################################################

if [[ -e "$vpnBinary" ]]; then
    echo "Disconnecting all VPN connections..."
    "$vpnBinary" disconnect
    echo "Closing the Cisco AnyConnect client..."
    pkill -9 "Cisco AnyConnect Secure Mobility Client" >/dev/null 2>&1
else
    echo "Cisco AnyConnect VPN binary not found, nothing to do"
fi
exit 0