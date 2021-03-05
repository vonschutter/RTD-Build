#!/bin/bash
#
#::                                        A D M I N   C O M M A N D
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::// Simple bootable CD/DVD creation Tool //:::::::::::::::::::::// Linux //::::::::
#::
#:: Author:   	SLS
#:: Version 	1.00
#::
#::
#::	Purpose: The purpose of the script is to make a bootable ISO file from a directory "folder" on your computer.
#::
#::
#::     Usage:	Simply execute this commandlet to accomplish this task. No parameters required.
#:: 		Then, if prompted; enter the information requested.
#::
#::
#::
#::
#::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
# Additional information:
#
# An ISO image is a disk image of an optical disc. In other words, it is an archive file that contains everything that would
# be written to an optical disc, sector by sector, including the optical disc file system.[1] ISO image files bear the .iso
# filename extension. The name ISO is taken from the ISO 9660 file system used with CD-ROM media, but what is known as an
# ISO image might also contain a UDF (ISO/IEC 13346) file system (commonly used by DVDs and Blu-ray Discs).
#
# ISO images can be created from optical discs by disk imaging software, or from a collection of files by optical disc authoring
# software, or from a different disk image file by means of conversion. Software distributed on bootable discs is often available
# for download in ISO image format. And like any other ISO image, it may be written to an optical disc such as CD or DVD.
#
# This  script was originally developed for RuntimeData, a small OEM in Buffalo Center, IA.
# This OEM and store nolonger exists as its owner has passed away.
# This script is shared in the hopes that someone will find it useful.
#
# This script is intended to live in the ~/bin/ or /bin/ folder, alternatively in the $PATH.
#

###########################################################################
##                                                                       ##
##                       Commandlet settings                             ##
##                                                                       ##
###########################################################################

# Set library path if not defined:
rtd_library=${rtd_library:-"/opt/rtd/scripts/_rtd_library"}

if [[ -f ${rtd_library} ]]; then
        source ${rtd_library}
elif [[ ! -f ${rtd_library} ]]; then
        echo "RTD Functions not found... "
        echo "Trying to retrieve them..."
        wget https://github.com/vonschutter/RTD-Build/raw/master/System_Setup/_rtd_library
        source ./_rtd_library
else
        exit 1
fi

ensure_admin

# the name of and where to put th ISO file:
ISO_IMAGE=$(dialog --title "${Title:="$( basename $0 )"}" --backtitle "${BRANDING:-"$( basename $0 )"}" --stdout --inputbox "\n Please enter the path/name of the ISO file to be created. \n For example: ~/MY-BOOT-CD.iso" 10 90 ) ; clear

# The label of the CD/DVD/BueRay
CD_LABEL=$(dialog --title "${Title:="$( basename $0 )"}" --backtitle "${BRANDING:-"$( basename $0 )"}" --stdout --inputbox "\n Please enter the CD label for the new CD. \n For example: BOOT_MEDIA" 10 90 ); clear

# The folder where the files are:
RH_BUILD_DIR=$(dialog --title "${Title:="$( basename $0 )"}" --backtitle "${BRANDING:-"$( basename $0 )"}" --stdout --inputbox "\n Please enter the fileder containging the files to be contained in the CD \n For example: ~/SLSBOOTCD" 10 90 ); clear



###########################################################################
##                                                                       ##
##                       Script Executive                                ##
##                                                                       ##
###########################################################################
check_dependencies mkisofs

if ! -f  "${RH_BUILD_DIR}"; then
        echo  "${RH_BUILD_DIR} does not exist! Please try again." ; exit 1
fi

mkisofs -r -J -T \
        -b isolinux/isolinux.bin \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -o "${ISO_IMAGE}" \
        -V "${CD_LABEL}" \
        "${RH_BUILD_DIR}"


