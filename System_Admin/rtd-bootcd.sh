#!/bin/bash
#
#::             			A D M I N   C O M M A N D L E T   
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
#
# the name of and where to put th ISO file: 
ISO_IMAGE=~/CD.iso

# The label of the CD/DVD/BueRay
CD_LABEL=farorbit.boot

# The folder where the files are: 
RH_BUILD_DIR=~/SLSBOOTCD


###########################################################################
##                                                                       ##
##                       Script Executive                                ##
##                                                                       ##
###########################################################################

        mkisofs -r -J -T \
                -b isolinux/isolinux.bin \
                -no-emul-boot \
                -boot-load-size 4 \
                -boot-info-table \
                -o "${ISO_IMAGE}" \
                -V "${CD_LABEL}" \
                "${RH_BUILD_DIR}"
                
                
