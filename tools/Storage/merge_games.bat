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
set game_type=
call "%associed_language_script%" "game_type_choice"
IF "%game_type%"=="1" goto:input_choice
IF "%game_type%"=="2" goto:input_choice
IF "%game_type%"=="3" goto:input_choice
IF "%game_type%"=="4" goto:input_choice
goto:end_script_2
:input_choice
echo.
call "%associed_language_script%" "game_choice"
set /p dump_input=<"templogs\tempvar.txt"
IF "%dump_input%"=="" (
	call "%associed_language_script%" "no_file_selected_error"
	goto:end_script
)
call :extract_input_filename "%dump_input%"
echo.
call "%associed_language_script%" "output_folder_choice"
set /p dump_output=<"templogs\tempvar.txt"
IF "%dump_output%"=="" (
	call "%associed_language_script%" "no_output_folder_selected_error"
	goto:end_script
)
set dump_output=%dump_output%\
set dump_output=%dump_output:\\=\%
:define_filename
set filename=
call "%associed_language_script%" "output_filename_choice"
IF "%filename%"=="" (
	goto:end_script_2
) else (
	set filename=%filename:"=%
)
call tools\Storage\functions\strlen.bat nb "%filename%"
set i=0
:check_chars_filename
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!filename:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "output_filename_char_error"
			goto:define_filename
		)
	)
	set /a i+=1
	goto:check_chars_filename
)
IF "%game_type%"=="1" (
	IF EXIST "%dump_output%%filename%.nsp" (
		set erase_file=
		call "%associed_language_script%" "output_file_exist_choice"
		IF NOT "!erase_file!"=="" set erase_file=!erase_file:0,1!
		call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "erase_file" "o/n_choice"
		IF /i NOT "!erase_file!"=="o" (
			call "%associed_language_script%" "canceled"
			goto:end_script
		)
	)
) else IF "%game_type%"=="3" (
IF EXIST "%dump_output%%filename%.nsp" (
		set erase_file=
		call "%associed_language_script%" "output_file_exist_choice"
		IF NOT "!erase_file!"=="" set erase_file=!erase_file:0,1!
		IF /i NOT "!erase_file!"=="o" (
			call "%associed_language_script%" "canceled"
			goto:end_script
		)
	)
) else IF "%game_type%"=="2" (
IF EXIST "%dump_output%%filename%.xci" (
		set erase_file=
		call "%associed_language_script%" "output_file_exist_choice"
		IF NOT "!erase_file!"=="" set erase_file=!erase_file:0,1!
		IF /i NOT "!erase_file!"=="o" (
			call "%associed_language_script%" "canceled"
			goto:end_script
		)
	)
) else IF "%game_type%"=="4" (
IF EXIST "%dump_output%%filename%.xci" (
		set erase_file=
		call "%associed_language_script%" "output_file_exist_choice"
		IF NOT "!erase_file!"=="" set erase_file=!erase_file:0,1!
		IF /i NOT "!erase_file!"=="o" (
			call "%associed_language_script%" "canceled"
			goto:end_script
		)
	)
)
set copy_files_param=
set /a temp_count=0
IF "%game_type%"=="1" (
	for %%f in ("%input_dirrectory%\%input_filename%.ns*") do (
		set /a temp_count+=1
	)
	for /l %%i in (0,1,!temp_count!) do (
		IF NOT EXIST "%input_dirrectory%\%input_filename%.ns%%i" (
			call "%associed_language_script%" "input_parts_error"
			goto:end_script
		)
		IF %%i NEQ !temp_count! (
			set copy_files_param=!copy_files_param!^"%input_dirrectory%\%input_filename%.ns%%i^" + 
		) else (
			set copy_files_param=!copy_files_param!^"%input_dirrectory%\%input_filename%.ns%%i^"
		)
	)
) else IF "%game_type%"=="2" (
	for %%f in ("%input_dirrectory%\%input_filename%.xc*") do (
		set /a temp_count+=1
	)
	for /l %%i in (0,1,!temp_count!) do (
		IF NOT EXIST "%input_dirrectory%\%input_filename%.xc%%i" (
			call "%associed_language_script%" "input_parts_error"
			goto:end_script
		)
		IF %%i NEQ !temp_count! (
			set copy_files_param=!copy_files_param!^"%input_dirrectory%\%input_filename%.xc%%i^" + 
		) else (
			set copy_files_param=!copy_files_param!^"%input_dirrectory%\%input_filename%.xc%%i^"
		)
	)
) else (
	for %%f in ("%input_dirrectory%\*.*") do (
		set /a temp_count+=1
	)
	for /l %%i in (0,1,!temp_count!) do (
		IF !temp_count! LEQ 9 (
			IF NOT EXIST "%input_dirrectory%\0%%i" (
				call "%associed_language_script%" "input_parts_error"
				goto:end_script
			)
			IF %%i NEQ !temp_count! (
				set copy_files_param=!copy_files_param!^"%input_dirrectory%\0%%i^" + 
			) else (
				set copy_files_param=!copy_files_param!^"%input_dirrectory%\0%%i^"
			)
		) else (
			IF NOT EXIST "%input_dirrectory%\%%i" (
				call "%associed_language_script%" "input_parts_error"
				goto:end_script
			)
			IF %%i NEQ !temp_count! (
				set copy_files_param=!copy_files_param!^"%input_dirrectory%\%%i^" + 
			) else (
				set copy_files_param=!copy_files_param!^"%input_dirrectory%\%%i^"
			)
		)
	)
)
IF "%game_type%"=="1" (
	copy /v /b %copy_files_param% "%dump_output%%filename%.nsp"
) else IF "%game_type%"=="2" (
	copy /v /b %copy_files_param% "%dump_output%%filename%.xci"
) else IF "%game_type%"=="3" (
	copy /v /b %copy_files_param% "%dump_output%%filename%.nsp"
) else IF "%game_type%"=="4" (
	copy /v /b %copy_files_param% "%dump_output%%filename%.xci"
)
echo.
call "%associed_language_script%" "merge_end"
goto:end_script

:extract_input_filename
set input_filename=%~n1
set input_dirrectory=%~dp1
exit /b

:end_script
pause
:end_script_2
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal