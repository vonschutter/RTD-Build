#!/bin/bash
#
#::             RTD Ubuntu + derivatives software addon and configuration script
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#:: Author(s):   	SLS, KLS, NB.  Buffalo Center, IA & Avarua, Cook Islands
#:: Version 1.00
#::
#::
#::	Purpose: - The purpose of the script is to setup extra apps/config that is useful for a complete and productive environment.
#::		 - Feature: this script "detects" how to install and update software and and tweak the system.
#::		 - Flexible: This script works on several distributions of Linux since it uses "RTD Functions". Of course, you could 
#::		   simply list all the "apt", "yum", or "zypper" commands along with the "snap" and "flatpak" to install
#::		   the software needed. However, you would likely need separate scripts for each distribution AND you
#::		   could not select or de-select software bundles or speciffic titles. This uses a GUI with a timeout for that.
#::		 - Smart: The "recipies" also downloads setup files from vendors with no repositories, and that do not have "snaps".
#::		 - Resiliant: This RTD installation system is therefore resiliant, stable, and flexible. 
#::		 - NOTE: This script is installed to /opt/rtd/ by a wraper script "rtd-me.sh.cmd" that will work on many systems.
#::		 - NOTE: This script may also be used without the wrapper, once the wrapper has been run once and installed the 
#::		   "RTD OEM Tools" to the system in question. 
#::
#::	Dependencies:
#::	  _rtd_functions -- contain usefull admin functions for scripts, such as "how to install software" on different systems. 
#::	  _rtd_recipies  -- contain software installation and configuration "recipies".
#::
#:: 	This system configuration and installation script was originally developed
#:: 	for RuntimeData, a small OEM in Buffalo Center, IA. The purpose of the script
#:: 	was to install and configure Ubuntu and Zorin OS PC's. This OEM and store nolonger
#:: 	exists as its owner has passed away. This script is shared in the hopes that
#:: 	someone will find it usefull.
#::
#::
#::
#::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#	
#	NOTE:	This terminal program is written and documented to a very high degree. The reason for doing this is that
#		these apps are seldom changed and when they are, it is usefull to be able to understand why and how 
#		things were built. Obviously, this becomes a useful learning tool as well; for all people that want to 
#		learn how to write admin scripts. It is a good and necessary practice to document extensively and follow
#		patterns when building your own apps and config scripts. Failing to do so will result in a costly mess
#		for any organization after some years and people turnover. 
#
#		As a general rule, we prefer using functions extensively because this makes it easier to manage the script
#		and facilitates several users working on the same scripts over time.
#		
# 
#	RTD admin scrips are placed in /opt/rtd/scripts. Optionally scripts may use the common
#	functions in _rtd_functions and _rtd_recipies. 
#
#	Taxonomy of this script: we prioritize the use of functions over monolithic script writing, and proper indentation
#	to make the script more readable. Each function shall also be documented to the point of the obvious.
#	Suggested function structure per google guidelines:
#
#	function_name () {
#		# Documentation and comments... 
#		...code...
#	}
#
#	We also like to log all activity, and to echo status output to the screen in a frienly way. To accomplish this,
#	the table below may be used as appropriate: 
#
#				OUTPUT REDIRECTION TABLE	
#	--------------------------------------------------------------------
#		  || visible in terminal ||   visible in file   || existing
#	  Syntax  ||  StdOut  |  StdErr  ||  StdOut  |  StdErr  ||   file   
#	==========++==========+==========++==========+==========++===========
#	    >     ||    no    |   yes    ||   yes    |    no    || overwrite
#	    >>    ||    no    |   yes    ||   yes    |    no    ||  append
#	          ||          |          ||          |          ||
#	   2>     ||   yes    |    no    ||    no    |   yes    || overwrite
#	   2>>    ||   yes    |    no    ||    no    |   yes    ||  append
#	          ||          |          ||          |          ||
#	   &>     ||    no    |    no    ||   yes    |   yes    || overwrite
#	   &>>    ||    no    |    no    ||   yes    |   yes    ||  append
#	          ||          |          ||          |          ||
#	 | tee    ||   yes    |   yes    ||   yes    |    no    || overwrite
#	 | tee -a ||   yes    |   yes    ||   yes    |    no    ||  append
#	          ||          |          ||          |          ||
#	 n.e. (*) ||   yes    |   yes    ||    no    |   yes    || overwrite
#	 n.e. (*) ||   yes    |   yes    ||    no    |   yes    ||  append
#	          ||          |          ||          |          ||
#	|& tee    ||   yes    |   yes    ||   yes    |   yes    || overwrite
#	|& tee -a ||   yes    |   yes    ||   yes    |   yes    ||  append
#	-------------------------------------------------------------------
#
#	Our scripts are also structured in to three major sections: "settings", "functions", and "execute". 
#	Settings, contain configurable options for the script. Functions, contain all functions. Execute, 
#	contains all the actual logic and control of the script. 
#
#

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Script Settings                 ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Variables that govern the behavior or the script and location of files are 
# set here. There should be no reason to change any of this.

# Use the RTD function library. This contains most of the intelligence used to perform this systems
# maintenance. This will allso enable color some easily referenced color prompts:
# $YELLOW, $RED, $ENDCOLOR (reset), $GREEN, $BLUE etc. 
# As this library is required for basically everything, we should exit if it is not available. 
# Logically, this script will not run, ever, unless downloaded along with the functions and the
# rtd software recipie book by rtd-me.sh, or on a RTD OEM system where these components would have been 
# downloaded by the preseed or kickstart process as part of the install.






# Decide where to put log files.
# Default: log in to the $_RTDLOGSD location dated accordingly. If this is already set 
# we use the requested location.
if [ -z "$_ERRLOGFILE" ]; then _ERRLOGFILE=$_RTDLOGSD/$(date +%Y-%m-%d-%H-%M-%S-%s)-oem-setup-error.log ; else echo "	Errors will be logged to: '$_ERRLOGFILE'"; fi
if [ -z "$_LOGFILE" ]; then _LOGFILE=$_RTDLOGSD/$(date +%Y-%m-%d-%H-%M-%S-%s)-oem-setup.log ; else echo "	Logfile is set to: '$_LOGFILE'"; fi

# Normally all choices are checked. Pass the variable "false" to this script to default   
# to unchecked. If none is passed, a default will be used. 
export zstatus="$1"


# Set the background tilte:
_BACK_TITLE="${_BACK_TITLE:="RTD OEM Simple System Setup"}"

# Set the options to appear in the menu as choices:
option_1="Apply Themes and Desktop Tweaks"
option_2="WPS Office (Excellent office suite with a modern look and feel)"
option_3="Software to Write Code and Scripts Bundle" 
option_4="Compression Tools Bundle" 
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
option_23="Install the Microsoft Windows subsystem"
option_24="Vivaldi Web Browser"
option_25="Brave Security Enhanced Browser"
option_26="Remove all non-western (latin) fonts"


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
	cmd=( zenity  --list  --timeout 60 --width=800 --height=600 --text "$_BACKTITLE" --checklist  --column "ON/OFF" --column "Select Software to add:" --separator "," )
	zstatus="${zstatus:=true}"
	options=(	$zstatus "$option_1"
			$zstatus "$option_2"
			$zstatus "$option_3"
			$zstatus "$option_4"
			false    "$option_5"
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
			$zstatus "$option_23"
			$zstatus "$option_24"
			$zstatus "$option_25"
			$zstatus "$option_26"
			)
	choices=$("${cmd[@]}" "${options[@]}" )
}
		
		
	
		
# Function to do what the choices instruct. We read the output from 
# the choices and execute commands that accomplish the task requested. 
function do_instructions_from_choices (){
	IFS_SAV=$IFS
        IFS=$','
	for choice in $choices
	do
		IFS=$' '
		case $choice in
		"$option_1")	add_software_task recipie_OEM_config ;;
		"$option_2")	add_software_task recipie_wps_office ;;
		"$option_3")	add_software_task recipie_developer_software ;;
		"$option_4")	add_software_task recipie_compression_tools ;;
		"$option_5")	add_software_task recipie_games	;;
		"$option_6")	add_software_task recipie_admin_tools ;;
		"$option_7")	add_software_task recipie_java ;;
		"$option_8")	add_software_task recipie_bleachbit ;;
		"$option_9")	add_software_task recipie_codecs ;;
		"$option_10")	add_software_task recipie_vlc ;;
		"$option_11")	add_software_task recipie_anydesk ;;
		"$option_12")	add_software_task recipie_google_chrome	;;
		"$option_13")	add_software_task recipie_teamviewer ;;
		"$option_14")	add_software_task recipie_skype	;;
		"$option_15")	add_software_task recipie_mega.nz ;;
		"$option_16")	add_software_task recipie_dropbox ;;
		"$option_17")	add_software_task recipie_secure_communication ;;
		"$option_18")	add_software_task recipie_video_editing ;;
		"$option_19")	add_software_task recipie_media_streamers ;;
		"$option_20")	add_software_task recipie_audio_tools ;;
		"$option_21")	add_software_task recipie_virtualbox ;;
		"$option_22")	add_software_task recipie_steam ;;
		"$option_23")	add_software_task recipie_wine ;;
		"$option_24")	add_software_task recipie_vivaldi ;;
		"$option_25")	add_software_task recipie_brave	;;
		"$option_26")	rtd_oem_remove_non_western_latin_fonts ;;
		esac
	done
	IFS=$IFS_SAV
}




#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Execute tasks                   ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# Ensure that this script is run with administrative priveledges such that it may
# alter system wide configuration. 
# ensure_admin
if [[ ! $UID -eq 0 ]]; then
	echo -e $YELLOW "This script needs administrative access..." $ENDCOLOR
	sudo bash $0 $*
else
	PS_SAV=PS1
	PS1='\[\e]0;System Setup\a\]\u@\h:\w\$ '

	if  [[ -f /opt/rtd/scripts/_rtd_library ]]; then 
		source /opt/rtd/scripts/_rtd_library
	else 
		echo -e $RED "RTD functions NOT loaded!" $ENDCOLOR
		echo -e $YELLOW " " $ENDCOLOR
		echo -e $YELLOW "Cannot ensure that the correct functionality is available" $ENDCOLOR
		echo -e $YELLOW "Quiting rather than cause potential damage..." $ENDCOLOR
		exit 1
	fi

	rtd_wait_for_internet_availability
	rtd_oem_reset_default_environment_config
	SofwareManagmentAvailabilityCHK
	up2date

	if [[ -z $DISPLAY ]]; then 
		echo "No X server at \$DISPLAY [$DISPLAY]" >&2
		check_dependencies dialog
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
fi


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Finalize.....                   ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
PS1=PS_SAV
exit

