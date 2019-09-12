:: --    --
:: 					Windows CMD Shell Script 
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

:SETINGS
	::::::::::::::::::::::::::::::::::::::::::::::::::::::
	::  ***             Settings               ***      ::
	::::::::::::::::::::::::::::::::::::::::::::::::::::::
	::

        set _STAGE2LOC=https://github.com/vonschutter/RTD-Media/raw/master/Apps
        set _STAGE2FILE=InstallerHook.exe

	::::::::::::::::::::::::::::::::::::::::::::::::::::::
	::  ***             Executive              ***      ::
	::::::::::::::::::::::::::::::::::::::::::::::::::::::
	::
@echo Configuring windows with the RTD cusomizations...
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;Invoke-WebRequest %_STAGE2LOC%\%_STAGE2FILE% -OutFile %_STAGE2FILE%"
    %_STAGE2FILE%

	::::::::::::::::::::::::::::::::::::::::::::::::::::::
	::  ***             Finish                 ***      ::
	::::::::::::::::::::::::::::::::::::::::::::::::::::::
	::
echo Tasks completed...
