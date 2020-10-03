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
set cfw_used=
call "%associed_language_script%" "cfw_dump_choice"
IF "%cfw_used%"=="1" goto:folders_choice
IF "%cfw_used%"=="2" goto:folders_choice
goto:end_script_2
:folders_choice
echo.
call "%associed_language_script%" "dump_folder_choice"
set /p dump_input=<"templogs\tempvar.txt"
IF "%dump_input%"=="" (
	call "%associed_language_script%" "no_folder_selected_error"
	goto:end_script
)
set dump_input=%dump_input:\\=\%
IF NOT EXIST "%dump_input%\BOOT0" (
	call "%associed_language_script%" "boot0_not_finded_error"
	goto:end_script
)
IF NOT EXIST "%dump_input%\BOOT1" (
	call "%associed_language_script%" "boot1_not_finded_error"
	goto:end_script
)
IF "%cfw_used%"=="1" goto:verif_hekate_dump
IF "%cfw_used%"=="2" goto:verif_sx_dump
:verif_hekate_dump
IF EXIST "%dump_input%\rawnand.bin" (
	set hekate_files_copy_param=BOOT0 + BOOT1 + rawnand.bin
	goto:skip_verif_input
)
set /a dump_parts=0
for %%f in ("%dump_input%\rawnand.bin.*") do (
	set /a dump_parts+=1
)
set /a temp_dump_parts=%dump_parts%-1
set hekate_files_copy_param=BOOT0 + BOOT1 + 
for /l %%i in (0,1,%temp_dump_parts%) do (
	IF %%i LSS 10 (
		IF NOT EXIST "%dump_input%\rawnand.bin.0%%i" (
			set error_input=Y
			goto:skip_verif_input
		) else (
			IF %%i LSS %temp_dump_parts% (
				set hekate_files_copy_param=!hekate_files_copy_param!rawnand.bin.0%%i + 
			) else (
				set hekate_files_copy_param=!hekate_files_copy_param!rawnand.bin.0%%i
			)
		)
	) else (
		IF NOT EXIST "%dump_input%\rawnand.bin.%%i" (
			set error_input=Y
			goto:skip_verif_input
		) else (
			IF %%i LSS %temp_dump_parts% (
				set hekate_files_copy_param=!hekate_files_copy_param!rawnand.bin.%%i + 
			) else (
				set hekate_files_copy_param=!hekate_files_copy_param!rawnand.bin.%%i
			)
		)
	)
)
:skip_verif_input
IF "%error_input%"=="Y" (
	call "%associed_language_script%" "missing_files_in_dump_error"
	goto:end_script
)
goto:output_select
:verif_sx_dump
IF NOT EXIST "%dump_input%\full.00.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.01.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.02.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.03.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.04.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.05.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.06.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.07.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
:skip_verif_input_sx
IF "%error_input%"=="Y" (
	call "%associed_language_script%" "missing_files_in_dump_error"
	goto:end_script
)
goto:output_select
:output_select
echo.
call "%associed_language_script%" "output_folder_choice"
set /p dump_output=<"templogs\tempvar.txt"
IF "%dump_output%"=="" (
	call "%associed_language_script%" "no_output_folder_error"
	goto:end_script
)
set dump_output=%dump_output:\\=\%
echo.
set add_sxos_first_1024=
:verif_existing_file
IF EXIST "%dump_output%\emunand_partition.bin" (
	call "%associed_language_script%" "erase_emunand_file_exist_in_output_folder_choice"
)
IF NOT "%erase_existing_dump%"=="" set erase_existing_dump=%erase_existing_dump:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "erase_existing_dump" "o/n_choice"
IF EXIST "%dump_output%\emunand_partition.bin" (
	IF /i "%erase_existing_dump%"=="o" (
		del /q "%dump_output%\emunand_partition.bin"
		goto:verif_disk_free_space
	) else (
		call "%associed_language_script%" "canceled"
		goto:end_script
	)
)
:verif_disk_free_space
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\get_free_space_for_path.vbs" "%dump_output%"
set /p free_space=<templogs\volume_free_space.txt
call "tools\Storage\functions\check_disk_free_space.bat" "%free_space%" "31276924928"
	IF "!verif_free_space!"=="OK" (
		goto:copy_nand
	) else (
		goto:error_disk_free_space
	)
:error_disk_free_space
echo.
call "%associed_language_script%" "not_enough_disk_free_space_error"
goto:end_script


:copy_nand
echo.
call "%associed_language_script%" "copying_begin"
cd /d "%dump_input%"
IF "%cfw_used%"=="1" (
	copy /b %hekate_files_copy_param% "%dump_output%\emunand_partition.bin"
)
IF "%cfw_used%"=="2" (
	copy /b BOOT0 + BOOT1 + full.00.bin + full.01.bin + full.02.bin + full.03.bin + full.04.bin + full.05.bin + full.06.bin + full.07.bin "%dump_output%\emunand_partition.bin"
)
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "copying_error"
	IF EXIST "%dump_output%\emunand_partition.bin" del /q "%dump_output%\emunand_partition.bin"
	set copy_error=Y
)
call :test_rawnand_size "%dump_output%\emunand_partition.bin"
cd /D "%this_script_dir%\..\.."
IF "%copy_error%"=="Y" goto:end_script
call "%associed_language_script%" "copying_success"
goto:end_script

:test_rawnand_size
IF NOT "%~z1"=="31276924928" (
	call "%associed_language_script%" "output_file_size_error"
	IF EXIST "%dump_output%\emunand_partition.bin" del /q "%dump_output%\emunand_partition.bin"
	set copy_error=Y
)
exit /B

:end_script
pause
:end_script_2
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal