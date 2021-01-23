::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set folders_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/trunk
set files_url_project_base=https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master
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
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
:define_action_choice
cls
call "%associed_language_script%" "display_title"
echo.
set action_choice=
call "%associed_language_script%" "action_choice"
IF "%action_choice%"=="1" goto:display_changelog_general
IF "%action_choice%"=="2" goto:display_changelog_packs
IF "%action_choice%"=="3" goto:display_credits
IF "%action_choice%"=="4" goto:check_update
IF "%action_choice%"=="5" goto:full_update
IF "%action_choice%"=="6" goto:donate
IF "%action_choice%"=="7" (
	start https://tooomm.github.io/github-release-stats/?username=shadow2560^&repository=Ultimate-Switch-Hack-Script
	goto:define_action_choice
)
goto:end_script
:display_changelog_general
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection"
	IF EXIST "%language_path%\doc\files\changelog.html" start "%language_path%\doc\files\changelog.html"
	goto:define_action_choice
)
"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "changelog.html" "%files_url_project_base%/%language_path:\=/%/doc/files/changelog.html"
start "" "templogs\changelog.html"
goto:define_action_choice
:display_changelog_packs
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection"
	IF EXIST "%language_path%\doc\files\packs_changelog.html" start "%language_path%\doc\files\packs_changelog.html"
	goto:define_action_choice
)
"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "packs_changelog.html" "%files_url_project_base%/%language_path:\=/%/doc/files/packs_changelog.html"
start "" "templogs\packs_changelog.html"
goto:define_action_choice
:display_credits
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection"
	IF EXIST "%language_path%\doc\files\credits.html" start "%language_path%\doc\files\credits.html"
	goto:define_action_choice
)
"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "credits.html" "%files_url_project_base%/%language_path:\=/%/doc/files/credits.html"
start "" "templogs\credits.html"
goto:define_action_choice
:check_update
set action_choice=
echo.
cls
call TOOLS\Storage\update_manager.bat "update_all" "force"
@echo off
exit
:full_update
set action_choice=
echo.
del /s /q folder_version.txt >nul
del /q Ultimate-Switch-Hack-Script.bat.version >nul
move "tools\Storage\update_manager.bat.version" "templogs\update_manager.bat.version" >nul
del /q tools\Storage\*.version >nul
move "templogs\update_manager.bat.version" "tools\Storage\update_manager.bat.version" >nul
cls
call TOOLS\Storage\update_manager.bat "update_all" "force"
@echo off
exit
:donate
set action_choice=
echo.
cls
call tools\Storage\donate.bat
@echo off
goto:define_action_choice
:end_script
rmdir /s /q templogs 2>nul
endlocal