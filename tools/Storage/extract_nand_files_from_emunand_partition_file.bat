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
:folders_choice
echo.
call "%associed_language_script%" "input_file_choice"
set /p dump_input=<templogs\tempvar.txt
IF "%dump_input%"=="" (
	call "%associed_language_script%" "no_input_file_error"
	goto:end_script
)
:output_select
echo.
call "%associed_language_script%" "output_folder_choice"
set /p dump_output=<"templogs\tempvar.txt"
IF "%dump_output%"=="" (
	call "%associed_language_script%" "no_output_folder_error"
	goto:end_script
)
set dump_output=%dump_output:\\=\%
:verif_existing_file
IF EXIST "%dump_output%\BOOT0" (
	call "%associed_language_script%" "erase_boot0_choice"
)
IF NOT "%erase_existing_dump_boot0%"=="" set erase_existing_dump_boot0=%erase_existing_dump_boot0:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "erase_existing_dump_boot0" "o/n_choice"
IF EXIST "%dump_output%\BOOT0" (
	IF /i "%erase_existing_dump_boot0%"=="o" (
		del /q "%dump_output%\BOOT0"
	) else (
		call "%associed_language_script%" "canceled"
		goto:end_script
	)
)
IF EXIST "%dump_output%\BOOT1" (
	call "%associed_language_script%" "erase_boot1_choice"
)
IF NOT "%erase_existing_dump_boot1%"=="" set erase_existing_dump_boot1=%erase_existing_dump_boot1:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "erase_existing_dump_boot1" "o/n_choice"
IF EXIST "%dump_output%\BOOT1" (
	IF /i "%erase_existing_dump_boot1%"=="o" (
		del /q "%dump_output%\BOOT1"
		goto:verif_disk_free_space
	) else (
		call "%associed_language_script%" "canceled"
		goto:end_script
	)
)
IF EXIST "%dump_output%\rawnand.bin" (
	call "%associed_language_script%" "erase_rawnand_choice"
)
IF NOT "%erase_existing_dump_rawnand%"=="" set erase_existing_dump_rawnand=%erase_existing_dump_rawnand:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "erase_existing_dump_rawnand" "o/n_choice"
IF EXIST "%dump_output%\rawnand.bin" (
	IF /i "%erase_existing_dump_rawnand%"=="o" (
		del /q "%dump_output%\rawnand.bin"
		goto:verif_disk_free_space
	) else (
		call "%associed_language_script%" "canceled"
		goto:end_script
	)
)
call :test_sxos_special_first_bytes "%dump_input%"
IF %errorlevel% EQU 500 goto:end_script
:verif_disk_free_space
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\get_free_space_for_path.vbs" "%dump_output%"
set /p free_space=<templogs\volume_free_space.txt
call "tools\Storage\functions\check_disk_free_space.bat" "%free_space%" "31276924928"
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
IF NOT "%sxos_first_1024%"=="Y" (
	"tools\gnuwin32\bin\dd.exe" bs=4096 iflag=count_bytes count=4194304 if="%dump_input%" of="%dump_output%\BOOT0"
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "copying_error"
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		goto:end_script
	)
	"tools\gnuwin32\bin\dd.exe" bs=4096 iflag=count_bytes,skip_bytes skip=4194304 count=4194304 if="%dump_input%" of="%dump_output%\BOOT1"
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "copying_error"
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		goto:end_script
	)
	"tools\gnuwin32\bin\dd.exe" bs=4096 iflag=skip_bytes skip=8388608 if="%dump_input%" of="%dump_output%\rawnand.bin"
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "copying_error"
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		goto:end_script
	)
) else (
	"tools\gnuwin32\bin\dd.exe" bs=4096 iflag=count_bytes,skip_bytes skip=1024 count=4194304 if="%dump_input%" of="%dump_output%\BOOT0"
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "copying_error"
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		goto:end_script
	)
	"tools\gnuwin32\bin\dd.exe" bs=4096 iflag=count_bytes,skip_bytes skip=4195328 count=4194304 if="%dump_input%" of="%dump_output%\BOOT1"
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "copying_error"
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		goto:end_script
	)
	"tools\gnuwin32\bin\dd.exe" bs=4096 iflag=skip_bytes skip=8389632 if="%dump_input%" of="%dump_output%\rawnand.bin"
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "copying_error"
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		goto:end_script
	)
)
call :test_rawnand_size "%dump_output%\BOOT0"
call :test_rawnand_size "%dump_output%\BOOT1"
call :test_rawnand_size "%dump_output%\rawnand.bin"
IF "%copy_error_boot0%"=="Y" call "%associed_language_script%" "copying_boot0_error"
IF "%copy_error_boot1%"=="Y" call "%associed_language_script%" "copying_boot1_error"
IF "%copy_error_rawnand%"=="Y" call "%associed_language_script%" "copying_rawnand_error"
call "%associed_language_script%" "copying_success"
echo.
IF NOT "%copy_error_rawnand%"=="Y" call "%associed_language_script%" "launch_hacdiskmount_choice"
IF NOT "%launch_hacdiskmount%"=="" set launch_hacdiskmount=%launch_hacdiskmount:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "launch_hacdiskmount" "o/n_choice"
IF /i "%launch_hacdiskmount%"=="o" (
	start tools\HacDiskMount\HacDiskMount.exe
)
goto:end_script

:test_rawnand_size
IF "%~nx1"=="rawnand.bin" (
	IF NOT "%~z1"=="31268536320" (
		call "%associed_language_script%" "output_rawnand_size_error"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		set copy_error_rawnand=Y
	)
) else IF "%~nx1"=="BOOT0" (
IF NOT "%~z1"=="4194304" (
		call "%associed_language_script%" "output_boot0_size_error"
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		set copy_error_boot0=Y
	)
) else IF "%~nx1"=="BOOT1" (
IF NOT "%~z1"=="4194304" (
		call "%associed_language_script%" "output_boot1_size_error"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		set copy_error_boot1=Y
	)
)
exit /B

:test_sxos_special_first_bytes
IF "%~z1"=="31276924928" (
	set sxos_first_1024=N
) else IF "%~z1"=="31276925952" (
	set sxos_first_1024=Y
) else (
	call "%associed_language_script%" "input_dump_invalid_error"
	exit /b 500
)
exit /b

:end_script
pause
:end_script_2
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal