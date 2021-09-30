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
call "%associed_language_script%" "display_title"
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
call "%associed_language_script%" "intro"
pause
echo.
call "%associed_language_script%" "payload_input_file_select_choice"
set /p payload_input_file=<templogs\tempvar.txt
IF "%payload_input_file%"=="" (
	call "%associed_language_script%" "payload_input_file_empty_error"
	goto:endscript
)
echo.
call "%associed_language_script%" "output_folder_choice"
set /p output_folder=<templogs\tempvar.txt
IF "%output_folder%"=="" (
	call "%associed_language_script%" "output_folder_empty_error"
	goto:endscript
)
set output_folder=%output_folder%\
set output_folder=%output_folder:\\=\%
set payload_output_file=boot.dat
IF EXIST "%output_folder%\%payload_output_file%" (
	echo.
	call "%associed_language_script%" "erase_existing_file_choice"
)
IF NOT "%erase_output_file%"=="" set erase_output_file=%erase_output_file:~0,1%
IF /i "%erase_output_file%"=="o" del /q "%output_folder%\%payload_output_file%" >nul
"tools\python3_scripts\custom_boot.dat_maker\custom_boot.dat_maker.exe" -i "%payload_input_file%" -o "%output_folder:~0,-1%">nul
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "create_payload_error"
) else (
	call "%associed_language_script%" "create_payload_success"
)
goto:endscript

:endscript
pause
:endscript2
rmdir /s /q templogs
endlocal