#!/bin/bash
cls
:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

echo     		-        RTD System System Managment Bootstrap Script      -
#::
#::
#:: Windows CMD Shell Script Section
#::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#:: Author:   	SLS. & Nate B. Buffalo Center, IA
#:: Version:	1.06
#::
#::
#:: Purpose: 	The purpose of the script is to decide what scripts to download based
#::          	on the host OS found; works with both Windows, MAC and Linux systems.
#::		The focus of this script is to be compatible enough that it could be run on any
#::		system and compete it's job. In this case it is simply to identify the OS
#::		and get the appropriate script files to run on the system in question;
#::		In its original configuration this bootstrap script was used to install and
#::		configure software appropriate for the system in question. It accomplishes this
#::		by using the idiosyncrasies of the default scripting languages found in
#::		the most popular operating systems around *NIX (MAC, Linux, BSD etc.) and
#::		CMD (Windows NT, 2000, 2003, XP, Vista, 8, and 10.
#::
#::
#:: Background: This system configuration and installation script was originally developed
#:: 		for RuntimeData, a small OEM in Buffalo Center, IA. The purpose of the script
#:: 		was to install and/or configure Ubuntu, Zorin, or Microsoft OS PC's. This OEM and store nolonger
#:: 		exists as its owner has passed away. This script is shared in the hopes that
#:: 		someone will find it usefull.
#::
#::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Save the UI currently in use...
echo "$XDG_CURRENT_DESKTOP">$HOME/.ui

# Ensure administrative privileges.
[ "$UID" -eq 0 ] || echo -e $YELLOW "This script needs administrative access..." $ENDCOLOR
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

# Pull in current desktop... 
_UI=$( cat /home/$SUDO_USER/.ui )

# Base folder structure for optional administrative commandlets and scripts:
_RTDSCR=$(if [ -f /opt/rtd/scripts ]; then echo /opt/rtd/scripts ; else ( mkdir -p /opt/rtd/scripts & echo  /opt/rtd/scripts ) ; fi )
_RTDCACHE=$(if [ -f /opt/rtd/cache ]; then echo /opt/rtd/cache ; else ( mkdir -p /opt/rtd/cache & echo  /opt/rtd/cache ) ; fi )
_RTDLOGSD=$(if [ -f /opt/rtd/log ]; then echo /opt/rtd/log ; else ( mkdir -p /opt/rtd/log & echo  /opt/rtd/log ) ; fi )

# Location of base administrative scripts and commandlets to get.
_RTDSRC=https://github.com/vonschutter/RTD-Build/archive/master.zip

# Determine log file directory
_ERRLOGFILE=$_RTDLOGSD/$0-error.log
_LOGFILE=$_RTDLOGSD/$0.log 



clear
echo "This is now a ${SHELL} environment..."
echo "Session found: You seem to be using ${_UI:-"something I can't see"} as your graphical environment."
echo "User name: $SUDO_USER started this script." 
echo "Attempting to detect version of POSIX based system..."


if [[ "$OSTYPE" == "linux-gnu" ]]; then
	echo "Linux OS Found: Attempting to get instructions for Linux..."
	echo "Please NOTE that most Lnux versions work, but not all."
	echo "Task to complete: Download the set of instructions required and"
	echo "extract them in to the $_RTDSCR location. Then execute the intructions"
	echo "to complete the configuration of the system."
	for i in apt yum dnf zypper ; do $i -y install wget > /dev/null 2>&1 ; done
	wget -q  $_RTDSRC -P $_RTDCACHE 
	for i in apt yum dnf zypper ; do $i -y install unzip > /dev/null 2>&1 ; done
	unzip -o -j $_RTDCACHE/master.zip -d $_RTDSCR  -x *.png *.md *.yml *.cmd > /dev/null 2>&1 && rm -v $_RTDCACHE/master.zip
		if [ $? -eq 0 ]
		then
			echo "Instructions sucessfully retrieved..."
			chmod +x $_RTDSCR/*
			pushd /bin
			ln -f -s $_RTDSCR/rtd* .
			popd
			bash $_RTDSCR/rtd-oem-linux-config.sh "$@"
		else
			echo "Failed to retrieve instructions correctly! " 
			echo "Suggestion: check write permission in "/opt" or internet connectivity."
			exit 1
		fi
        exit $?
elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Mac OSX is currently not supported..."
elif [[ "$OSTYPE" == "cygwin" ]]; then
        echo "CYGWIN is currently unsupported..."
elif [[ "$OSTYPE" == "msys" ]]; then
        echo "Lightweight shell is currently unsupported... "
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        echo "Free BSD is currently unsupported... "
else
       echo "This system is Unknown to this script"
fi
exit $?




# -----------------------------------------------------------------------------------------------------------------------
# Anything after this exit statment below will be dangerous and meaningless
# command syntax to POSIX based systems...
# Make sure to exit no matter what...
exit $?
:CMDSCRIPT
@echo off
echo     		-        RTD System System Managment Bootstrap Script      -
::
::
:: Windows CMD Shell Script Section
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Variables and Assignments
:: Passed From CONSOLE!
::		%0 		-> %Scriptname%
:: 		Common TS
::		%DEBUG% 	-> 1 value to turn on tracing
::		%ECHO% 		-> On Value to turn on echo
::		%RET% 		-> Argument Passing Value
::
:: 	Please list command files to be run here in the following format:
::
:: 	:TITLE
:: 	Description of the pupose of called command file.
:: 	call <path>\command.cmd or command...
::
::
:: The preferred method of coding well is per the Tim Hill Windows NT Shell Scripting book, ISBN: 1-57878-047-7
:: This is to ensure a secure and controlled way to execute components in the script. This may be an old way
:: but it is relible and it works in all versions of Windows starting with Windows NT. However, newer more poserfull
:: scripting languages are available. These should be used where appropriate in the stage 2 of this process.
:: This bootstrap sctipt is intended for compatibility and this section therefore focuses on Windows CMD as this
:: works in all earlite 32 and 64 bit versions of Windows.
::
:: Example 1
::
:: for %%d in (%_dependencies%) do (call :VfyPath %%d)
::	if not {%RET%}=={0} (set _ERRMSG="An unrecoverable error has occured..." & call :DispErr !
::			) else (
::			goto MAIN)
:: endlocal & goto eof
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:INIT
	:::::::::::::::::::::::::::::::::::::::::::::::::::
	::	Script startup components; tasks that always
	::	need to be done when the initializes.
	::
        ECHO Welcome to %COMSPEC%
        ECHO This is a windows script!
	:: setlocal &  pushd %~dp0
	:: %debug%

:SETINGS
	::::::::::::::::::::::::::::::::::::::::::::::::::::::
	::  ***             Settings               ***      ::
	::::::::::::::::::::::::::::::::::::::::::::::::::::::
	::
	set temp=c:\rtd\temp
        ::if not exit %temp% md %temp%
        ::set _LOGDIR=c:\rtd\log
        ::if not exist %_LOGDIR% md %_OGDIR%
        set _STAGE2LOC=https://github.com/vonschutter/RTD-Build/raw/master
        set _STAGE2FILE=rtd-oem-windows-config.cmd
	echo Staget 2 file is located at:
        echo %_STAGE2LOC%\%_STAGE2FILE%


:GetInterestingThigsToDoOnThisSystem
        :: Given that Microsoft Windows has been detected and the CMD chell portion of this script is executed,
        :: the second stage script must be downloaded from an online location. Depending on the version of windows
        :: there are different methods available to get and run remote files. All versions of windows do not neccesarily
        :: support powershell scripting. Therefore the base of this activity is coded in simple command CMD.EXE shell scripting
        ::
        :: Table of evaluating verson of windos and calling the appropriate action fiven the version of windows found.
        :: In this case it is easier to manage a straight table than a for loop or array:

	:: DOS Based versions of Windows:
        :: ver | find "4.0" > nul && goto CMD1 	rem Windows 95
        :: ver | find "4.10" > nul && goto CMD1 rem Windows 98
        :: ver | find "4.90" > nul && goto CMD1	rem Windows ME

	:: Windows 32 and 64 Bit versions:
	ver | find "NT 4.0" > nul && call :CMD1 Windows NT 4.0
	ver | find "5.0" > nul && call :CMD1 Windows 2000
        ver | find "5.1" > nul && call :CMD1 Windows XP
	ver | find "5.2" > nul && call :CMD1 Windows XP 64 Bit
        ver | find "6.0" > nul && call :DispErr Vista is not supported!!!
        ver | find "6.1" > nul && call :PS1 Windows 7
        ver | find "6.2" > nul && call :PS2 Windows 8
        ver | find "6.3" > nul && call :PS2 Windows 8
        ver | find "6.3" > nul && call :PS2 Windows 8
        ver | find "10.0" > nul && call :PS2 Windows 10

	:: Windows Server OS Versions:
	ver | find "NT 6.2" > nul && call :PS2 Windows Server 2012
	ver | find "NT 6.3" > nul && call :PS2 Windows Server 2012 R2
	ver | find "NT 10.0" > nul && call :PS2 Windows Server 2016 and up...

        goto end


:PS1
        :: Procedure to get the second stage in Windows 7. Windows 7, by default has a different version of
	:: PowerShell installed. Therefore a slightly different syntax must be used.
	:: get stage 2 and run it...
	echo Found %*
	echo Fetching %_STAGE2FILE%...
	echo Please wait...
        powershell -Command "(New-Object Net.WebClient).DownloadFile('%_STAGE2LOC%\%_STAGE2FILE%', '%_STAGE2FILE%')"
		if "ERRORLEVEL"=="0" (echo Sucessfully fetched stage 2...) else (echo Faile to get stage 2!...)
		rtd-oem-windows-config.cmd
        goto end


:PS2
	:: Precedure to get the second stage configuration script in all version of windows after 7.
	:: These version of windows hae a more modern version of PowerShell.
        :: get stage 2 and run it...
	echo Found %*
	echo Fetching %_STAGE2FILE%...
	echo Please wait...
        powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;Invoke-WebRequest %_STAGE2LOC%\%_STAGE2FILE% -OutFile %_STAGE2FILE%"
		if "ERRORLEVEL"=="0" (echo Sucessfully fetched stage 2...) else (echo Faile to get stage 2!...)
		rtd-oem-windows-config.cmd
        goto end




:CMD1
        :: Pre windows 7 instruction go here (except vista)...
	:: Windows NT, XP, and 2000 etc. do not have powershell and must find a different way to
	:: fetch a script over the internet and execute it.

	echo Detected %* ...
	echo executing PRE Windows 7 instructions...

        goto end




::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::                                          ::::::::::::::::::::::
::::::::::::::            ERROR handling Below          ::::::::::::::::::::::
::::::::::::::                                          ::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:DispErr
	set _ERRMSG=%*
	@title %0 -- !!%_ERRMSG%!!
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	echo ::                            Message                                          ::
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	echo.
	echo.
	echo        %_ERRMSG%
	echo        Presently I know what to do for Linux, and Windows 7 and beyond...
	echo.
	echo ::                                                                             ::
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
goto eof



:end
:eof
