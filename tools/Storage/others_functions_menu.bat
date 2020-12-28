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
IF "%action_choice%"=="1" goto:convert_game
IF "%action_choice%"=="2" goto:renxpack
IF "%action_choice%"=="3" goto:install_nsp_network
IF "%action_choice%"=="4" goto:install_nsp_usb
IF "%action_choice%"=="5" goto:convert_BOTW
IF "%action_choice%"=="6" goto:extract_cert
IF "%action_choice%"=="7" goto:verify_nsp
IF "%action_choice%"=="8" goto:split_games
IF "%action_choice%"=="9" goto:merge_games
IF "%action_choice%"=="10" goto:nsZip
IF "%action_choice%"=="11" goto:config_nes_classic
IF "%action_choice%"=="12" goto:config_snes_classic
IF "%action_choice%"=="13" goto:install_android_apps
goto:end_script

:convert_game
set action_choice=
echo.
cls
IF EXIST "tools\Storage\convert_game_to_nsp.bat" (
	call tools\Storage\update_manager.bat "update_convert_game_to_nsp.bat"
) else (
	call tools\Storage\update_manager.bat "update_convert_game_to_nsp.bat" "force"
)
call TOOLS\Storage\convert_game_to_nsp.bat
@echo off
goto:define_action_choice
:renxpack
set action_choice=
echo.
cls
IF EXIST "tools\Storage\renxpack.bat" (
	call tools\Storage\update_manager.bat "update_renxpack.bat"
) else (
	call tools\Storage\update_manager.bat "update_renxpack.bat" "force"
)
call TOOLS\Storage\renxpack.bat
@echo off
goto:define_action_choice
:install_nsp_network
set action_choice=
echo.
cls
IF EXIST "tools\Storage\install_nsp_network.bat" (
	call tools\Storage\update_manager.bat "update_install_nsp_network.bat"
) else (
	call tools\Storage\update_manager.bat "update_install_nsp_network.bat" "force"
)
call TOOLS\Storage\install_nsp_network.bat
@echo off
goto:define_action_choice
:install_nsp_usb
set action_choice=
echo.
cls
IF EXIST "tools\Storage\install_nsp_usb.bat" (
	call tools\Storage\update_manager.bat "update_install_nsp_usb.bat"
) else (
	call tools\Storage\update_manager.bat "update_install_nsp_usb.bat" "force"
)
call TOOLS\Storage\install_nsp_usb.bat
@echo off
goto:define_action_choice
:convert_BOTW
set action_choice=
echo.
cls
IF EXIST "tools\Storage\convert_BOTW.bat" (
	call tools\Storage\update_manager.bat "update_convert_BOTW.bat"
) else (
	call tools\Storage\update_manager.bat "update_convert_BOTW.bat" "force"
)
call TOOLS\Storage\convert_BOTW.bat
@echo off
goto:define_action_choice
:extract_cert
set action_choice=
echo.
cls
IF EXIST "tools\Storage\extract_cert.bat" (
	call tools\Storage\update_manager.bat "update_extract_cert.bat"
) else (
	call tools\Storage\update_manager.bat "update_extract_cert.bat" "force"
)
call TOOLS\Storage\extract_cert.bat
@echo off
goto:define_action_choice
:verify_nsp
set action_choice=
echo.
cls
IF EXIST "tools\Storage\verify_nsp.bat" (
	call tools\Storage\update_manager.bat "update_verify_nsp.bat"
) else (
	call tools\Storage\update_manager.bat "update_verify_nsp.bat" "force"
)
call TOOLS\Storage\verify_nsp.bat
@echo off
goto:define_action_choice
:split_games
set action_choice=
echo.
cls
IF EXIST "tools\Storage\split_games.bat" (
	call tools\Storage\update_manager.bat "update_split_games.bat"
) else (
	call tools\Storage\update_manager.bat "update_split_games.bat" "force"
)
call TOOLS\Storage\split_games.bat
@echo off
goto:define_action_choice
:merge_games
set action_choice=
echo.
cls
IF EXIST "tools\Storage\merge_games.bat" (
	call tools\Storage\update_manager.bat "update_merge_games.bat"
) else (
	call tools\Storage\update_manager.bat "update_merge_games.bat" "force"
)
call TOOLS\Storage\merge_games.bat
@echo off
goto:define_action_choice
:nsZip
set action_choice=
echo.
cls
IF EXIST "tools\Storage\nsZip.bat" (
	call tools\Storage\update_manager.bat "update_nsZip.bat"
) else (
	call tools\Storage\update_manager.bat "update_nsZip.bat" "force"
)
call TOOLS\Storage\nsZip.bat
@echo off
goto:define_action_choice
:config_nes_classic
set action_choice=
echo.
cls
IF EXIST "tools\NES_Injector\*.*" (
	call tools\Storage\update_manager.bat "update_NES_Injector"
) else (
	call tools\Storage\update_manager.bat "update_NES_Injector" "force"
)
call TOOLS\NES_Injector\NES_Injector.bat
@echo off
goto:define_action_choice
:config_snes_classic
set action_choice=
echo.
cls
IF EXIST "tools\SNES_Injector\*.*" (
	call tools\Storage\update_manager.bat "update_SNES_Injector"
) else (
	call tools\Storage\update_manager.bat "update_SNES_Injector" "force"
)
call TOOLS\SNES_Injector\SNES_Injector.bat
@echo off
goto:define_action_choice
:install_android_apps
set action_choice=
echo.
cls
IF EXIST "tools\Storage\android_installer.bat" (
	call tools\Storage\update_manager.bat "update_android_installer.bat"
) else (
	call tools\Storage\update_manager.bat "update_android_installer.bat" "force"
)
call TOOLS\Storage\android_installer.bat
@echo off
goto:define_action_choice
:end_script
endlocal