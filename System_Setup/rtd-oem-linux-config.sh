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
export _LOGFILE=$0.log
export _ERRLOGFILE=$0-error.log


# Set the background tilte:
BACKTITLE="RTD OEM Simple System Setup"

# Set the options to appear in the menu as choices:
option_1="Base RTD OEM Productivity Software"
option_2="Developer Software: LAMP Stack"
option_3="Developer Software: IDE Tools and Compilers" 
option_4="OEM Comression Tools (zip, 7zip rar etc.)" 
option_5="OEM Selection of Quality Games" 
option_6="OEM System Administrative Tools" 
option_7="Oracle Java" 
option_8="Bleachbit System Cleaning Tool" 
option_9="Commercially Restricted Extras (prorietary video and audio formats)" 
option_10="VLC Media Player"  
option_11="Gnome Tweak Tool" 
option_12="Google Chrome" 
option_13="Teamiewer"  
option_14="Skype" 
option_15="MEGA nz Encrypted Cloud Storage" 
option_16="Dropbox Cloud Storage"  
option_17="Optional Desktop Tweaks" 
option_18="Openshot video editor" 
option_19="Media Streamers (Spotify and podcast software)"  
option_20="Audio Tools" 
option_21="Oracle VirtualBox" 
option_22="Runtime Data OEM Configuration" 




#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Base OEM Configuration          ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
#
# Software and configuration selections dialog. This will present a number of OEM defaults
# and other preferences that can be added to a system at will. To remove software it is 
# recommended to use the native software tool (Gnome Software, Yast, or Discover).
#
# Option defaults may be set to "on" or "off"


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Script Functions                ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#

system_update () {
    if hash pkcon 2>/dev/null; then
        SofwareManagmentAvailabilityCHK
    	pkcon refresh
    	echo For the sake of robustness we will chech again if the system 
    	echo software managment is available before running the update... 
    	SofwareManagmentAvailabilityCHK
        pkcon update -y
    else
        echo "You seem to have now Package Kit... I will try to get it... "
        echo "I will need to become admin to do that..."
        sudo apt install packagekit
            if [ $? != 0 ];
            then
                echo "That install didn't work out so well."
                echo "Defaulting to the onld Up2Date Function"
                up2date
            fi
        echo "OK trying again!"
        SofwareManagmentAvailabilityCHK
    	pkcon refresh
    	echo For the sake of robustness; we will chech again if the system 
    	echo software managment is available before running the update... 
    	SofwareManagmentAvailabilityCHK
        pkcon update -y
    fi
}


# Function to display the  otions above. This is all done in a bit of a 
# round about way... but the idea is to prepare this setup to be flexible
# for the future so that you only have one place to list the option while
# more than one gui toolkit (dialog, zenity, whiptail) depending on your environment.
function choices_graphical () {
        cmd=( zenity  --list  --width=800 --height=400 --text "$BACKTITLE" --checklist  --column "ON/OFF" --column "Configuration Choices:" --separator "," )
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
		case $choice in
	        "$option_1")
		 recipie_baseapps
		;;
		"$option_2")
		recipie_lamp_software
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
		recipie_tweaktool 
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
		recipie_gnome_config
		;;
		"$option_18")
		recipie_openshot
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
		recipie_OEM_config
		;;
		esac
	done  
}

function choices_term () {
	# List Options to be available for choice in the RTD System Configurator...
	cmd=(whiptail --backtitle "RTD OEM System Builder Configuraton Menu" --title "Software Options Menu" --separate-output --checklist "Please Select Software and Configuration below:" 22 85 16 )
	options=(1 "Base RTD OEM Productivity Software" on    
		 2 "Developer Software: LAMP Stack" off
		 3 "Developer Software: IDE Tools and Compilers" on
		 4 "OEM Comression Tools (zip, 7zip rar etc.)" on
		 5 "OEM Selection of Quality Games" on
		 6 "OEM System Administrative Tools" on
		 7 "Oracle Java" on
		 8 "Bleachbit System Cleaning Tool" on
		 9 "Commercially Restricted Extras (prorietary video and audio formats)" on
		 10 "VLC Media Player" on
		 11 "Gnome Tweak Tool" on
		 12 "Google Chrome" on
		 13 "Teamiewer" on
		 14 "Skype" on
		 15 "MEGA nz Encrypted Cloud Storage" on
		 16 "Dropbox Cloud Storage" on
		 17 "Optional Desktop Tweaks" on
		 18 "Openshot video editor" on
		 19 "Media Streamers (Spotify and podcast software)" on
		 20 "Audio Tools" on
		 21 "Oracle VirtualBox" on
		 22 "Runtime Data OEM Configuration" on
		)

			choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
			clear
			for choice in $choices
			do
			    case $choice in
				1)
				recipie_baseapps
				;;
				2)
				recipie_lamp_software
				;;
	    			3)	
				recipie_developer_software 
				;;
				4)
				recipie_compression_tools
				;;
				5)
				recipie_games			
				;;
				6)
				recipie_admin_tools
				;;
				7)
				recipie_java 
				;;
				8)
				recipie_bleachbit
				;;
				9)
				recipie_codecs
				;;
				10)
				recipie_vlc
				;;
				11)
				recipie_tweaktool 
				;;
				12)
				recipie_google_chrome
				;;
				13)
				recipie_teamviewer
				;;
				14)
				recipie_skype
				;;
				15)
				recipie_mega.nz
				;;
				16)
				recipie_dropbox
				;;
				17)
				recipie_gnome_config
				;;
				18)
				recipie_openshot
				;;
				19)
				recipie_media_streamers	
				;;
				20)
				recipie_audio_tools
				;;
				21)
				recipie_virtualbox
				;;
				22)	
				recipie_OEM_config
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

# Set the install instructions. This accepts apt, yum, or zypper.. 
set_install_command

# Enable firewall. This presently expects ufw only. 
enable_firewall

# Check that the relevant software maintenance system is available and ready, 
# and if it is not wait. When it is OK continue and ensure all is up to date. 
SofwareManagmentAvailabilityCHK

system_update


if ! echo "$XDG_CURRENT_DESKTOP" | grep -q "GNOME"; then
	check_dependencies zenity
	choices_graphical 
	do_instructions_from_choices
else
	check_dependencies whiptail
	choices_term

fi









#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Finalize.....                   ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# Clean up and Finalize
echo -e $YELLOW"--- Remove any unused applications and esure all the latest updates are installed lastly..." $ENDCOLOR
	up2date


zenity --notification --window-icon=update.png --text "System update is complete! You may restart your system and start using it now"
zenity  --question --title "Alert" --width=400 --height=400  --text "System update is complete! You may restart your system and start using it now! Would you like to RESTART NOW?"
if [ $? = 0 ];
      then
          echo "OK Rebooting."
	  reboot
fi



exit


































###########################################################################
##                                                                       ##
##                          Versions                                     ##
##                                                                       ##
###########################################################################
#
#
# 1.0: Stephan
#		- Created functions SofwareManagmentAvailabilityCHK InstallSoftwareFromRepo adn up2date
#		- Rewrote and reordered the script to use these functions instead of repeating commends
#		- Added _INSTCMD variable to make stable the use of apt installing multiple packages.
#		- instructed apt to be less verbose...
#		- Added root priveledge escalation at beginning of script cor convenience
#
# .90: Stephan
#		- Added vidcutter from repo
#
#	.08: Stephan
#		- removed old apps
#		- Deprecated non working repos to FIX ME
#		- Achived the add proxy function for later
#		- added sun-java back again
#
#
#	.07: Nate
#		- removed old apps
#		- added supertuxkart and pioneers to games
#		- removed mozilla-plugin-vlc until dep is set to vlc 2.0
#		- added mplayer daily build ppa
#		- changed the sources.list mirror to mirror.umoss.org
#		- download win version of picasa 3.9 and install with wine
#		- updated virtualbox extension pack to 4.1.10
#		- future updates download automatically, but do not install automatically
#
#
#	.06: Nate
#		- updates for Unity and Ubuntu 11.10 Oneiric Ocelot
#		- changed proxy to new apollo Xubuntu 11.10 server
#		- updated Google repos
#		- removed sun-java since no longer in repos
#		- removed old vlc ppas
#		- added getdeb repos
#		- frostwire from getdeb repo
#		- 32 or 64 bit detection for apps installed from web
#		- added Virtualbox repository and 4.1.8 extpack
#		- downloads Win7 Wallpapers
#
#
#	.05: Nate
#		- changed naming convention
#		- fixed nx nomachine urls
#		- added nmap and aptitude
#		- changed first 'apt-get upgrade' to 'apt-get dist-upgrade' to catch
#			some updates that get held back otherwise
#		- found that google earth has a repo, added to google.list
#		- stopped likewise from opening, found to stall shutdown of PC
#		- auto accept java eula, move out java and frostwire out of hall of shame
#		- set sun java to default, instead of openjdk.  Better support in firefox.
#		- auto accept msttcorefonts eula, move out of hall of shame
#		- samba service name changed to smbd, changed where workgroup is set to Hive
#
#	.04: Nate
#		- skype back in partner repos, no longer download the deb
#		- enabled maverick-proposed repos
#		- updated medibuntu repo info
#		- moved wine and likewise-open to the hall of shame, because
#		  	of annoying prompts
#		- added handbrake ppa
#		- fixed and updated gourmet recipe manager url
#		- added xsane and k3b
#		- updated frostwire url and added dependency resolving
#		- added apt proxy support.  Proxy currently hosted on terabyte.
#			Proxy is activated before install and deactivated after
#			to ensure that machines will still get updates after they
#			leave the local network.
#		- google earth package creator doesn't work, reccommended method
#			is to download directly from google
#
#	.03: Nate
#	- removed old (c-korn) vlc ppa and added two new ones.
#		- added mozilla-plugin-vlc
#
#
#	.02: Nate
#		- added hulu deb downloaded from website
#		- added wine ppa
#		- fixed vlc ppa
#
#	.01: Nate
#		- added downloading function "dl ()"
#		- changed vlc repo to new method
#		- fixed google repo code and added testing repo for picasa
#		- removed firefox repo that was no longer updated
#		- removed gnome-do to get rid of search popup on first boot and subsequent reboots
#		- removed kmahjongg since mahjongg is already part of default gnome games
#		- added code to install googleearth with googleearth-package
#		- updated frostwire, gourmet recipe manager, and skype; all of which require manual downloads
#		- added Virtualbox for using virtual machines
#
#	.00 - original Stephan
#


################################ Module ###################################
###																																			###
### Adding and removing proxy support by Nate B. Buffalo Center, IA			###
###																																			###
###########################################################################
#
# Add apt proxy support
#	echo -e "Would you like to enable apt proxy support for internal use only? (y/n)"
#	read prxy
#	if [ "$prxy" == "y" -o "$prxy" == "Y" -o "$prxy" == "" ]; then
#		echo -e 'Acquire::http::Proxy "http://apollo:3142";\nAcquire::http::Timeout "10";' | tee /etc/apt/apt.conf.d/02proxy
#	elif [ "$prxy" == "n" -o "$prxy" == "N" ]; then
#		true
#	fi
#
# Remove proxy support
#	if [ "$prxy" == "y" -o "$prxy" == "Y" -o "$prxy" == "" ]; then
#		rm /etc/apt/apt.conf.d/02proxy
#	fi

################################ Module ###################################
###																																			###
###                Change mirrors to speciffic ones											###
###																																			###
###########################################################################
# Change the mirror
#	sed -i -e "s/us\.archive\.ubuntu\.com/mirror.umoss.org/g" /etc/apt/sources.list
#	sed -i -e "s/security\.ubuntu\.com/mirror.umoss.org/g" /etc/apt/sources.list

#################    FIX ME   	################################################
# Add Google Linux Repository and signing key
#	echo "deb http://dl.google.com/linux/deb/ stable non-free" | tee /etc/apt/sources.list.d/google.list
#	echo "deb http://dl.google.com/linux/deb/ testing main non-free" | tee -a /etc/apt/sources.list.d/google.list
#	echo "deb http://dl.google.com/linux/earth/deb stable main" | tee /etc/apt/sources.list.d/google-earth.list
#	echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee -a /etc/apt/sources.list.d/google-chrome.list
#	#echo "deb http://dl.google.com/linux/talkplugin/deb/ stable main" | tee -a /etc/apt/sources.list.d/google-talkplugin.list
#	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -


#################  Runtime Data Speciffic #####################################

# Copy wallpapers to home directory
#	wget http://www.runtimedata.com/l1nux/Ubuntu\ Setup/Win7\ Wallpaper.7z -P /tmp
#	7z e /tmp/Win7\ Wallpaper.7z -o$HOME/Win7\ Wallpaper
#	chown user1:user1 $HOME/Win7\ Wallpaper -R
#	chmod 755 $HOME/Win7\ Wallpaper
###########################################################################
##                                                                       ##
##       Hall of shame: Special Case 3rd party software                  ##
##                                                                       ##
###########################################################################
#
# Shamefully some organizations and maintainers absolutely insist on strict 
# legal interpretations of licence models etc. such that they insist on 
# somebody physically agreeing to the licence. This does not apply to RPM 
# based system though since the speciffication does not allow for any user input
# during install. Moreover, some refuse to include their software in official repositories
# or in snap or flatpack stores ad prefer to have their own downoads. This causes
# headaches for admins that want to install said software... so here is the hall of shame 
# for those software packages. 
#


# [Tweaks]
# Change Samba workgroup
#	sed -i -e "s/workgroup = WORKGROUP/workgroup = HIVE/g" /etc/samba/smb.conf
#	service smbd restart
#	service nmbd restart

# :::::::::::::::::::::   Disabled due to lack of maintenance :::::::::::::::::::::::::::::
# Special Case for installing green recorder...
#echo -e $YELLOW"--- Installing "greenrecorder" screen recorder..." $ENDCOLOR
#		add-apt-repository -y ppa:mhsabbagh/greenproject 1>>$_LOGFILE 2>>$_ERRLOGFILE
#		apt update  1>>$_LOGFILE 2>>$_ERRLOGFILE
#		InstallSoftwareFromRepo  green-recorder

# Special case for installing Vidcutter
#echo -e $YELLOW"--- Adding Vidcutter repository..." $ENDCOLOR
#		add-apt-repository -y ppa:ozmartian/apps 1>>$_LOGFILE 2>>$_ERRLOGFILE
#		apt update -y 1>>$_LOGFILE 2>>$_ERRLOGFILE
#		apt-get -y -qq --allow-change-held-packages --ignore-missing install  vidcutter

# ::::::::::::::::::::: Disabled since available in snap store ::::::::::::::::::::::::::::::
# Special case for installing signal secure messenger
# echo -e $YELLOW "--- Installing signal secure messenger..." $ENDCOLOR
# 		curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
#		echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
#		InstallSoftwareFromRepo signal-desktop













