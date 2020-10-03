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
:rawnand_choice
echo.
call "%associed_language_script%" "input_rawnand_choice"
set /p dump_input=<"templogs\tempvar.txt"
IF "%dump_input%"=="" (
	call "%associed_language_script%" "no_input_file_selected_error"
	goto:end_script
)
call :get_type_nand "%dump_input%"
IF /i NOT "%nand_type%"=="RAWNAND" (
	call "%associed_language_script%" "invalid_input_file_error"
	goto:end_script
)
set /a chars_filename_count=0
:prepare_extract_filename
set /a chars_filename_count+=1
IF NOT "!dump_input:~-%chars_filename_count%,1!"=="\" (
	goto:prepare_extract_filename
) else (
	goto:skip_prepare_extract_filename
)
:skip_prepare_extract_filename
set /a chars_filename_count-=1
set filename=!dump_input:~-%chars_filename_count%!
:output_select
echo.
call "%associed_language_script%" "output_folder_choice"
set /p dump_output=<"templogs\tempvar.txt"
IF "%dump_output%"=="" (
	call "%associed_language_script%" "no_output_selected_error"
	goto:end_script
)
set dump_output=%dump_output:\\=\%
:define_parts_number
echo.
set parts_number=
call "%associed_language_script%" "parts_number_choice"
IF "%parts_number%"=="" (
	call "%associed_language_script%" "empty_parts_number_error"
	goto:define_parts_number
)
call TOOLS\Storage\functions\strlen.bat nb "%parts_number%"
IF %nb% GTR 2 (
	call "%associed_language_script%" "bad_value_parts_number_error"
	goto:define_parts_number
)
IF "%parts_number:~0,1%"=="0" (
	IF %nb% EQU 2 set parts_number=%parts_number:~1,1%
)
set i=0
:check_chars_parts_number
IF %i% LSS %nb% (
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!parts_number:~%i%,1!"=="%%z" (
			set /a i+=1
			goto:check_chars_parts_number
		)
	)
	call "%associed_language_script%" "parts_number_char_error"
	goto:define_parts_number
)
IF %parts_number% LSS 2 (
	call "%associed_language_script%" "parts_number_too_low_error"
	goto:define_parts_number
)
IF %parts_number% GTR 64 (
	call "%associed_language_script%" "parts_number_too_high_error"
	goto:define_parts_number
)
set /a temp_parts_number=%parts_number%-1
:skip_define_parts_number
echo.
set rename_files=
call "%associed_language_script%" "output_rename_choice"
IF NOT "%rename_files%"=="" set rename_files=%rename_files:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "rename_files" "o/n_choice"
:verif_disk_free_space
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\get_free_space_for_path.vbs" "%dump_output%"
set /p free_space=<templogs\volume_free_space.txt
call "tools\Storage\functions\check_disk_free_space.bat" "%free_space%" "31268536320"
IF "%verif_free_space%"=="OK" (
	goto:copy_nand
) else (
	goto:error_disk_free_space
)
:error_disk_free_space
echo.
call "%associed_language_script%" "not_enough_disk_space_error"
goto:end_script


:copy_nand
echo.
call "%associed_language_script%" "copying_begin"
cd /d "%dump_output%"
"%this_script_dir%\..\gnuwin32\bin\split.exe" -d -n %parts_number% "%dump_input%" %filename%.
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "copying_error"
	set copy_error=Y
)
cd /D "%this_script_dir%\..\.."
IF "%copy_error%"=="Y" goto:end_script
IF /i "%rename_files%"=="o" (
	mkdir "%dump_output%\eMMC"
	for /l %%i in (0,1,%temp_parts_number%) do (
		IF %%i lss 10 (
			move "%dump_output%\%filename%.0%%i" "%dump_output%\eMMC\0%%i"
		) else (
			move "%dump_output%\%filename%.%%i" "%dump_output%\eMMC\%%i"
		)
	)
	attrib +a "%dump_output%\eMMC"
)
call "%associed_language_script%" "copying_end"
goto:end_script

:get_type_nand
set nand_type=
set temp_input_file=%~1
tools\NxNandManager\NxNandManager.exe --info -i "%temp_input_file%" >templogs\infos_nand.txt
set temp_input_file=
tools\gnuwin32\bin\grep.exe "NAND type" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_type=<templogs\tempvar.txt
set nand_type=%nand_type:~1%
exit /B

:end_script
pause
:end_script_2
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal