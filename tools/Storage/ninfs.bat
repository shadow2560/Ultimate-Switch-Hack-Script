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
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "intro"
pause
:define_action_choice
cls
set biskeys_param=
set biskeys_file_path=
set action_choice=
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "first_action_choice"
IF "%action_choice%"=="1" cls & goto:launch_ninfs
IF "%action_choice%"=="2" cls & goto:install_winfsp
goto:end_script

:launch_ninfs
set input_path=
set biskeys_param=
set action_choice=
call "%associed_language_script%" "ninfs_input_begin"
set /p input_path=<templogs\tempvar.txt
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:launch_ninfs
)
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="RAWNAND (splitted dump)" set nand_type=RAWNAND
IF /i not "%nand_type%"=="RAWNAND" (
	call "%associed_language_script%" "ninfs_nand_type_error"
	goto:launch_ninfs
)
echo.
IF /i NOT "%nand_encrypted:~0,3%"=="Yes" (
	set biskeys_param=
	goto:skip_ninfs_biskeys_file_choice
) else (
	call :select_biskeys_file
	IF "!biskeys_file_path!"=="" (
		call "%associed_language_script%" "biskeys_file_not_selected_error"
		goto:launch_ninfs
	)
)
tools\NxNandManager\NxNandManager.exe --info -i "%input_path%" %biskeys_param% >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "ninfs_biskeys_not_valid_error"
	goto:launch_ninfs
)
call :biskeys_tempfile_verif_and_write
IF "%biskeys_file_type%"=="0" (
	set biskeys_param=--keys "%biskeys_file_path%"
) else (
	set biskeys_param=--keys "templogs\biskeys.txt"
)
echo.
:skip_ninfs_biskeys_file_choice
::runas /trustlevel:0x20000 "\"%windir%\system32\cmd.exe\" /c \"\"%ushs_base_path%\tools\ninfs\ninfs.exe\" nandhac %biskeys_param:"=\"% \"%input_path%\" *\""
::runas /user:%computername%\%username% "\"%windir%\system32\cmd.exe\" /c \"\"%ushs_base_path%\tools\ninfs\ninfs.exe\" nandhac %biskeys_param:"=\"% \"%input_path%\" *\""
::runas /user:%username%@%userdomain% "\"%windir%\system32\cmd.exe\" /c \"\"%ushs_base_path%\tools\ninfs\ninfs.exe\" nandhac %biskeys_param:"=\"% \"%input_path%\" *\""
start /i "Ninfs" "%windir%\system32\cmd.exe" /c tools\ninfs\ninfs.exe nandhac %biskeys_param% "%input_path%" *
goto:define_action_choice

:install_winfsp
tools\ninfs\winfsp.msi
goto:define_action_choice

:get_type_nand
set nand_type=
set nand_encrypted=
set temp_input_file=%~1
tools\NxNandManager\NxNandManager.exe --info -i "%temp_input_file%" >templogs\infos_nand.txt
set temp_input_file=
tools\gnuwin32\bin\grep.exe "NAND type" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_type=<templogs\tempvar.txt
set nand_type=%nand_type:~1%
tools\gnuwin32\bin\grep.exe "Encrypted " <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_encrypted=<templogs\tempvar.txt
set nand_encrypted=%nand_encrypted:~1%
exit /b

:select_biskeys_file
set biskeys_path=
call "%associed_language_script%" "biskeys_file_select_choice"
set /p biskeys_file_path=<templogs\tempvar.txt
exit /b

:biskeys_tempfile_verif_and_write
set biskeys_file_type=0
set tempcount=0
tools\gnuwin32\bin\grep.exe -c "bis_key_00" <"%biskeys_file_path%" >templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF "%temp_count%"=="1" exit /b
set biskeys_file_type=1
copy nul templogs\biskeys.txt >nul
tools\gnuwin32\bin\grep.exe "BIS KEY 0 (crypt):" <"%biskeys_file_path%" |tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p temp_biskey_crypt=<templogs\tempvar.txt
set temp_biskey_crypt=%temp_biskey_crypt:~1%
tools\gnuwin32\bin\grep.exe "BIS KEY 0 (tweak):" <"%biskeys_file_path%" |tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p temp_biskey_tweak=<templogs\tempvar.txt
set temp_biskey_tweak=%temp_biskey_tweak:~1%
set biskey_00=%temp_biskey_crypt%%temp_biskey_tweak%
tools\gnuwin32\bin\grep.exe "BIS KEY 1 (crypt):" <"%biskeys_file_path%" |tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p temp_biskey_crypt=<templogs\tempvar.txt
set temp_biskey_crypt=%temp_biskey_crypt:~1%
tools\gnuwin32\bin\grep.exe "BIS KEY 1 (tweak):" <"%biskeys_file_path%" |tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p temp_biskey_tweak=<templogs\tempvar.txt
set temp_biskey_tweak=%temp_biskey_tweak:~1%
set biskey_01=%temp_biskey_crypt%%temp_biskey_tweak%
tools\gnuwin32\bin\grep.exe "BIS KEY 2 (crypt):" <"%biskeys_file_path%" |tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p temp_biskey_crypt=<templogs\tempvar.txt
set temp_biskey_crypt=%temp_biskey_crypt:~1%
tools\gnuwin32\bin\grep.exe "BIS KEY 2 (tweak):" <"%biskeys_file_path%" |tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p temp_biskey_tweak=<templogs\tempvar.txt
set temp_biskey_tweak=%temp_biskey_tweak:~1%
set biskey_02=%temp_biskey_crypt%%temp_biskey_tweak%
tools\gnuwin32\bin\grep.exe "BIS KEY 3 (crypt):" <"%biskeys_file_path%" |tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p temp_biskey_crypt=<templogs\tempvar.txt
set temp_biskey_crypt=%temp_biskey_crypt:~1%
tools\gnuwin32\bin\grep.exe "BIS KEY 3 (tweak):" <"%biskeys_file_path%" |tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p temp_biskey_tweak=<templogs\tempvar.txt
set temp_biskey_tweak=%temp_biskey_tweak:~1%
set biskey_03=%temp_biskey_crypt%%temp_biskey_tweak%
echo bis_key_00 = %biskey_00%>>templogs\biskeys.txt
echo bis_key_01 = %biskey_01%>>templogs\biskeys.txt
echo bis_key_02 = %biskey_02%>>templogs\biskeys.txt
echo bis_key_03 = %biskey_03%>>templogs\biskeys.txt
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal