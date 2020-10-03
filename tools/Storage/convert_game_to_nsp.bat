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
cd TOOLS\Hactool_based_programs
IF EXIST keys.txt (
	set define_new_keys_file=
	call "%associed_language_script%" "define_new_keys_file_choice"
	IF NOT "!define_new_keys_file!"=="" set define_new_keys_file=!define_new_keys_file:~0,1!
	call "..\Storage\functions\modify_yes_no_always_never_vars.bat" "define_new_keys_file" "o/n_choice"
	IF /i "!define_new_keys_file!"=="o" goto:keys_file_creation
)
IF NOT EXIST keys.txt (
	IF EXIST keys.dat (
		copy keys.dat keys.txt
		goto:skip_keys_file_creation
	)
	call "%associed_language_script%" "keys_file_not_finded"
	goto:keys_file_creation
) else (
	goto:skip_keys_file_creation
)
:keys_file_creation
echo.
call "%associed_language_script%" "keys_file_selection"
	set /p keys_file_path=<"..\..\templogs\tempvar.txt"
	IF "%keys_file_path%"=="" (
	call "%associed_language_script%" "no_keys_file_selected_error"
	goto:end_script
	)
	
	copy "%keys_file_path%" keys.txt
	
:skip_keys_file_creation
echo.
call "%associed_language_script%" "xci_file_selection"
set /p game_path=<..\..\templogs\tempvar.txt
IF "%game_path%"=="" (
	call "%associed_language_script%" "no_game_selected_error"
	goto:end_script
)
call "%associed_language_script%" "output_folder_select"
set /p output_path=<..\..\templogs\tempvar.txt
IF "%output_path%"=="" (
	call "%associed_language_script%" "no_output_folder_error"
	goto:end_script
) else (
	set output_path=!output_path!\
	set output_path=!output_path:\\=\!
	IF "!output_path:~-1,1!"=="\" set output_path=!output_path:~0,-1!
)
set rename_target=
call "%associed_language_script%" "rename_param_choice"
IF NOT "%rename_target%"=="" set rename_target=%rename_target:~0,1%
call "..\Storage\functions\modify_yes_no_always_never_vars.bat" "rename_target" "o/n_choice"
IF /i NOT "%rename_target%"=="o" set params=--rename 
set keepncaid=
call "%associed_language_script%" "kipncaid_param_choice"
IF NOT "%keepncaid%"=="" set keepncaid=%keepncaid:~0,1%
call "..\Storage\functions\modify_yes_no_always_never_vars.bat" "keepncaid" "o/n_choice"
IF /i NOT "%keepncaid%"=="o" set params=--keepncaid 
IF EXIST "4nxci_extracted_xci" rmdir /s /q "4nxci_extracted_xci"
"4nxci.exe" --keyset "keys.txt" %params% -t "..\..\templogs" -o "%output_path%" "%game_path%"
IF EXIST "4nxci_extracted_xci" rmdir /s /q "4nxci_extracted_xci"
IF %errorlevel% NEQ 0 (
	echo.
	call "%associed_language_script%" "converting_error"
) else (
	echo.
	call "%associed_language_script%" "converting_success"
)
:end_script
pause
cd ..\..
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal