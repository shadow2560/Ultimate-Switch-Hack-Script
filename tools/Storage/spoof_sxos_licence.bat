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
:define_action_choice
set action_choice=
call "%associed_language_script%" "action_choice"
IF "%action_choice%"=="1" (
	goto:licence_creation
)
IF "%action_choice%"=="2" (
	goto:license_request_select
)
IF "%action_choice%"=="3" (
	goto:set_fingerprint
)
goto:end_script

:license_request_select
set license_request_file_path=
call "%associed_language_script%" "license_request_file_path_selection"
set /p license_request_file_path=<templogs\tempvar.txt
IF "%license_request_file_path%"=="" (
	call "%associed_language_script%" "no_license_request_file_path_file_selected_error"
	pause
	goto:end_script
)
goto:licence_creation
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
set outdir_path=
call "%associed_language_script%" "outdir_folder_select"
set /p outdir_path=<"templogs\tempvar.txt"
IF "%outdir_path%"=="" (
	call "%associed_language_script%" "no_outdir_source_selected_error"
	goto:end_script
)
set outdir_path=%outdir_path%\
set outdir_path=%outdir_path:\\=\%

IF "%action_choice%"=="1" (
	tools\python3_scripts\TX_SX_spoof_ID_unpacker\TX_SX_spoof_ID_unpacker.exe  -o "%outdir_path:\=\\%">nul 2>&1
) else IF "%action_choice%"=="2" (
	tools\python3_scripts\TX_SX_spoof_ID_unpacker\TX_SX_spoof_ID_unpacker.exe  -l "%license_request_file_path%:\=\\" -o "%outdir_path:\=\\%">nul 2>&1
) else IF "%action_choice%"=="3" (
	IF "%fingerprint%"=="" (
		tools\python3_scripts\TX_SX_spoof_ID_unpacker\TX_SX_spoof_ID_unpacker.exe  -o "%outdir_path:\=\\%">nul 2>&1
	) else (
		tools\python3_scripts\TX_SX_spoof_ID_unpacker\TX_SX_spoof_ID_unpacker.exe -f "%fingerprint%" -o "%outdir_path:\=\\%">nul 2>&1
	)
)
IF %errorlevel% EQU 0 (
	call "%associed_language_script%" "boot_creation_success"
	pause
) else (
	call "%associed_language_script%" "boot_creation_error"
	pause
)
goto:end_script

:end_script
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal