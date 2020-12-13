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
set action_choice=
cls
::Header
call "%associed_language_script%" "display_title"
echo :::::::::::::::::::::::::::::::::::::
call "%associed_language_script%" "display_menu"
IF "%action_choice%"=="1" goto:update_on_sd
IF "%action_choice%"=="2" goto:unbrick
IF "%action_choice%"=="3" goto:create_update
IF "%action_choice%"=="4" goto:boot0_rewrite
IF "%action_choice%"=="5" goto:prodinfo_rewrite
IF "%action_choice%"=="6" goto:create_update_2
IF "%action_choice%"=="0" (
	set action_choice=
	start "" "http://rover.ebay.com/rover/1/709-53476-19255-0/1?icep_ff3=2&pub=5575378759&campid=5338273189&customid=&icep_item=114242698090&ipn=psmain&icep_vectorid=229480&kwid=902099&mtid=824&kw=lg&toolid=11111"
	goto:define_action_choice
)
goto:end_script

:update_on_sd
set action_choice=
echo.
cls
IF EXIST "tools\Storage\prepare_update_on_sd.bat" (
	call tools\Storage\update_manager.bat "update_prepare_update_on_sd.bat"
) else (
	call tools\Storage\update_manager.bat "update_prepare_update_on_sd.bat" "force"
)
call TOOLS\Storage\prepare_update_on_sd.bat
@echo off
goto:define_action_choice
:unbrick
set action_choice=
echo.
cls
IF EXIST "tools\Storage\unbrick.bat" (
	call tools\Storage\update_manager.bat "update_unbrick.bat"
) else (
	call tools\Storage\update_manager.bat "update_unbrick.bat" "force"
)
call tools\Storage\unbrick.bat
@echo off
goto:define_action_choice
:create_update
set action_choice=
echo.
cls
IF EXIST "tools\Storage\create_update.bat" (
	call tools\Storage\update_manager.bat "update_create_update.bat"
) else (
	call tools\Storage\update_manager.bat "update_create_update.bat" "force"
)
call TOOLS\Storage\create_update.bat
@echo off
goto:define_action_choice
:boot0_rewrite
set action_choice=
echo.
cls
IF EXIST "tools\Storage\boot0_rewrite.bat" (
	call tools\Storage\update_manager.bat "update_boot0_rewrite.bat"
) else (
	call tools\Storage\update_manager.bat "update_boot0_rewrite.bat" "force"
)
call tools\Storage\boot0_rewrite.bat
@echo off
goto:define_action_choice
:prodinfo_rewrite
set action_choice=
echo.
cls
IF EXIST "tools\Storage\prodinfo_rewrite.bat" (
	call tools\Storage\update_manager.bat "update_prodinfo_rewrite.bat"
) else (
	call tools\Storage\update_manager.bat "update_prodinfo_rewrite.bat" "force"
)
call tools\Storage\prodinfo_rewrite.bat
@echo off
goto:define_action_choice
:create_update_2
set action_choice=
echo.
cls
IF EXIST "tools\Storage\create_update_2.bat" (
	call tools\Storage\update_manager.bat "update_create_update_2.bat"
) else (
	call tools\Storage\update_manager.bat "update_create_update_2.bat" "force"
)
call TOOLS\Storage\create_update_2.bat
@echo off
goto:define_action_choice
:end_script
endlocal