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
call "%associed_language_script%" "prodinfo_input_file_select_choice"
set /p prodinfo_input_file=<templogs\tempvar.txt
IF "%prodinfo_input_file%"=="" (
	call "%associed_language_script%" "prodinfo_input_file_empty_error"
	goto:endscript
)
call :get_type_nand "%prodinfo_input_file%"
IF /i "%nand_type%"=="RAWNAND (splitted dump)" set nand_type=RAWNAND
IF /i "%nand_type%"=="FULL NAND" set nand_type=RAWNAND
IF /i "%nand_type%"=="RAWNAND" goto:select_keys_file
IF /i "%nand_type%"=="PRODINFO" goto:select_keys_file
call "%associed_language_script%" "nand_type_must_be_prodinfo_error"
goto:endscript
:select_keys_file
echo.
call "%associed_language_script%" "prod_keys_file_select_choice"
set /p prod_keys_file=<templogs\tempvar.txt
IF "%prod_keys_file%"=="" (
	call "%associed_language_script%" "prod_keys_file_empty_error"
	goto:endscript
)
IF /i "%nand_encrypted:~0,3%"=="Yes" (
	goto:verif_encryption
) else (
	goto:skip_verif_encryption
)
:verif_encryption
IF /i "%nand_type%"=="RAWNAND" (
	tools\NxNandManager\NxNandManager.exe --crypto_check -i "%prodinfo_input_file%" -keyset "%prod_keys_file%" -part=PRODINFO>nul 2>&1
) else (
	tools\NxNandManager\NxNandManager.exe --crypto_check -i "%prodinfo_input_file%" -keyset "%prod_keys_file%" >nul 2>&1
)
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "decrypt_biskeys_not_valid_error"
	goto:endscript
)
:skip_verif_encryption
set temp_prodinfo=templogs\prodinfo_src.bin
IF /i "%nand_encrypted:~0,3%"=="Yes" (
	IF /i "%nand_type%"=="RAWNAND" (
		tools\NxNandManager\NxNandManager.exe -d -i "%prodinfo_input_file%" -o "%temp_prodinfo%" -keyset "%prod_keys_file%" -part=PRODINFO FORCE>nul 2>&1
	) else (
		tools\NxNandManager\NxNandManager.exe -d -i "%prodinfo_input_file%" -o "%temp_prodinfo%" -keyset "%prod_keys_file%" FORCE>nul 2>&1
	)
) else (
	IF /i "%nand_type%"=="RAWNAND" (
		tools\NxNandManager\NxNandManager.exe -i "%prodinfo_input_file%" -o "%temp_prodinfo%" -part=PRODINFO FORCE>nul 2>&1
	) else (
		copy /v /b "%prodinfo_input_file%" "%temp_prodinfo%" >nul
	)
)
:select_action_choice
echo.
set action_choice=
call "%associed_language_script%" "select_action_choice"
IF "%action_choice%"=="1" (
	"tools\python3_scripts\prodinfo_rewrite\prodinfo_rewrite.exe" -a verif_hashes -i "%temp_prodinfo%" >nul
	if !errorlevel! NEQ 0 (
		call "%associed_language_script%" "hashes_errors_found"
		pause
		goto:select_action_choice
	) else (
		call "%associed_language_script%" "hashes_errors_not_found"
		pause
		goto:select_action_choice
	)
)
IF "%action_choice%"=="2" goto:select_output
IF "%action_choice%"=="3" goto:select_output
goto:endscript2
:select_output
echo.
call "%associed_language_script%" "output_folder_choice"
set /p output_folder=<templogs\tempvar.txt
IF "%output_folder%"=="" (
	call "%associed_language_script%" "output_folder_empty_error"
	goto:select_action_choice
)
set prodinfo_output_file=
set prodinfo_output_file_encrypted=
IF "%action_choice%"=="2" (
	set prodinfo_output_file=PRODINFO_hashes_modified_decrypted.bin
	set prodinfo_output_file_encrypted=PRODINFO_hashes_modified_encrypted.bin
) else IF "%action_choice%"=="3" (
	set prodinfo_output_file=PRODINFO_text.txt
)
set erase_output_file=
set erase_output_files_verif=0
IF EXIST "%output_folder%\%prodinfo_output_file%" set erase_output_files_verif=1
IF "%action_choice%"=="2" (
	IF EXIST "%output_folder%\%prodinfo_output_file_encrypted%" set erase_output_files_verif=1
)
IF "%erase_output_files_verif%"=="1" (
	echo.
	call "%associed_language_script%" "erase_existing_file_choice"
)
IF NOT "%erase_output_file%"=="" set erase_output_file=%erase_output_file:~0,1%
IF "%action_choice%"=="2" (
	IF /i "%erase_output_file%"=="o" (
		IF EXIST "%output_folder%\%prodinfo_output_file%" del /q "%output_folder%\%prodinfo_output_file%" >nul
		IF EXIST "%output_folder%\%prodinfo_output_file_encrypted%" del /q "%output_folder%\%prodinfo_output_file_encrypted%" >nul
	)
)
IF "%action_choice%"=="3" (
	IF /i "%erase_output_file%"=="o" del /q "%output_folder%\%prodinfo_output_file%" >nul
)
IF "%action_choice%"=="2" (
	"tools\python3_scripts\prodinfo_rewrite\prodinfo_rewrite.exe" -a rewrite_hashes -i "%temp_prodinfo%" -o "%output_folder%\%prodinfo_output_file%" >nul
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "create_prodinfo_error"
	) else (
		call "%associed_language_script%" "create_prodinfo_success"
		tools\NxNandManager\NxNandManager.exe -e -i "%output_folder%\%prodinfo_output_file%" -o "%output_folder%\%prodinfo_output_file_encrypted%" -keyset "%prod_keys_file%" FORCE>nul 2>&1
		call "%associed_language_script%" "prodinfo_encrypted_usage"
	)
) else IF "%action_choice%"=="3" (
	"tools\python3_scripts\prodinfo_rewrite\prodinfo_rewrite.exe" -a get_infos -i "%temp_prodinfo%" -o "%output_folder%\%prodinfo_output_file%" >nul
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "create_prodinfo_error"
	) else (
		call "%associed_language_script%" "create_prodinfo_success"
	)
)
echo.
call "%associed_language_script%" "return_to_action_choice_question"
IF %errorlevel% equ 1 (
	goto:select_action_choice
) else IF %errorlevel% equ 2 (
	goto:endscript2
)

:get_type_nand
set nand_type=
set nand_encrypted=
set temp_input_file=%~1
tools\NxNandManager\NxNandManager.exe --info -i "%temp_input_file%" >templogs\infos_nand.txt
set temp_input_file=
tools\gnuwin32\bin\grep.exe "NAND type" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_type=<templogs\tempvar.txt
set nand_type=%nand_type:~1%
IF /i "%nand_type%"=="RAWNAND" (
	tools\NxNandManager\NxNandManager.exe --info -i "%temp_input_file%" -part=PRODINFO >templogs\infos_nand.txt
)
tools\gnuwin32\bin\grep.exe "Encrypted " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_encrypted=<templogs\tempvar.txt
set nand_encrypted=%nand_encrypted:~1%
exit /b

:endscript
pause
:endscript2
rmdir /s /q templogs
endlocal