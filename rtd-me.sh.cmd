#!/bin/bash
cls
:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL
#::             RTD System System Managment Bootstrap Script
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#:: Author:   	Stephan S. & Nate B. Buffalo Center, IA
#:: Version 1.00
#::
#::
#:: Purpose: The purpose of the script is to decide what scripts to dowload based 
#::          on the host OS found, works with both Windows, MAC  and Linux systems. 
#::
#::
#:: This system configuration and installation script was originally developed
#:: for RuntimeData, a small OEM in Buffalo Center, IA. The purpose of the script
#:: was to install and/or configure Ubuntu, Zorin, or Microsoft OS PC's. This OEM and store nolonger
#:: exists as its owner has passed away. This script is shared in the hopes that
#:: someone will find it usefull.
#::
#::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Ensure administrative privileges.
[ "$UID" -eq 0 ] || echo -e $YELLOW "This script needs administrative access..." $ENDCOLOR
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

clear
echo "This is now a ${SHELL} environment..."
echo "Attempting to detect version of POSIX based system..."

if [[ "$OSTYPE" == "linux-gnu" ]]; then
        echo "Linux OS: Attempting to get instructions..."
          mkdir -p /opt/rtd/scripts
            for i in rtd-oem-linux-config.sh _rtd_functions rtd-update-ubuntu 
            do
                # if the file to be downloaded already exists delete the exisitng one first... 
                if [ -f "/opt/rtd/scripts/$1" ]; then
                    rm -f "/opt/rtd/scripts/$1"
                fi
                # Then get the file requested...
                wget -q --show-progress https://github.com/vonschutter/RTD-Build/raw/master/"$i" -P /opt/rtd/scripts && chmod +x /opt/rtd/scripts/"$i"
            done
        /opt/rtd/scripts/rtd-oem-linux-config.sh
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





# Anything after this exit statment below will be dangerous and meaningless
# command syntax to POSIX based systems...
# Make sure to exit no matter what...
exit $?
:CMDSCRIPT
@echo off
:: --    --
:: Windows CMD Shell Script Section
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Variables and Assignments
:: Passed From CONSOLE!
::		%0 		-> %Scriptname%
:: Common TS
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
        if not exits %temp% md %temp%
        set _LOGDIR=c:\rtd\log
        if not exists %_LOGDIR% md %_OGDIR%
        set _STAGE2LOC=https://github.com/vonschutter/RTD-Build/raw/master
        set _STAGE2FILE=rtd-oem-windows-config.cmd
        echo %_STAGE2LOC%\%_STAGE2FILE%


:GetInterestingThigsToDoOnThisSystem
        :: Given that Microsoft windows hat been detected and the CMD chell portion of this script is executed,
        :: the second stage script must be downloaded from an online location. Depending on the version of windows 
        :: there are different methods available to get and run remote files. All versions of windows do not neccesarily 
        :: support powershell scripting. Therefore the base of this activity is coded in simple command CMD.EXE shell scripting
        :: 
        :: Table of evaluating verson of windos and calling the appropriate action fiven the version of windows found. 
        :: In this case it is easier to manage a straight table than a for loop or array: 

        ver | find "5.1" > nul && ( set OSV=XP&  call :CMD1 )
        ver | find "6.0" > nul && ( set OSV=vista&  call :DispErr Vista is not supported & goto end )
        ver | find "6.1" > nul && ( set OSV=win7&  call :PS1 )
        ver | find "6.2" > nul && ( set OSV=win8&  call :PS2 )
        ver | find "6.3" > nul && ( set OSV=win8&  call :PS2 )
        ver | find "6.3" > nul && ( set OSV=win8&  call :PS2 )
        ver | find "10.0" > nul && ( set OSV=win10&  call :PS2 )
        goto end


:PS1
        :: get stage 2 and run it...
        powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/vonschutter/RTD-Build/raw/master/rtd-oem-windows-config.cmd', 'rtd-oem-windows-config.cmd')"
                rtd-oem-windows-config.cmd
        goto end


:PS2
        :: get stage 2 and run it...
        powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;Invoke-WebRequest https://github.com/vonschutter/RTD-Build/raw/master/rtd-oem-windows-config.cmd -OutFile rtd-oem-windows-config.cmd"
                rtd-oem-windows-config.cmd
        goto end


:CMD1
        :: Pre windows 7 instruction go here (except vista)... 
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
