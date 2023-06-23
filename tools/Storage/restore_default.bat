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
cd languages
for /d %%p in ("*") do (
	IF EXIST "%%p\script_general_config.bat" (
	del /q "%%p\script_general_config.bat" >nul 2>&1
)
cd ..
IF EXIST templogs\*.* rmdir /s /q templogs
IF EXIST downloads\*.* rmdir /s /q downloads
IF EXIST update_packages\*.* rmdir /s /q update_packages
IF EXIST "Ultimate-Switch-Hack-Script.bat.lng" del /q "Ultimate-Switch-Hack-Script.bat.lng"
IF EXIST "Ultimate-Switch-Hack-Script.bat.theme" del /q "Ultimate-Switch-Hack-Script.bat.theme"
IF EXIST TOOLS\Hactool_based_programs\keys.txt del /q TOOLS\Hactool_based_programs\keys.txt
IF EXIST TOOLS\Hactool_based_programs\keys.dat del /q TOOLS\Hactool_based_programs\keys.dat
IF EXIST TOOLS\Hactool_based_programs\ChoiDuJour_keys.txt del /q TOOLS\Hactool_based_programs\ChoiDuJour_keys.txt
IF EXIST "TOOLS\Hactool_based_programs\tools\update_update" rmdir /q /s "TOOLS\Hactool_based_programs\tools\update_update"
IF EXIST "TOOLS\Hactool_based_programs\4nxci_extracted_xci\*.*" rmdir /q /s "TOOLS\Hactool_based_programs\4nxci_extracted_xci"
IF EXIST "tools\netplay\servers_list.txt" del /q "tools\netplay\servers_list.txt"
IF EXIST "tools\NSC_Builder\keys.txt" del /q "tools\NSC_Builder\keys.txt"
del /q tools\sd_switch\atmosphere_emummc_profiles\*.ini 2>nul
del /q tools\sd_switch\cheats\profiles\*.ini 2>nul
del /q tools\sd_switch\emulators\profiles\*.ini 2>nul
del /q tools\sd_switch\mixed\profiles\*.ini 2>nul
del /q tools\sd_switch\modules\profiles\*.ini 2>nul
del /q tools\sd_switch\profiles\*.bat 2>nul
del /q tools\megatools\mega.ini
copy /v tools\default_configs\mega.ini tools\megatools\mega.ini
copy /v "tools\default_configs\servers_list.txt" "tools\netplay\servers_list.txt"
rmdir /s /q tools\toolbox
mkdir tools\toolbox
copy tools\default_configs\default_tools.txt tools\toolbox\default_tools.txt
copy nul tools\toolbox\user_tools.txt
IF EXIST log.txt del /q log.txt
IF EXIST biskey.txt del /q biskey.txt
IF EXIST HacDiskMount.log del /q HacDiskMount.log
IF EXIST tools\HacDiskMount\HacDiskMount.log del /q tools\HacDiskMount\HacDiskMount.log
call "%associed_language_script%" "success"
pause
endlocal