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
            for i in rtd-oem-linux-config.sh _rtd_functions
            do
                rm -f "/opt/rtd/scripts/$1"
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
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO Welcome to %COMSPEC%
ECHO This is a windows script!

:GetInterestingThigsToDoOnThisSystem
:: Use power shell to grab the nest staage of his script from a common server...
@echo off
ver | find "5.1" > nul && ( set OSV=XP&  call :DispErr Windows XP is regretably not supported & goto end )
ver | find "6.0" > nul && ( set OSV=vista&  call :DispErr Vista is not supported & goto end )
ver | find "6.1" > nul && ( set OSV=win7&  call :PS1 )
ver | find "6.2" > nul && ( set OSV=win8&  call :PS2 )
ver | find "6.3" > nul && ( set OSV=win8&  call :PS2 )
ver | find "6.3" > nul && ( set OSV=win8&  call :PS2 )
ver | find "10.0" > nul && ( set OSV=win10&  call :PS2 )


:PS1
:: get stage 2 and run it...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/vonschutter/RTD-Build/raw/master/rtd-oem-windows-config.cmd', 'rtd-oem-windows-config.cmd')"


:PS2
:: get stage 2 and run it...
powershell -Command "Invoke-WebRequest https://github.com/vonschutter/RTD-Build/raw/master/rtd-oem-windows-config.cmd -OutFile rtd-oem-windows-config.cmd"



:ExtractAndRunStage2
:: Extract the stage 2 och RTD OEM configuration
::
::

rtd-oem-windows-config.cmd


:goto end


:DispErr
	set _ERRMSG=%*
	@title %0 -- !!%_ERRMSG%!!
	echo ���������������������������������������������������������������������������ͻ
	echo �                            Message                                        �
	echo ���������������������������������������������������������������������������ͼ
	echo.
	echo.
	echo        %_ERRMSG%
	echo        Presently I know what to do for Linux, and Windows 7 and beyond...
	echo.
	echo �                                                                           �
	echo ���������������������������������������������������������������������������ͼ
goto eof



:end
:eof
