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
set this_script_dir=%~dp0
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
:define_main_action_choice
set action_choice=
call "%associed_language_script%" "main_action_choice"
IF "%action_choice%"=="1" goto:file_unpack_config
IF "%action_choice%"=="2" goto:folder_unpack_config
goto:end_script
:file_unpack_config
set input_file=
call "%associed_language_script%" "input_file_choice"
set /p input_file=<"templogs\tempvar.txt"
IF "%input_file%"=="" (
	call "%associed_language_script%" "no_input_file_error"
	pause
	goto:define_main_action_choice
)
call :output_folder_config
call "%associed_language_script%" "extract_begin"
call :file_unpack "%input_file%"
call "%associed_language_script%" "extract_end"
pause
goto:define_main_action_choice

:folder_unpack_config
set input_folder=
call "%associed_language_script%" "input_folder_choice"
set /p input_folder=<"templogs\tempvar.txt"
IF "%input_folder%"=="" (
	call "%associed_language_script%" "no_input_folder_error"
	pause
	goto:define_main_action_choice
)
set input_folder=%input_folder:\\=\%
call :output_folder_config
call "%associed_language_script%" "extract_begin"
call :folder_unpack
call "%associed_language_script%" "extract_end"
pause
goto:define_main_action_choice

:file_unpack
"tools\Hactool_based_programs\hactoolnet.exe" -t save "%input_file%" --outdir "%output_folder%\%~n1" >nul
exit /b

:folder_unpack
for /r . %%a in (0000000*) do (
	"tools\Hactool_based_programs\hactoolnet.exe" -t save "%input_folder%\%%~na" --outdir "%output_folder%\%%~na" >nul
)
exit /b

:output_folder_config
set output_folder=
call "%associed_language_script%" "output_folder_choice"
set /p output_folder=<"templogs\tempvar.txt"
IF "%output_folder%"=="" (
	call "%associed_language_script%" "no_output_folder_error"
	pause
	goto:define_main_action_choice
)
set output_folder=%output_folder:\\=\%
exit /b

:end_script
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal