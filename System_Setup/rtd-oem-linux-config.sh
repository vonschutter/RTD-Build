#!/bin/bash
#
#::             	Linux software addon and configuration script
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#:: Author(s):   	Vonschutter, KLS, NB.  Buffalo Center, IA & Avarua, Cook Islands
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
: "${_BACK_TITLE:-"RTD OEM Simple System Setup"}"


function choices_graphical () 
{
# Function to display the  otions. This is all done in a bit of a 
# round about way... but the idea is to prepare this setup to be flexible
# for the future so that you only have one place to list the option while
# more than one gui toolkit (dialog, zenity, whiptail) depending on your environment.

	cmd=( zenity  --list  --timeout 60 --width=800 --height=600 --text "$_BACKTITLE" --checklist  --column "ON/OFF" --column "Select Software to add:" --separator "," )
	zstatus="${zstatus:=false}"
	sw_list=$(debug_list_loaded_software_functions)

	loaded_software_recipies ()
	{
		echo "case $choice in" 
		echo ${sw_list[@]} | while read line; do
			echo "$line ) add_software_task $line ;;" 
		done
		echo "esac"

	}
	MenuOptions=($(for i in $sw_list ; do echo -e "\"false\" \"$i\"" ; done ))

	declare -A choices
	choices=$("${cmd[@]}" "${MenuOptions[@]}" )

	IFS_SAV=$IFS
        IFS=$','
	for choice in ${choices}
		do
		IFS=$' '
		loaded_software_recipies >start
		source ./start
	done
	IFS=$IFS_SAV
}



complete_setup () {
	#conditional default value option for the OEM reaseal
	if hostnamectl |grep "Ubuntu" 2>/dev/null ; then
		ConditionalResealOption="Reseal system and prepare for delivery to new user"
	elif hostnamectl |grep "Pop!_OS" 2>/dev/null ; then
		ConditionalResealOption="Reseal system and prepare for delivery to new user"
	else
		unset ConditionalResealOption
	fi

	completion=$(printf "Restart system and start using it now\nExit now and do no more\n${ConditionalResealOption}\n" | zenity \
				--list \
				--title "System Setup Complete" \
				--text "Please select if you witsh to reseal the sysetm, restart and use the system, or just exit" \
				--column "Options" --width=1024 --height=768 )
	case "$completion" in 
		"Restart system and start using it now" ) write_information "Restarting system..." ; reboot ;;
		"${ConditionalResealOption:-"Ignore"}" ) write_information "Resealing system..." ; rtd_oem_reseal ;;
		"Exit now and do no more" ) write_information "Quitting..." ; exit ;;
		* ) echo unknown option ; exit 1 ;;
	esac
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
	echo -e "This script needs administrative access..." 
	sudo bash $0 $*
else
	if  [[ -f /opt/rtd/scripts/_rtd_library ]]; then 
		source /opt/rtd/scripts/_rtd_library
	else 
		echo -e "RTD functions NOT loaded!" 
		echo -e " " 
		echo -e "Cannot ensure that the correct functionality is available" 
		echo -e "Quiting rather than cause potential damage..." 
		exit 1
	fi

	rtd_wait_for_internet_availability
	rtd_oem_reset_default_environment_config
	SofwareManagmentAvailabilityCHK
	rtd_update_system

	if [[ -z $DISPLAY ]]; then 
		echo "No X server at \$DISPLAY [$DISPLAY]" >&2
		check_dependencies dialog
		rtd_setup_choices_term_fallback
	else
		check_dependencies zenity
		choices_graphical
		complete_setup
	fi
fi


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Finalize.....                   ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
exit
EOF
