::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set folders_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/trunk
set files_url_project_base=https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
IF NOT EXIST "%associed_language_script%" (
	set associed_language_script=languages\FR_fr\!this_script_full_path:%ushs_base_path%=!
	set associed_language_script=%ushs_base_path%!associed_language_script!
	echo The associated language file cannot be found, please run the updater to download it. French will be set as default.
	pause
)
IF NOT EXIST "%associed_language_script%" (
	echo Language error. Please use the update manager to update the script. This script will now close.
	pause
	endlocal
	goto:eof
)
IF EXIST "%~0.version" (
	set /p this_script_version=<"%~0.version"
) else (
	set this_script_version=1.00.00
)
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
:begin_script
echo.
call "%associed_language_script%" "begin_update_database"
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	IF NOT EXIST "tools\python3_scripts\ssnc\serials.json" (
		call "%associed_language_script%" "no_database_and_no_internet_connection_error"
		goto:end_script
	)
	call "%associed_language_script%" "no_internet_connection_info"
) else (
	echo.
	set database_choice=
	call "%associed_language_script%" "database_choice"
	IF "!database_choice!"=="1" (
		"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "tools\python3_scripts\ssnc" -o "serials.json" "%files_url_project_base%/tools/python3_scripts/ssnc/serials.json.safe"
	) else IF "!database_choice!"=="2" (
		"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "tools\python3_scripts\ssnc" -o "serials.json" "%files_url_project_base%/tools/python3_scripts/ssnc/serials.json.beta"
	) else IF "!database_choice!"=="0" (
		goto:finish_script
	) else (
		goto:skip_update
	)
	call "%associed_language_script%" "update_database_success"
)
:skip_update
cd tools\python3_scripts\ssnc
:enter_serial
set console_serial=
call "%associed_language_script%" "serial_choice"
IF "%console_serial%"=="" (
	call "%associed_language_script%" "serial_empty_error"
	goto:enter_serial
)
IF "%console_serial%"=="0" goto:end_script
IF "%console_serial%"=="1" (
	start explorer.exe "http://www.logic-sunrise.com/forums/topic/84485-base-de-donees-des-numeros-de-serie-de-consoles-patchees-ou-non/"
	goto:enter_serial
)
IF "%console_serial%"=="2" (
	cd ..\..\..
	goto:begin_script
)
.\ssnc.exe %console_serial% >..\..\..\templogs\tempvar.txt
set /p console_status=<..\..\..\templogs\tempvar.txt
IF /i "%console_status%"=="patched" (
	echo.
	call "%associed_language_script%" "serial_patched"
	echo.
	goto:enter_serial
)
IF /i "%console_status%"=="warning" (
	echo.
	call "%associed_language_script%" "serial_warning"
	echo.
	goto:enter_serial
)
IF /i "%console_status%"=="safe" (
	echo.
	call "%associed_language_script%" "serial_safe"
	echo.
	goto:enter_serial
)
IF /i "%console_status%"=="incorrect" (
	echo.
	call "%associed_language_script%" "serial_bad_value"
	echo.
	goto:enter_serial
)
call "%associed_language_script%" "serial_error"
goto:enter_serial
:end_script
cd ..\..\..
:finish_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal