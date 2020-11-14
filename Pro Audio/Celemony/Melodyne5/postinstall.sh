#!/bin/zsh

########################################################################
#              Install Celemony Melodyne - postinstall                 #
################## Written by Phil Walker Nov 2020 #####################
########################################################################

# below content all from vendors package

########################################################################
#                         Script starts here                           #
########################################################################

# some hosts depend on the timestamp of the wrapper directory to be up to date
touch "/Library/Application Support/Avid/Audio/Plug-Ins/Melodyne.aaxplugin"

# S1 depends on the timestamp of the wrapper directory to be up to date
touch "/Library/Audio/Plug-Ins/Components/Melodyne.component"

# S1 depends on the timestamp of the wrapper directory to be up to date
touch "/Library/Audio/Plug-Ins/VST3/Melodyne.vst3"

exit 0