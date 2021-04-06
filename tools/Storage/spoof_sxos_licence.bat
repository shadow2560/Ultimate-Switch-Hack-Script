::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
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
echo.
set boot_file=
call "%associed_language_script%" "boot_file_selection"
set /p boot_file_path=<templogs\tempvar.txt
IF "%boot_file_path%"=="" (
	call "%associed_language_script%" "no_boot_file_selected_error"
	pause
	goto:end_script
)
:set_fingerprint
echo.
set fingerprint=
call "%associed_language_script%" "fingerprint_set"
IF "%fingerprint%"=="0" goto:end_script
IF "%fingerprint%"=="" goto:licence_creation
call TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat fingerprint
call TOOLS\Storage\functions\strlen.bat nb "%fingerprint%"
IF NOT "%nb%"=="32" (
	call "%associed_language_script%" "fingerprint_error_number_chars"
	pause
	goto:set_fingerprint
)
set i=0
:check_chars_fingerprint
IF %i% LEQ 31 (
	set check_chars_fingerprint=0
	FOR %%z in (A B C D E F 0 1 2 3 4 5 6 7 8 9) do (
		IF "!fingerprint:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_fingerprint=1
			goto:check_chars_fingerprint
		)
	)
	IF "!check_chars_fingerprint!"=="0" (
		call "%associed_language_script%" "fingerprint_error_char_not_authorized"
		pause
		goto:set_fingerprint
	)
)
:licence_creation
IF "%fingerprint%"=="" (
	tools\python3_scripts\TX_SX_spoof_ID_unpacker\TX_SX_spoof_ID_unpacker.exe -i "!boot_file_path:\=\\!" >nul 2>&1
) else (
	tools\python3_scripts\TX_SX_spoof_ID_unpacker\TX_SX_spoof_ID_unpacker.exe -i "!boot_file_path:\=\\!" -f "!fingerprint!" >nul 2>&1
)
IF !errorlevel! EQU 0 (
	IF "%fingerprint%"=="" (
		call :move_preconfig_sxos_license "%boot_file_path%"
	)
	call "%associed_language_script%" "boot_creation_success"
	pause
) else (
	call "%associed_language_script%" "boot_creation_error"
	pause
)
goto:end_script

:move_preconfig_sxos_license
IF EXIST "license.dat" (
	move "license.dat" "%~dp1" >nul
)
exit /b

:end_script
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal