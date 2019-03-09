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

# Ensure that this script is run with administrative priveledges such that it may
# alter system wide configuration. 
ensure_admin

# Set the install instructions. This accepts apt, yum, or zypper.. 
set_install_command

# Enable firewall. This presently expects ufw only. 
enable_firewall

# Check that the relevant software maintenance system is available and ready, 
# and if it is not wait. When it is OK continue and ensure all is up to date. 
#SofwareManagmentAvailabilityCHK
#up2date



#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Base Software                   ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
#

check_dependencies dialog
cmd=(dialog --separate-output --checklist "Please Select Software and Configuration below:" 22 76 16)
options=(1 "Base OEM Software" on    # any option can be set to default to "on"
         2 "Developer Software: LAMP Stack" off
         3 "Developer Software: Build Essentials" off
         4 "Developer Software: Node.js" off
         5 "Developer Software: Git" off
         6 "Developer Software: Composer" off
         7 "Oracle Java" on
         8 "Bleachbit System Cleaning Tool" off
         9 "Ubuntu Restricted Extras (To play prorietary video and audio formats)" on
         10 "VLC Media Player" on
         11 "Gnome Tweak Tool" on
         12 "Google Chrome" on
         13 "Teamiewer" on
         14 "Skype" on
         15 "Paper GTK Theme" on
         16 "Arch Theme" on
         17 "Arc Icons" on
         18 "Numix Icons" on
	 19 "MEGA nz Encrypted Cloud Storage" on
	 20 "Openshot video editor" off
	 21 "Netspeed Indicator" off
	 22 "Generate SSH Keys" off
	 23 "Oracle VirtualBox" on
	 24 "Runtime Data OEM Configuration" on
)
		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
		do
		    case $choice in
	        	1)
			echo -e $YELLOW"--- Install base apps for Productivity..." $ENDCOLOR

				# Loop through each item in this list of softwar and perform an install 
				# using the relevant packaging system. 
				for i in p7zip-full p7zip-rar rar zip \
					dreamchess supertuxkart 0ad \
					terminix nmap synaptic ssh gparted sshfs htop iftop nethogs vnstat ifstat dstat nload glances bmon \
					vim vim-scripts gufw gnome-tweak-tool \
					samba wine-stable variety diodon shutter nautilus-dropbox\
					gnome-twitch polari filezilla vlc libdvdcss2 ffmpeg
				do
				     InstallSoftwareFromRepo $i
				done

				echo -e $YELLOW"--- Install snap apps for Productivity..." $ENDCOLOR
				# Ensure that snap is available prior to attempting to use it. 
				check_dependencies snap

				snap list
				# 1>>$_LOGFILE
				snap install atom --classic  2>>$_ERRLOGFILE
				snap install spotify  2>>$_ERRLOGFILE

				snap install screencloudplayer  2>>$_ERRLOGFILE
				snap install picard  2>>$_ERRLOGFILE
				snap install google-play-music-desktop-player  2>>$_ERRLOGFILE
				snap install signal-desktop 2>>$_ERRLOGFILE
				snap install vidcutter 2>>$_ERRLOGFILE

				;;

			2)
			    	#Install LAMP stack
				echo "Installing Apache"
				apt install apache2 -y
	            
    				echo "Installing Mysql Server"
	 			apt install mysql-server -y

        			echo "Installing PHP"
				apt install php libapache2-mod-php php-mcrypt php-mysql -y
	            
        			echo "Installing Phpmyadmin"
				apt install phpmyadmin -y

				echo "Cofiguring apache to run Phpmyadmin"
				echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
				
				echo "Enabling module rewrite"
				sudo a2enmod rewrite
				echo "Restarting Apache Server"
				service apache2 restart
				;;
    			3)	
				#Install Build Essentials
				echo "Installing Build Essentials"
				InstallSoftwareFromRepo build-essential
				;;
				
			4)
				#Install Nodejs
				echo "Installing Nodejs"
				curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
				InstallSoftwareFromRepo nodejs
				;;

			5)
				#Install git
				echo "Installing Git, please congiure git later..."
				InstallSoftwareFromRepo git -y
				;;
			6)
				#Composer
				echo "Installing Composer"
				EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
				php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
				ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

				if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
				  then
				php composer-setup.php --quiet --install-dir=/bin --filename=composer
				RESULT=$?
				rm composer-setup.php
				else
				  >&2 echo 'ERROR: Invalid installer signature'
				  rm composer-setup.php
				fi
				;;
			7)
				#JDK 8
				echo "Installing JDK 8"
				# Special case for installing Oracle Java...
				echo -e $YELLOW"--- Adding Oracle repository..." $ENDCOLOR
				# Add the Oracle repository and pre-answer the licens questions.
				add-apt-repository -y ppa:webupd8team/java 1>>$_LOGFILE 2>>$_ERRLOGFILE
				apt update  1>>$_LOGFILE 2>>$_ERRLOGFILE
				echo --- Installing java-8...
				echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
				apt-get -y -qq --allow-change-held-packages --ignore-missing install oracle-java8-installer oracle-java8-set-default
				;;
			8)
				#Bleachbit
				echo "Installing BleachBit"
				InstallSoftwareFromRepo bleachbit 
				;;
			9)
				#Ubuntu Restricted Extras
				echo "Installing Ubuntu Restricted Extras"
				echo -e $YELLOW"--- Install all the required multimedia codecs..." $ENDCOLOR
				# Auto accept microsoft corefonts eula
				echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections
				InstallSoftwareFromRepo ubuntu-restricted-extras
				;;
			10)
				#VLC Media Player
				echo "Installing VLC Media Player"
				InstallSoftwareFromRepo vlc
				;;
			11)
				#Unity tweak tool
				echo "Installing Unity Tweak Tool"
				InstallSoftwareFromRepo unity-tweak-tool
				;;
			12)

				#Chrome
				# Special case for installing Google Chrome
				echo -e $YELLOW"--- Installing Google Chrome Browser from google directly..." $ENDCOLOR
				dl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb google-chrome-stable_current_amd64.deb 
				;;
			13)
				#Teamviewer
				echo "Installing Teamviewer"
				dl http://download.teamviewer.com/download/teamviewer_i386.deb teamviewer_i386.deb 
				;;
			14)

				#Skype for Linux
				echo "Installing Skype For Linux"
				snap install skype --classic  2>>$_ERRLOGFILE
				;;
			15)

				#Paper GTK Theme
				echo "Installing Paper GTK Theme"
				add-apt-repository ppa:snwh/pulp -y 1>>$_LOGFILE 2>>$_ERRLOGFILE
				apt-get update 1>>$_LOGFILE 2>>$_ERRLOGFILE
				InstallSoftwareFromRepo paper-gtk-theme -y 1>>$_LOGFILE 2>>$_ERRLOGFILE
				InstallSoftwareFromRepo paper-icon-theme -y 1>>$_LOGFILE 2>>$_ERRLOGFILE
				;;
			16)
				#Arc Theme
				echo "Installing Arc Theme"
				add-apt-repository ppa:noobslab/themes -y 1>>$_LOGFILE 2>>$_ERRLOGFILE
				apt-get update 1>>$_LOGFILE 2>>$_ERRLOGFILE
				InstallSoftwareFromRepo arc-theme
				;;
			17)

				#Arc Icons
				echo "Installing Arc Icons"
				add-apt-repository ppa:noobslab/icons -y 1>>$_LOGFILE 2>>$_ERRLOGFILE
				apt-get update 1>>$_LOGFILE 2>>$_ERRLOGFILE
				InstallSoftwareFromRepo arc-icons
				;;
			18)
				#Numix Icons
				echo "Installing Numic Icons"
				apt-add-repository ppa:numix/ppa -y 1>>$_LOGFILE 2>>$_ERRLOGFILE
				apt-get update 1>>$_LOGFILE 2>>$_ERRLOGFILE
				InstallSoftwareFromRepo numix-icon-theme numix-icon-theme-circle 
				;;
			19)	
				# Special case for installing MEGA nz file sync utility (better than Drop Box)...
				echo -e $YELLOW"--- Installing MEGA nz file crypto sync utility..." $ENDCOLOR
				FILE2GET="megasync-xUbuntu_`lsb_release -sr`_amd64.deb"
				URL="https://mega.nz/linux/MEGAsync/xUbuntu_`lsb_release -sr`/amd64/$FILE2GET"
				dl $URL $FILE2GET 1>>$_LOGFILE 2>>$_ERRLOGFILE


				;;
			20)
				# Special case for installing Openshot video editor
				echo -e $YELLOW"--- Installing Openshot video editor..." $ENDCOLOR
				add-apt-repository -y ppa:openshot.developers/ppa 1>>$_LOGFILE 2>>$_ERRLOGFILE
				apt-get update 1>>$_LOGFILE 2>>$_ERRLOGFILE
				apt-get -y -qq --allow-change-held-packages --ignore-missing install openshot openshot-doc 1>>$_LOGFILE 2>>$_ERRLOGFILE
				;;
			21)
				echo "Installing NetSpeed Indicator"
				apt-add-repository ppa:fixnix/netspeed -y1 >>$_LOGFILE 2>>$_ERRLOGFILE
				apt-get update 1>>$_LOGFILE 2>>$_ERRLOGFILE
				InstallSoftwareFromRepo indicator-netspeed-unity
				;;
			22)
				echo "Generating SSH keys"
				ssh-keygen -t rsa -b 4096
				;;
			23)
				# Special case for installing VirtualBox
				echo -e $YELLOW"--- Installing VirtualBox if available..." $ENDCOLOR
				echo virtualbox virtualbox/module-compilation-allowed boolean true | /usr/bin/debconf-set-selections
				echo virtualbox virtualbox/delete-old-modules boolean true | /usr/bin/debconf-set-selections
				# Loop through each item in this list of softwar and perform an install 
				# using the relevant packaging system. 
				for i in virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-guest-additions-iso 
				do
				     InstallSoftwareFromRepo $i
				done	
				# Ensure that the current user can use USB etc... 			
				if id -nG "$SUDO_USER" | grep -qw "vboxusers"; then
				    echo      $SUDO_USER already belongs to vboxusers group
				else
				    usermod -G vboxusers -a $SUDO_USER 1>>$_LOGFILE 2>>$_ERRLOGFILE
				fi
				;;
			24)	
				echo "Applying OEM Configuration..."
				#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				#::::::::::::::                                          ::::::::::::::::::::::
				#::::::::::::::          Desktop Settings                ::::::::::::::::::::::
				#::::::::::::::                                          ::::::::::::::::::::::
				#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				# Install Wallpapers and configure Gnome to see them. ...
				RTDCP=/opt/rtd/cache
				mkdir -p $RTDCP && wget -q --show-progress https://github.com/vonschutter/RTD-Media/archive/master.zip -P $RTDCP && unzip -q $RTDCP/master.zip -d $RTDCP
				pushd $RTDCP && mv RTD-Media-master/Wallpaper .. && mv RTD-Media-master/Sound .. 

				mkdir -p /usr/local/share/gnome-background-properties
				DIRECTORY=/opt/rtd/Wallpaper/
				ls $DIRECTORY > lspictures.txt

				# Make a header
				echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
				<!DOCTYPE wallpapers SYSTEM \"gnome-wp-list.dtd\">
				<wallpapers>" > mybackgrounds.xml
				# Registering all pictures in $DIRECTORY

				for i in $DIRECTORY*.jpg $DIRECTORY*.png; do
				echo "<wallpaper>
				<name>$i</name>
				<filename>$i</filename>
				  <options>stretched</options>
				    <pcolor>#8f4a1c</pcolor>
				    <scolor>#8f4a1c</scolor>
				    <shade_type>solid</shade_type>
				  </wallpaper>" >> mybackgrounds.xml
				done

				# creating the footer
					echo "</wallpapers>" >> mybackgrounds.xml
					sed 's/<name>\/usr\/share\/backgrounds\//<name>/g' mybackgrounds.xml > /usr/local/share/gnome-background-properties/mybackgrounds.xml
					cp /usr/local/share/gnome-background-properties/mybackgrounds.xml /usr/share/gnome-background-properties/mybackgrounds.xml
					rm mybackgrounds.xml
					rm lspictures.txt
					gsettings set org.gnome.desktop.background picture-uri file:///opt/rtd/Wallpaper/Wayland.jpg

				# Configure Gnome settings for users.
					gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
				;;
							

		esac
	done





#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::          Finalize.....                   ::::::::::::::::::::::
#::::::::::::::                                          ::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
#

# Clean up and Finalize
echo -e $YELLOW"--- Remove any unused applications and esure all the latest updates are installed lastly..." $ENDCOLOR
	up2date



check_dependencies zenity
zenity --notification --window-icon=update.png --text "System update is complete! You may restart your system and start using it now"
zenity  --question --title "Alert" --width=400 --height=400  --text "System update is complete! You may restart your system and start using it now! Would you like to RESTART NOW?"
if [ $? = 0 ];
      then
          echo "OK Rebooting."
	  reboot
fi

















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













