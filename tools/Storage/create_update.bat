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
cd >temp.txt
set /p calling_script_dir=<temp.txt
del /q temp.txt
set this_script_dir=%~dp0
%this_script_dir:~0,1%:
IF NOT "%~1"=="" (
	IF EXIST "%~1\*.*" (
		set update_file_path=%~1
		set update_type=1
	) else (
		call "%associed_language_script%" "folder_script_param_error"
		goto:endscript
	)
)
cd "%this_script_dir%"
IF EXIST "%calling_script_dir%\templogs" (
	del /q "%calling_script_dir%\templogs" 2>nul
	rmdir /s /q "%calling_script_dir%\templogs" 2>nul
)
mkdir "%calling_script_dir%\templogs"
call "%associed_language_script%" "warning_firmware_max_create"
echo.
cd ..\Hactool_based_programs
IF EXIST keys.txt (
	set define_new_keys_file=
	call "%associed_language_script%" "define_new_keys_file_choice"
	IF NOT "!define_new_keys_file!"=="" set define_new_keys_file=!define_new_keys_file:~0,1!
	call "%this_script_dir%\functions\modify_yes_no_always_never_vars.bat" "define_new_keys_file" "o/n_choice"
	IF /i "!define_new_keys_file!"=="o" goto:keys_file_creation
)
IF NOT EXIST keys.txt (
	IF EXIST keys.dat (
		copy keys.dat keys.txt
		goto:skip_keys_file_creation
	)
	call "%associed_language_script%" "keys_file_not_finded"
	goto:keys_file_creation
) else (
	goto:skip_keys_file_creation
)
:keys_file_creation
echo.
call "%associed_language_script%" "keys_file_selection"
	set /p keys_file_path=<"%calling_script_dir%\templogs\tempvar.txt"
	IF "%keys_file_path%"=="" (
	call "%associed_language_script%" "no_keys_file_selected_error"
	goto:endscript
	)
	
	copy "%keys_file_path%" keys.txt >nul
	
