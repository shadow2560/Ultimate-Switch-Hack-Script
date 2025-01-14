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
IF /i NOT "%atmo_disable_automatic_report_cleanup%"=="o" (
	set atmo_disable_automatic_report_cleanup=n
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
IF /i NOT "%atmo_enable_am_debug_mode%"=="o" (
	set atmo_enable_am_debug_mode=n
)
IF /i NOT "%atmo_enable_dns_mitm%"=="o" (
	set atmo_enable_dns_mitm=n
)
IF /i NOT "%atmo_add_defaults_to_dns_hosts%"=="o" (
	set atmo_add_defaults_to_dns_hosts=n
)
IF /i NOT "%atmo_enable_dns_mitm_debug_log%"=="o" (
	set atmo_enable_dns_mitm_debug_log=n
)
IF /i NOT "%atmo_enable_htc%"=="o" (
	set atmo_enable_htc=n
) else (
	set atmo_enable_log_manager=o
)
IF /i NOT "%atmo_enable_log_manager%"=="o" (
	set atmo_enable_log_manager=n
)
IF /i NOT "%atmo_enable_external_bluetooth_db%"=="o" (
	set atmo_enable_external_bluetooth_db=n
)
IF /i NOT "%atmo_enable_sd_card_logging%"=="o" (
	set atmo_enable_sd_card_logging=n
)
IF /i "%atmo_sd_card_log_output_directory%"=="" (
	set atmo_sd_card_log_output_directory=atmosphere/binlogs"
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
IF "%atmo_override_address_space%"=="" (
	set atmo_override_address_space=39
)
IF "%atmo_hbl_override_any_app_key%"=="" (
	set atmo_hbl_override_any_app_key=R
)
IF "%atmo_override_any_app_address_space%"=="" (
	set atmo_override_any_app_address_space=39
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
IF /i NOT "%sphaira_replace_hbmenu%"=="o" (
	set sphaira_replace_hbmenu=n
)
IF "%overlays_profile_path%"=="" set pass_copy_overlays_pack=Y
IF "%salty-nx_profile_path%"=="" set pass_copy_salty-nx_pack=Y
IF "%cheats_profile_path%"=="" (
	IF NOT "%copy_all_cheats_pack%"=="Y" (
		set copy_cheats=
		set atmosphere_enable_cheats=
		set sxos_enable_cheats=
	)
)
IF /i NOT "%sd_folder_structure_to_copy_choice%"=="o" (
	set sd_folder_structure_to_copy_choice=n
)
IF "%sd_folder_structure_to_copy_path%"=="" set sd_folder_structure_to_copy_choice=n
echo.
call "%associed_language_script%" "display_infos"
endlocal
endlocal