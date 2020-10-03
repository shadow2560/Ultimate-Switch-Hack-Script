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
call "%associed_language_script%" "intro"
pause
:select_install
cls
set install_choice=
call "%associed_language_script%" "install_choice"
IF NOT "%install_choice%"=="" set install_choice=%install_choice:~0,1%
IF "%install_choice%"=="1" goto:auto_install
IF "%install_choice%"=="2" goto:Zadig
IF "%install_choice%"=="3" goto:manual_install
IF "%install_choice%"=="4" goto:maximize_hekate_mass_storage_speed
IF "%install_choice%"=="0" goto:launch_doc
goto:finish_script
:auto_install
cd tools\drivers\automatic_install
"drivers.exe"
cd ..\..\..
set test_payload=
call "%associed_language_script%" "test_payload_choice"
IF NOT "%test_payload%"=="" set test_payload=%test_payload:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "test_payload" "o/n_choice"
IF /i "%test_payload%"=="o" (
	set test_payload=
	call tools\Storage\launch_payload.bat
	@echo off
)
echo.
goto:select_install
:Zadig
call "%associed_language_script%" "zadig_launch_instructions"
pause
echo.
start tools\drivers\zadig\zadig.exe
goto:select_install
:manual_install
call "%associed_language_script%" "manual_install_instructions"
pause
echo.
start devmgmt.msc
goto:select_install
:maximize_hekate_mass_storage_speed
start tools\drivers\hekate_usb_storage_registry_config\nyx_usb_max_rate.reg
goto:select_install
:launch_doc
echo.
start "%language_pack%\doc\files\install_drivers.html
goto:select_install
:end_script
pause
:finish_script
endlocal