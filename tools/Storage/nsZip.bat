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
call "%associed_language_script%" "input_file_choice"
set /p game_path=<templogs\tempvar.txt
IF "%game_path%"=="" (
	call "%associed_language_script%" "no_input_file_selected_error"
	goto:end_script
)
call "%associed_language_script%" "output_folder_choice"
set /p output_path=<templogs\tempvar.txt
IF NOT "%output_path%"=="" (
	set output_path=%output_path:\\=\%
) else (
	call "%associed_language_script%" "no_output_folder_selected_error"
	goto:end_script
)
IF /i "%game_path:~-4%"=="nspz" goto:skip_set_params
IF /i "%game_path:~-4%"=="xciz" goto:skip_set_params
:set_compression_level
set compression_level=
call "%associed_language_script%" "compression_level_choice"
IF "%compression_level%"=="" (
	call "%associed_language_script%" "no_empty_value_error"
	goto:set_compression_level
)
call TOOLS\Storage\functions\strlen.bat nb "%compression_level%"
set i=0
:check_chars_compression_level
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!compression_level:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_compression_level
		)
	)
	IF "!check_chars!"=="0" (
		call "%associed_language_script%" "bad_value_error"
		goto:set_compression_level
	)
)
IF %compression_level% LSS 1 (
	call "%associed_language_script%" "compression_level_too_low_error"
	goto:set_compression_level
)
IF %compression_level% GTR 22 (
	call "%associed_language_script%" "compression_level_too_high_error"
	goto:set_compression_level
)
set params=-l %compression_level%
:skip_set_params
"tools\nsZip\nsZip.exe" -i "%game_path:\=\\%" -o "%output_path:\=\\%" -t "templogs" %params%
IF %errorlevel% NEQ 0 (
	echo.
	call "%associed_language_script%" "operation_error"
) else (
	echo.
	call "%associed_language_script%" "operation_success"
)
:end_script
pause
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal