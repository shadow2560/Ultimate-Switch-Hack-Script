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
:define_disc_mounted
echo.
set ini_path=
set disc_mounted=
call "%associed_language_script%" "memory_choice"
IF "%disc_mounted%"=="1" (
set ini_path=tools\memloader\mount_discs\ums_emmc.ini
) else IF "%disc_mounted%"=="2" (
set ini_path=tools\memloader\mount_discs\ums_sd.ini
) else IF "%disc_mounted%"=="3" (
set ini_path=tools\memloader\mount_discs\ums_boot0.ini
) else IF "%disc_mounted%"=="4" (
set ini_path=tools\memloader\mount_discs\ums_boot1.ini
) else (
	goto:end_script
)
:mounting
call "%associed_language_script%" "rcm_instructions"
tools\TegraRcmSmash\TegraRcmSmash.exe -w tools\memloader\memloader_usb.bin --dataini="%ini_path%"
echo.
IF %disc_mounted% EQU 1 (
	set launch_hacdiskmount=
	call "%associed_language_script%" "hacdiskmount_launch_choice"
	IF NOT "!launch_hacdiskmount!"=="" set launch_hacdiskmount=!launch_hacdiskmount:~0,1!
	call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "launch_hacdiskmount" "o/n_choice"
	IF /i "!launch_hacdiskmount!"=="o" start tools\HacDiskMount/HacDiskMount.exe
)
set launch_devices_manager=
call "%associed_language_script%" "after_launch_first_choice"
echo.
IF NOT "%launch_devices_manager%"=="" set launch_devices_manager=%launch_devices_manager:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "launch_devices_manager" "o/n_choice"
IF /i "%launch_devices_manager%"=="o" start devmgmt.msc
IF NOT "%~1"=="auto_close" goto:define_disc_mounted
:end_script
endlocal