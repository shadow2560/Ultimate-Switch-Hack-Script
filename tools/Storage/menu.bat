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
IF EXIST log.txt del /q log.txt
set ushs_launch=Y
:define_action_choice
set action_choice=
cls
::Header
call "%associed_language_script%" "display_title"
echo :::::::::::::::::::::::::::::::::::::
call "%associed_language_script%" "display_menu"
IF "%action_choice%"=="0" goto:launch_doc
IF "%action_choice%"=="1" goto:basic_functions
IF "%action_choice%"=="2" goto:updates_or_unbrick
IF "%action_choice%"=="3" goto:nand_toolbox
IF "%action_choice%"=="4" goto:launch_NSC_Builder
IF "%action_choice%"=="5" goto:launch_toolbox
IF "%action_choice%"=="6" goto:others_functions
IF "%action_choice%"=="7" goto:ocasional_functions
IF "%action_choice%"=="8" goto:settings
IF "%action_choice%"=="9" goto:client_netplay
IF "%action_choice%"=="10" goto:server_netplay
IF "%action_choice%"=="11" goto:nvda_remote_control
IF "%action_choice%"=="12" goto:language_change
IF "%action_choice%"=="13" goto:about
IF "%action_choice%"=="14" goto:donate
goto:end_script

:basic_functions
set action_choice=
echo.
cls
call tools\Storage\basic_functions_menu.bat
@echo off
goto:define_action_choice
:updates_or_unbrick
set action_choice=
echo.
cls
call tools\Storage\updates_or_unbrick_menu.bat
@echo off
goto:define_action_choice
:nand_toolbox
set action_choice=
echo.
cls
IF EXIST "tools\Storage\nand_toolbox.bat" (
	call tools\Storage\update_manager.bat "update_nand_toolbox.bat"
) else (
	call tools\Storage\update_manager.bat "update_nand_toolbox.bat" "force"
)
call tools\Storage\nand_toolbox.bat
@echo off
goto:define_action_choice
:launch_NSC_Builder
set action_choice=
echo.
cls
IF EXIST "tools\Storage\preload_NSC_Builder.bat" (
	call tools\Storage\update_manager.bat "update_preload_NSC_Builder.bat"
) else (
	call tools\Storage\update_manager.bat "update_preload_NSC_Builder.bat" "force"
)
call tools\Storage\preload_NSC_Builder.bat
@echo off
goto:define_action_choice
:launch_toolbox
set action_choice=
echo.
cls
IF EXIST "tools\Storage\toolbox.bat" (
	call tools\Storage\update_manager.bat "update_toolbox.bat"
) else (
	call tools\Storage\update_manager.bat "update_toolbox.bat" "force"
)
call tools\Storage\toolbox.bat
@echo off
goto:define_action_choice
:others_functions
set action_choice=
echo.
cls
call tools\Storage\others_functions_menu.bat
@echo off
goto:define_action_choice
:ocasional_functions
set action_choice=
echo.
cls
call tools\Storage\ocasional_functions_menu.bat
@echo off
goto:define_action_choice
:settings
set action_choice=
echo.
cls
call tools\Storage\settings_menu.bat
@echo off
goto:define_action_choice
:client_netplay
set action_choice=
echo.
cls
IF EXIST "tools\Storage\netplay.bat" (
	call tools\Storage\update_manager.bat "update_netplay.bat"
) else (
	call tools\Storage\update_manager.bat "update_netplay.bat" "force"
)
call tools\Storage\netplay.bat
@echo off
goto:define_action_choice
:server_netplay
set action_choice=
echo.
cls
IF EXIST "tools\Storage\launch_switch_lan_play_server.bat" (
	call tools\Storage\update_manager.bat "update_launch_switch_lan_play_server.bat"
) else (
	call tools\Storage\update_manager.bat "update_launch_switch_lan_play_server.bat" "force"
)
call tools\Storage\launch_switch_lan_play_server.bat
@echo off
goto:define_action_choice
:nvda_remote_control
set action_choice=
echo.
cls
IF EXIST "tools\Storage\nvda_remote_control.bat" (
	call tools\Storage\update_manager.bat "update_nvda_remote_control.bat"
) else (
	call tools\Storage\update_manager.bat "update_nvda_remote_control.bat" "force"
)
call tools\Storage\nvda_remote_control.bat
@echo off
goto:define_action_choice
:language_change
set action_choice=
echo.
cls
call tools\Storage\language_selector.bat
@echo off
goto:define_action_choice
:about
set action_choice=
echo.
cls
call tools\Storage\about.bat
@echo off
goto:define_action_choice
:donate
set action_choice=
echo.
cls
call tools\Storage\donate.bat
@echo off
goto:define_action_choice
:launch_doc
echo.
start "" "%language_path%\doc\index.html"
goto:define_action_choice
:end_script
endlocal
exit