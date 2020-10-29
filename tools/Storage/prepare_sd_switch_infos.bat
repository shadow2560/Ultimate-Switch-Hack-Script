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
Setlocal disabledelayedexpansion
IF /i NOT "%atmo_upload_enabled%"=="o" (
	set atmo_upload_enabled=n
)
IF /i NOT "%atmo_usb30_force_enabled%"=="o" (
	set atmo_usb30_force_enabled=n
)
IF /i NOT "%atmo_ease_nro_restriction%"=="o" (
	set atmo_ease_nro_restriction=n
)
IF /i NOT "%atmo_dmnt_cheats_enabled_by_default%"=="o" (
	set atmo_dmnt_cheats_enabled_by_default=n
)
IF /i NOT "%atmo_dmnt_always_save_cheat_toggles%"=="o" (
	set atmo_dmnt_always_save_cheat_toggles=n
)
IF /i NOT "%atmo_enable_hbl_bis_write%"=="o" (
	set atmo_enable_hbl_bis_write=n
)
IF /i NOT "%atmo_enable_hbl_cal_read%"=="o" (
	set atmo_enable_hbl_cal_read=n
)
IF /i NOT "%atmo_fsmitm_redirect_saves_to_sd%"=="o" (
	set atmo_fsmitm_redirect_saves_to_sd=n
)
IF /i NOT "%atmo_enable_deprecated_hid_mitm%"=="o" (
	set atmo_enable_deprecated_hid_mitm=n
)
IF "%atmo_fatal_auto_reboot_interval%"=="" (
	set atmo_fatal_auto_reboot_interval=0
)
IF "%atmo_power_menu_reboot_function%"=="" (
set atmo_power_menu_reboot_function=1
)
IF "%atmo_applet_heap_size%"=="" (
	set atmo_applet_heap_size=0
)
IF "%atmo_applet_heap_reservation_size%"=="" (
	set atmo_applet_heap_reservation_size=8000000
)
IF "%atmo_hbl_override_key%"=="" (
	set atmo_hbl_override_key=R
)
IF "%atmo_hbl_override_any_app_key%"=="" (
	set atmo_hbl_override_any_app_key=R
)
IF "%atmo_layeredfs_override_key%"=="" (
	set inverted_atmo_layeredfs_override_key=Y
	set atmo_layeredfs_override_key=L
)
IF "%atmo_cheats_override_key%"=="" (
	set inverted_atmo_cheats_override_key=Y
	set atmo_cheats_override_key=L
)
IF "%atmosphere_emummc_profile_path%"=="" set atmosphere_pass_copy_emummc_pack=Y
IF "%atmosphere_modules_profile_path%"=="" set atmosphere_pass_copy_modules_pack=Y
IF "%reinx_modules_profile_path%"=="" set reinx_pass_copy_modules_pack=Y
IF "%sxos_modules_profile_path%"=="" set sxos_pass_copy_modules_pack=Y
IF "%emu_profile_path%"=="" set pass_copy_emu_pack=Y
IF "%mixed_profile_path%"=="" set pass_copy_mixed_pack=Y
IF "%overlays_profile_path%"=="" set pass_copy_overlays_pack=Y
IF "%salty-nx_profile_path%"=="" set pass_copy_salty-nx_pack=Y
IF "%cheats_profile_path%"=="" (
	IF NOT "%copy_all_cheats_pack%"=="Y" (
		set copy_cheats=
		set atmosphere_enable_cheats=
		set sxos_enable_cheats=
	)
)
echo.
call "%associed_language_script%" "display_infos"
endlocal
endlocal