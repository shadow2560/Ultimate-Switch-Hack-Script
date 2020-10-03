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
call "%associed_language_script%" "boot0_input_file_select_choice"
set /p boot0_input_file=<templogs\tempvar.txt
IF "%boot0_input_file%"=="" (
	call "%associed_language_script%" "boot0_input_file_empty_error"
	goto:endscript
)
call :get_type_nand "%boot0_input_file%"
IF /i NOT "%nand_type%"=="BOOT0" (
	call "%associed_language_script%" "nand_type_must_be_boot0_error"
	goto:endscript
)
IF NOT "%nand_soc_rev%"=="Erista" (
	call "%associed_language_script%" "nand_soc_must_be_erista_error"
	goto:endscript
)

echo.
call "%associed_language_script%" "prod_keys_file_select_choice"
set /p prod_keys_file=<templogs\tempvar.txt
IF "%prod_keys_file%"=="" (
	call "%associed_language_script%" "prod_keys_file_empty_error"
	goto:endscript
)

echo.
call "%associed_language_script%" "output_folder_choice"
set /p output_folder=<templogs\tempvar.txt
IF "%output_folder%"=="" (
	call "%associed_language_script%" "output_folder_empty_error"
	goto:endscript
)
set boot0_output_file=boot0_keyblobs_modified.bin
IF EXIST "%output_folder%\%boot0_output_file%" (
	echo.
	call "%associed_language_script%" "erase_existing_file_choice"
)
IF NOT "%erase_output_file%"=="" set erase_output_file=%erase_output_file:~0,1%
IF /i "%erase_output_file%"=="o" del /q "%output_folder%\%boot0_output_file%" >nul
"tools\python3_scripts\boot0_rewrite\boot0_rewrite.exe" -i "%boot0_input_file%" -o "%output_folder%\%boot0_output_file%" -k "%prod_keys_file%" >nul
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "create_boot0_error"
) else (
	call "%associed_language_script%" "create_boot0_success"
)
goto:endscript

:get_type_nand
set nand_type=
set nand_soc_rev=
set temp_input_file=%~1
tools\NxNandManager\NxNandManager.exe --info -i "%temp_input_file%" >templogs\infos_nand.txt
set temp_input_file=
tools\gnuwin32\bin\grep.exe "NAND type" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_type=<templogs\tempvar.txt
set nand_type=%nand_type:~1%
tools\gnuwin32\bin\grep.exe "SoC revision " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_soc_rev=<templogs\tempvar.txt
set nand_soc_rev=!nand_soc_rev:~1!
exit /b

:endscript
pause
:endscript2
rmdir /s /q templogs
endlocal