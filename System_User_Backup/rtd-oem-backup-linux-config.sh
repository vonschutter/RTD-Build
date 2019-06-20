#!/bin/bash
PUBLICATION="RTD Simple User Configuration Backup Script"
VERSION="1.00"
#
#::             RTD Ubuntu + derivatives backup script
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#:: Author:   	SLS 
#::
#::
#::	Purpose: The purpose of the script is to backup a users setings 
#::              and dokuments to some useful location.
#::
#:: This system configuration and installation script was originally developed
#:: for RuntimeData, a small OEM in Buffalo Center, IA. 
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
# Ensure that the  RTD Functions are available and load them... 
# This contains most of the intelligence used to perform this systems
# maintenance. 
# 
# the RTD Functions contain useful task functions (example): 
#  -  check_dependencies
#  -  ensure_admin
#
_FILE=_rtd_functions
_RTD_S_HOME=/opt/rtd/scripts
if [ -f $_RTD_S_HOME/$_FILE ]; then
   echo -e $GREEN"RTD Functions are available: Loading them for use... " $ENDCOLOR
   source $_RTD_S_HOME/$_FILE
else
   echo "Cannot find RTD Functions... Attempting to get them online... "
   sudo mkdir -p $_RTD_S_HOME
   sudo wget -q --show-progress https://github.com/vonschutter/RTD-Build/raw/master/"$_FILE" -P $_RTD_S_HOME
   if [ -f $_RTD_S_HOME/$_FILE ]; then
   	echo -e $GREEN"RTD Functions are available: Loading them for use... " $ENDCOLOR
   	source $_RTD_S_HOME/$_FILE
   else
   	echo -e $RED"RTD Functions could NOT be loaded; You must use the native options to instal software... "$ENDCOLOR
   	exit 
   fi
fi

# Set the background tilte:
BACKTITLE="RTD OEM Simple System Backup"

# Set the options to appear in the menu as choices:
option_1="Gnome Desktop Setings"
option_2="Gnome Credentials Manager"
option_3="Remmina Configuration" 
option_4="Users Private Themes" 
option_5="Users Private Icons" 
option_6="Users Private Fonts " 
option_7="Users Private Documents" 
option_8="Users Private Pictures" 
option_9="Firefox Settings" 
option_10="Chrome Settings"  
option_11="All VirtualBox VM's" 
option_12="Teamviewer Configuration" 
                   




#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Script Functions                ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#



# Function to request an encryption phrase. 
# This prase will be used to encrypt the compressed archives. 
function zenity_ask_for_encryption_pass_phrase () {
	check_dependencies whiptail
    	passtoken=$(zenity --title "Please enter encryption phrase" --password ) 
    	if [[ -z "$passtoken" ]]; then
                zenity --warning --width=300 --text="Your settings likely contain sensitive information and should be encrypted! Please set a pass phrase"
        fi
}



# Function to display the backup otions above. This is all done in a bit of a 
# round about way... but the idea is to prepare this setup to be flexible
# for the future so that you only have one place to list the option while
# more than one gui toolkit (dialog, zenity, whiptail) depending on your environment.
function zenity_show_list_of_user_backup_choices () {
        cmd=( zenity  --list  --width=800 --height=400 --text "$BACKTITLE" --checklist  --column "ON/OFF" --column "What to backup" --separator "," )
        zstatus=TRUE
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
                   )

       choices=$("${cmd[@]}" "${options[@]}" )
}
		
		
	
	
function rtd_user_bak () {
        7z a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=32m -ms=on -mhe=on -p$passtoken ~/`whoami`-$1-`date -u --iso-8601`.7z "${@:2}"

}	
	
		
# Function to do what the choices instruct. We read the output from 
# the choices and execute commands that accomplish the task requested. 
function do_instructions_from_choices (){
        IFS=$','
	for choice in $choices
	do
		case $choice in
	        "$option_1")
		rtd_user_bak "$option_1" ~/Templates 
		sleep 1
		;;
		"$option_2")
		rtd_user_bak "$option_2" ~/Templates
		sleep 1
		;;
		"$option_3")	
		rtd_user_bak "$option_3" ~/.local/share/remmina ~/.config/remmina
		sleep 1
		;;
		"$option_4")
		rtd_user_bak "$option_4" ~/.themes
		sleep 1
		;;
		"$option_5")
		rtd_user_bak "$option_5" ~/.icons
		sleep 1
		;;
		"$option_6")
		rtd_user_bak "$option_6" ~/.fonts
		sleep 1
		;;
		"$option_7")
		rtd_user_bak "$option_7" ~/Documents
		sleep 1
		;;
		"$option_8")
		rtd_user_bak "$option_8" ~/Pictures
		sleep 1
		;;
		"$option_9")
		rtd_user_bak "$option_9" ~/Templates
		sleep 1
		;;
		"$option_10")
		rtd_user_bak "$option_10" ~/.config/google-chrome/Default/Preferences
		sleep 1
		;;
		"$option_11")
		rtd_user_bak "$option_11" "~/VirtualBox VM's"
		sleep 1
		;;
		"$option_12")
		rtd_user_bak "$option_12" ~/.config/teamviewer
		sleep 1
		;;
		esac
	done  
}



#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Sript Flow Control              ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
#
# Software and configuration selections dialog. This will present a number of OEM defaults
# and other preferences that can be added to a system at will. To remove software it is 
# recommended to use the native software tool (Gnome Software, Yast, or Discover).
#
# Option defaults may be set to "on" or "off"

# "dialog" will be used to request interactive configuration...
# Ensure that it is available: 
trap "passtoken=nonsense" 0 1 2 5 15
zenity_ask_for_encryption_pass_phrase
zenity_show_list_of_user_backup_choices
do_instructions_from_choices 





#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Finalize.....                   ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
exit



#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          deprecated...                   ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


function fallback_show_list_of_user_backup_choices () {

        check_dependencies whiptail
        cmd=(whiptail --separate-output --backtitle "$BACKTITLE" --title "What to backup" --checklist "Please Select what you want to backup below:" 22 85 18 )
        optionlist=( 1 "Gnome Setings" ON 
                     2 "Gnome Credentials Manager" ON 
                     3 "Remmina Configuration" ON 
                     4 "Users Private Themes" ON 
                     5 "Users Private Icons" ON 
                     6 "Users Private Fonts " ON 
                     7 "Users Private Documents" ON 
                     8 "Users Private Pictures" ON 
                     9 "Firefox Settings" ON 
                     10 "Chrome Settings"  ON 
                     11 "VirtualBox VM's (may be really large files and take time)" ON 
                     12 "Teamviewer Configuration" ON 
                     )
}















