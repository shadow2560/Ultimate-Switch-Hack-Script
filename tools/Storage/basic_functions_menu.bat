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
:define_action_choice
call "%associed_language_script%" "display_title"
set action_choice=
cls
call "%associed_language_script%" "display_menu"
IF "%action_choice%"=="1" goto:launch_payload
IF "%action_choice%"=="2" goto:pegaswitch
IF "%action_choice%"=="3" goto:install_drivers
IF "%action_choice%"=="4" goto:prepare_sd
IF "%action_choice%"=="5" goto:verif_serials
IF "%action_choice%"=="6" goto:test_keys
IF "%action_choice%"=="7" goto:mount_discs
IF "%action_choice%"=="8" goto:launch_nsusbloader
IF "%action_choice%"=="9" goto:modchips_management
IF "%action_choice%"=="10" goto:create_sig_patches
IF "%action_choice%"=="11" goto:spoof_sxos_licence
goto:end_script

:launch_payload
set action_choice=
echo.
cls
IF EXIST "tools\Storage\launch_payload.bat" (
	call tools\Storage\update_manager.bat "update_launch_payload.bat"
) else (
	call tools\Storage\update_manager.bat "update_launch_payload.bat" "force"
)
call tools\Storage\launch_payload.bat
@echo off
goto:define_action_choice
:pegaswitch
set action_choice=
echo.
cls
IF EXIST "tools\Storage\pegaswitch.bat" (
	call tools\Storage\update_manager.bat "update_pegaswitch.bat"
) else (
	call tools\Storage\update_manager.bat "update_pegaswitch.bat" "force"
)
call tools\Storage\pegaswitch.bat
@echo off
goto:define_action_choice
:install_drivers
set action_choice=
echo.
cls
IF EXIST "tools\Storage\install_drivers.bat" (
	call tools\Storage\update_manager.bat "update_install_drivers.bat"
) else (
	call tools\Storage\update_manager.bat "update_install_drivers.bat" "force"
)
call TOOLS\Storage\install_drivers.bat
@echo off
goto:define_action_choice
:prepare_sd
set action_choice=
echo.
cls
IF EXIST "tools\Storage\prepare_sd_switch.bat" (
	call tools\Storage\update_manager.bat "update_prepare_sd_switch.bat"
) else (
	call tools\Storage\update_manager.bat "update_prepare_sd_switch.bat" "force"
)
call tools\Storage\prepare_sd_switch.bat
@echo off
goto:define_action_choice
:verif_serials
set action_choice=
echo.
cls
IF EXIST "tools\Storage\serial_checker.bat" (
	call tools\Storage\update_manager.bat "update_serial_checker.bat"
) else (
	call tools\Storage\update_manager.bat "update_serial_checker.bat" "force"
)
call TOOLS\Storage\serial_checker.bat
@echo off
goto:define_action_choice
:test_keys
set action_choice=
echo.
cls
IF EXIST "tools\Storage\test_keys.bat" (
	call tools\Storage\update_manager.bat "update_test_keys.bat"
) else (
	call tools\Storage\update_manager.bat "update_test_keys.bat" "force"
)
call TOOLS\Storage\test_keys.bat
@echo off
goto:define_action_choice
:mount_discs
set action_choice=
echo.
cls
IF EXIST "tools\Storage\mount_discs.bat" (
	call tools\Storage\update_manager.bat "update_mount_discs.bat"
) else (
	call tools\Storage\update_manager.bat "update_mount_discs.bat" "force"
)
call tools\Storage\mount_discs.bat
@echo off
goto:define_action_choice
:launch_nsusbloader
set action_choice=
echo.
cls
IF EXIST "tools\Storage\launch_nsusbloader.bat" (
	call tools\Storage\update_manager.bat "update_launch_nsusbloader.bat"
) else (
	call tools\Storage\update_manager.bat "update_launch_nsusbloader.bat" "force"
)
call tools\Storage\launch_nsusbloader.bat
@echo off
goto:define_action_choice
:modchips_management
set action_choice=
echo.
cls
IF EXIST "tools\Storage\modchips_management.bat" (
	call tools\Storage\update_manager.bat "update_modchips_management.bat"
) else (
	call tools\Storage\update_manager.bat "update_modchips_management.bat" "force"
)
call TOOLS\Storage\modchips_management.bat
@echo off
goto:define_action_choice
:create_sig_patches
set action_choice=
echo.
cls
IF EXIST "tools\Storage\auto_ips_menu.bat" (
	call tools\Storage\update_manager.bat "update_auto_ips_menu.bat"
) else (
	call tools\Storage\update_manager.bat "update_auto_ips_menu.bat" "force"
)
call TOOLS\Storage\auto_ips_menu.bat
@echo off
goto:define_action_choice
:spoof_sxos_licence
set action_choice=
echo.
cls
IF EXIST "tools\Storage\spoof_sxos_licence.bat" (
	call tools\Storage\update_manager.bat "update_spoof_sxos_licence.bat"
) else (
	call tools\Storage\update_manager.bat "update_spoof_sxos_licence.bat" "force"
)
call TOOLS\Storage\spoof_sxos_licence.bat
@echo off
goto:define_action_choice
:end_script
endlocal