#!/bin/bash
#
#::             RTD Ubuntu + derivatives software addon and configuration script
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#:: Author:   	Stephan S. & Nate B. Buffalo Center, IA
#:: Version 1.00
#::
#::
#::	Purpose: The purpose of the script is to setup extra software that is useful for a
#:: complete and productive comuter environment.
#::
#:: This system configuration and installation script was originally developed
#:: for RuntimeData, a small OEM in Buffalo Center, IA. The purpose of the script
#:: was to install and configure Ubuntu and Zorin OS PC's. This OEM and store nolonger
#:: exists as its owner has passed away. This script is shared in the hopes that
#:: someone will find it usefull.
#::
#:: RTD admin scrips are placed in /opt/rtd/scripts. This configuration script is mainly built to use 
#:: functions in _rtd_functions and _rtd_recipies. 
#::       _rtd_functions -- contain usefull admin functions for scripts, such as "how to install software" on different systems. 
#::       _rtd_recipies  -- contain software installation and configuration "recipies". 
#::
#::
#::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Script Settings                 ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
# You may comment out or edit items as you deem necessary.

# Use the RTD function library. This contains most of the intelligence used to perform this systems
# maintenance. This will allso enable color some easily referenced color prompts:
# $YELLOW, $RED, $ENDCOLOR (reset), $GREEN, $BLUE
source /opt/rtd/scripts/_rtd_functions


# Decide where to put log files.
# Default: log in to "name of this script".log and -error.login the home dir.
if [ -z "$_ERRLOGFILE" ]; then _ERRLOGFILE=$_RTDLOGSD/$0-error.log ; else echo "     Logfile is set to: '$_ERRLOGFILE'"; fi
if [ -z "$_LOGFILE" ]; then _LOGFILE=$_RTDLOGSD/$0.log ; else echo "     Logfile is set to: '$_LOGFILE'"; fi

# Default to value passed by parameter. If none is passed, a default will be used. 
zstatus=$1


# Set the background tilte:
: ${_BACK_TITLE:-"RTD OEM Simple System Setup"}

# Set the options to appear in the menu as choices:
option_1="Base Configuration for Productivity (Theming and UI tweaks)"
option_2="WPS Office (Excellent office suite with a modern look and feel)"
option_3="Software to Write Code and Scripts Bundle" 
option_4="Comression Tools Bundle" 
option_5="Quality OSS Games Bundle" 
option_6="System Administration Tools Bundle" 
option_7="Oracle Java" 
option_8="Bleachbit System Cleaning Tool" 
option_9="Commercially Restricted Extras (prorietary video and audio formats)" 
option_10="VLC Media Player"  
option_11="AnyDesk Remote Desktop Screen Sharing (Proprietary)" 
option_12="Google Chrome" 
option_13="Teamiewer Desktop Screen Sharing (Proprietary)"  
option_14="Skype (Proprietary)" 
option_15="MEGA nz Encrypted Cloud Storage" 
option_16="Dropbox Cloud Storage (Proprietary)"  
option_17="Signal and Telegram apps (Secure Communication)" 
option_18="Video Editing Bundle (Openshot, vidcutter etc.)" 
option_19="Media Streamers Bundle (Spotify and Podcast Apps)"  
option_20="Audio Tools" 
option_21="Oracle VirtualBox" 
option_22="Steam Gaming Platform" 




#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Script Functions                ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#










# Function to display the  otions above. This is all done in a bit of a 
# round about way... but the idea is to prepare this setup to be flexible
# for the future so that you only have one place to list the option while
# more than one gui toolkit (dialog, zenity, whiptail) depending on your environment.
function choices_graphical () {
        cmd=( zenity  --list  --width=800 --height=400 --text "$_BACKTITLE" --checklist  --column "ON/OFF" --column "Configuration Choices:" --separator "," )
        ${zstatus:-TRUE}
        options=(    $zstatus "$option_1"
                     $zstatus "$option_2"
                     $zstatus "$option_3"
                     $zstatus "$option_4"
                     $zstatus "$option_5"
                     $zstatus "$option_6"
                     $zstatus "$option_7"
                     $zstatus "$option_8"
                     $zstatus "$option_9"
                     $zstatus "$option_10"
                     $zstatus "$option_11"
                     $zstatus "$option_12"
                     $zstatus "$option_13"
                     $zstatus "$option_14"
                     $zstatus "$option_15"
                     $zstatus "$option_16"
                     $zstatus "$option_17"
                     $zstatus "$option_18"
                     $zstatus "$option_19"
                     $zstatus "$option_20"
                     $zstatus "$option_21"
                     $zstatus "$option_22"
                   )

       choices=$("${cmd[@]}" "${options[@]}" )
}
		
		
	
		
# Function to do what the choices instruct. We read the output from 
# the choices and execute commands that accomplish the task requested. 
function do_instructions_from_choices (){
        IFS=$','
	for choice in $choices
	do
		IFS=$' '
		case $choice in
		"$option_1")
		recipie_baseapps
		;;
		"$option_2")
		recipie_wps_office
		;;
		"$option_3")	
		recipie_developer_software
		;;
		"$option_4")
		recipie_compression_tools
		;;
		"$option_5")
		recipie_games
		;;
		"$option_6")
		recipie_admin_tools
		;;
		"$option_7")
		recipie_java 
		;;
		"$option_8")
		recipie_bleachbit
		;;
		"$option_9")
		recipie_codecs
		;;
		"$option_10")
		recipie_vlc
		;;
		"$option_11")
		recipie_anydesk
		;;
		"$option_12")
		recipie_google_chrome
		;;
		"$option_10")
		recipie_teamviewer
		;;
		"$option_13")
		recipie_teamviewer
		;;
		"$option_14")
		recipie_skype
		;;
		"$option_15")
		recipie_mega.nz
		;;
		"$option_16")
		recipie_dropbox
		;;
		"$option_17")
		recipie_secure_communication
		;;
		"$option_18")
		recipie_video_editing 
		;;
		"$option_19")
		recipie_media_streamers	
		;;
		"$option_20")
		recipie_audio_tools
		;;
		"$option_21")
		recipie_virtualbox
		;;
		"$option_22")
		recipie_steam 
		;;
		esac
	done  
}




#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Execute tasks                   ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# Ensure that this script is run with administrative priveledges such that it may
# alter system wide configuration. 
ensure_admin
PS_SAV=PS1
PS1='\[\e]0;System Setup\a\]\u@\h:\w\$ '

# Check that the relevant software maintenance system is available and ready, 
# and if it is not wait. When it is OK continue and ensure all is up to date. 
SofwareManagmentAvailabilityCHK
system_update



if ! xset q &>/dev/null; then
	echo "No X server at \$DISPLAY [$DISPLAY]" >&2
    	check_dependencies whiptail
	rtd_setup_choices_term_fallback
else     
	check_dependencies zenity
	choices_graphical 
	do_instructions_from_choices
	zenity  --question --title "Alert" --width=400 --height=400  --text "System update is complete! You may restart your system and start using it now! Would you like to RESTART NOW?"
		if [ $? = 0 ];
	      	then
		  echo "OK Rebooting."
		  reboot
		fi
fi




#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Finalize.....                   ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
PS1=PS_SAV
exit

