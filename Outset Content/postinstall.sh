#!/bin/zsh

########################################################################
#                 Run All Outset login-privileged scripts              #
#################### Written by Phil Walker Nov 2020 ###################
########################################################################
# To avoid using the User Template use outset to copy content for new users

# Requirements
# Outset (https://github.com/chilcote/outset)
# macOS 10.15+
# python 3.7+ (https://github.com/macadmins/python)

########################################################################
#                            Variables                                 #
########################################################################

# Outset binary
outsetBinary="/usr/local/outset/outset"

########################################################################
#                         Script starts here                           #
########################################################################

# Make sure Outset is installed
if [[ -e "$outsetBinary" ]]; then
    echo "Outset binary found"
    # Run all login-privileged scripts to copy user content
    echo "Running all login-privileged scripts..."
    "$outsetBinary" --login-privileged
    echo "All login-privileged scripts completed"
    echo "Check the logs in /Library/Logs/Bauer/Outset for more detail"
else
    echo "Outset binary not found!"
    echo "Unable to copy any Pro Audio user settings"
    exit 1
fi
exit 0