:skip_keys_file_creation
IF EXIST ChoiDuJour_keys.txt del /q ChoiDuJour_keys.txt >nul
..\python3_scripts\Keys_management\keys_management.exe create_choidujour_keys_file keys.txt >..\..\templogs\result_choidujour_keys_file_creation_file.txt
..\gnuwin32\bin\tail.exe -n1 <"..\..\templogs\result_choidujour_keys_file_creation_file.txt" >..\..\templogs\tempvar.txt
set /p create_choidujour_keys_file=<..\..\templogs\tempvar.txt
echo %create_choidujour_keys_file% | ..\gnuwin32\bin\grep.exe -c "ChoiDuJour_keys.txt" >..\..\templogs\tempvar.txt
set /p temp_count=<..\..\templogs\tempvar.txt
IF "%temp_count%"=="1" (
	set create_choidujour_keys_file_state=0
	goto:skip_choidujour_keys_file_create
)
echo %create_choidujour_keys_file% | ..\gnuwin32\bin\grep.exe -c " obligatoire " >..\..\templogs\tempvar.txt
set /p temp_count=<..\..\templogs\tempvar.txt
IF "%temp_count%"=="1" (
	set create_choidujour_keys_file_state=1
	echo %create_choidujour_keys_file% | ..\gnuwin32\bin\cut.exe -d \^" -f 2 >..\..\templogs\tempvar.txt
	set /p key_missing=<..\..\templogs\tempvar.txt
	del /q keys.txt >nul
	goto:skip_choidujour_keys_file_create
)
echo %create_choidujour_keys_file% | ..\gnuwin32\bin\grep.exe -c " facultative " >..\..\templogs\tempvar.txt
set /p temp_count=<..\..\templogs\tempvar.txt
IF "%temp_count%"=="1" (
	set create_choidujour_keys_file_state=2
	echo %create_choidujour_keys_file% | ..\gnuwin32\bin\cut.exe -d \^" -f 2 >..\..\templogs\tempvar.txt
	set /p key_missing=<..\..\templogs\tempvar.txt
	goto:skip_choidujour_keys_file_create
)
:skip_choidujour_keys_file_create
call "%associed_language_script%" "choidujour_keys_file_creation"
IF NOT EXIST ChoiDuJour_keys.txt (
	call "%associed_language_script%" "choidujour_keys_file_create_error"
	goto:endscript
)
IF NOT "%update_file_path%"=="" goto:skip_hfs0_select
set launch_xci_explorer=
call "%associed_language_script%" "launch_xci_explorer_choice"
IF NOT "%launch_xci_explorer%"=="" set launch_xci_explorer=%launch_xci_explorer:~0,1%
call "%this_script_dir%\functions\modify_yes_no_always_never_vars.bat" "launch_xci_explorer" "o/n_choice"
IF /i "%launch_xci_explorer%"=="o" XCI-Explorer.exe
:update_package_select
echo.
set update_type=
call "%associed_language_script%" "package_type_choice"
IF "%update_type%"=="" (
	call "%associed_language_script%" "no_package_type_selected_error"
	goto:update_package_select
) else (
	set update_type=%update_type:~0,1%
)
IF "%update_type%"=="1" (
	call "%associed_language_script%" "package_folder_select"
	set /p update_file_path=<"%calling_script_dir%\templogs\tempvar.txt"
) else IF "%update_type%"=="2" (
	call "%associed_language_script%" "package_file_select"
	set /p update_file_path=<"%calling_script_dir%\templogs\tempvar.txt"
) else (
	call "%associed_language_script%" "bad_choice_error"
	echo.
	goto:update_package_select
)
IF "%update_file_path%"=="" (
	call "%associed_language_script%" "no_source_selected_error"
	goto:endscript
)
set update_file_path=%update_file_path:\\=\%
:skip_hfs0_select
cd "%this_script_dir%"
:define_fspatches
set fspatches=--fspatches=nocmac
set enable_sigpatches=
call "%associed_language_script%" "sigpatches_param_choice"
IF NOT "%enable_sigpatches%"=="" set enable_sigpatches=%enable_sigpatches:~0,1%
call "%this_script_dir%\functions\modify_yes_no_always_never_vars.bat" "enable_sigpatches" "o/n_choice"
IF /i "%enable_sigpatches%"=="o" set fspatches=%fspatches%,nosigchk
set disable_gamecard=
call "%associed_language_script%" "nogc_param_choice"
IF NOT "%disable_gamecard%"=="" set disable_gamecard=%disable_gamecard:~0,1%
call "%this_script_dir%\functions\modify_yes_no_always_never_vars.bat" "disable_gamecard" "o/n_choice"
IF /i "%disable_gamecard%"=="o" set fspatches=%fspatches%,nogc
set no_exfat=
call "%associed_language_script%" "noexfat_param_choice"
IF NOT "%no_exfat%"=="" set no_exfat=%no_exfat:~0,1%
call "%this_script_dir%\functions\modify_yes_no_always_never_vars.bat" "no_exfat" "o/n_choice"
IF /i "%no_exfat%"=="o" set no_exfat_param=--noexfat
:start_update_creation
IF NOT EXIST "%calling_script_dir%\update_packages\*.*" (
	del /q "%calling_script_dir%\update_packages" 2>nul
	mkdir "%calling_script_dir%\update_packages"
)
%calling_script_dir:~0,1%:
cd "%calling_script_dir%\update_packages"
del /q list_of_dirs.ini 2>nul
dir /A:D >list_of_dirs.ini
"%this_script_dir%\..\Hactool_based_programs\tools\ChoiDujour.exe" --keyset="%this_script_dir%\..\Hactool_based_programs\ChoiDuJour_keys.txt" %no_exfat_param% %fspatches% "%update_file_path%"
::"%this_script_dir%\..\ChoiDuJour\program\ChoiDujour.exe" --keyset="%this_script_dir%\..\Hactool_based_programs\ChoiDuJour_keys.txt" %no_exfat_param% %fspatches% "%update_file_path%"
IF %errorlevel% EQU 0 (
	call "%associed_language_script%" "package_creation_success"
	goto:skip_verif_fw_dir
) else (
	call "%associed_language_script%" "package_creation_error"
	goto:verif_fw_dir
)
:verif_fw_dir
del /q list_of_dirs_2.ini 2>nul
dir /A:D >list_of_dirs_2.ini
"%this_script_dir%\..\gnuwin32\bin\diff.exe" list_of_dirs.ini list_of_dirs_2.ini | "%this_script_dir%\..\gnuwin32\bin\head.exe" -2 | "%this_script_dir%\..\gnuwin32\bin\tail.exe" -1 >new_dir.ini
::pause
::rmdir /q /s "%fw_dir%"
:skip_verif_fw_dir
IF "%update_type%"=="2" rmdir /q /s "%this_script_dir%\..\Hactool_based_programs\tools\update_update"
del /q list_of_dirs.ini 2>nul
del /q list_of_dirs_2.ini 2>nul
del /q new_dir.ini 2>nul
:endscript
pause
%calling_script_dir:~0,1%:
cd "%calling_script_dir%"
IF EXIST templogs\*.* (
	rmdir /s /q templogs
)
endlocal