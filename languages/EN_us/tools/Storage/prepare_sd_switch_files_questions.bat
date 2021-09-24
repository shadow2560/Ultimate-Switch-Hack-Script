set lng_label_exist=0
%ushs_base_path%tools\gnuwin32\bin\grep.exe -c -E "^:%~1$" <"%~0" >"%ushs_base_path%temp_lng_var.txt"
set /p lng_label_exist=<"%ushs_base_path%temp_lng_var.txt"
del /q "%ushs_base_path%temp_lng_var.txt"
IF "%lng_label_exist%"=="0" (
	call "!associed_language_script:%language_path%=languages\FR_fr!" "%~1"
	goto:eof
) else (
	goto:%~1
)

:display_title
title SD prepare questions %this_script_version2% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:launch_manual_choice
echo SD prepare questions
echo.
set /p launch_manual=Do you want to launch the informations page on what could be copied ^(recommanded^)? ^(%lng_yes_choice%/%lng_no_choice%^):
goto:eof

:copy_atmosphere_pack_choice
set /p copy_atmosphere_pack=Do you want to copy the  pack to launch Atmosphere via  the Fusee-primary payload ^(Atmosphere's oficial release^) or via Hekate ^(pack Kosmos^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_nogc_patch_choice
echo Do you want to enable the nogc patch for Atmosphere  ^(firmware 4.0.0 and up^)?
echo This patch is useful for those who upgrade from 3.0.2 firmware or lower to higher than 3.0.2 firmware with ChoiDuJour/ChoiDuJourNX and who don't want to upgrade de gamecard reader's firmware, keeping the possibility to use the gamecard reader on firmware 3.0.2 or lower if they downgrade.
echo Be careful: If a higher than 3.0.2 firmware is launched without this patch, the gamecard firmware will be updated without possibility to downgrade it and this patch will not be useful after that.
set /p atmosphere_enable_nogc_patch=Do you want to enable the nogc patch for Atmosphere? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_choice
set /p atmosphere_manual_config=Do you want to set the Atmosphere's options manualy? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_copy_cheats_choice
set /p atmosphere_enable_cheats=Do you want to copy the cheats for Atmosphere ^(usable with the  homebrew EdiZon^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:reinx_warning_if_atmosphere_chosen
echo Copy ReiNX pack?
echo Be careful: You have chosen to copy Atmosphere's pack, if you are  on  the 7.0.0 firmware or higher and if you choose to  also copy   the ReiNX pack, Atmosphere will not be able to launch via his "Fusee Primary" payload , you will need to launch it  via Hekate.
goto:eof

:copy_reinx_pack_choice
set /p copy_reinx_pack=Do you want to copy the  ReiNX pack? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:reinx_nogc_patch_choice
echo Do you want to enable the nogc patch for ReiNX  ^(firmware 4.0.0 and up^)?
echo This patch is useful for those who upgrade from 3.0.2 firmware or lower to higher than 3.0.2 firmware with ChoiDuJour/ChoiDuJourNX and who don't want to upgrade de gamecard reader's firmware, keeping the possibility to use the gamecard reader on firmware 3.0.2 or lower if they downgrade.
echo Be careful: If a higher than 3.0.2 firmware is launched without this patch, the gamecard firmware will be updated without possibility to downgrade it and this patch will not be useful after that.
	set /p reinx_enable_nogc_patch=Do you want to enable the nogc patch for ReiNX? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:copy_memloader_pack_choice
set /p copy_memloader=Do you want to copy the files needed   by Memloader to mount the SD,  the EMMC partition, the Boot0 partition or the Boot1 partition on a PC when launching the Memloader payload? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:copy_sxos_pack_choice
set /p copy_sxos_pack=Do you want to copy the SX OS pack? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:sxos_remove_sx_autoloader
set /p remove_sx_autoloader=Do you want to remove the  SX-Autoloader module ^(only the module will be removed, not his cache if it exist^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:sxos_copy_selected_payloads_sd_root_choice
set /p copy_payloads=Do you want to copy the payloads  of the previously selected functions on SD root, to be compatible  with the payload launching of SX Loader? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:sxos_cheats_copy_choice
set /p sxos_enable_cheats=Do you want to copy the cheats for SX OS ^(usable with the ROMMENU of SX OS^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:copy_emulators_pack_choice
set /p copy_emu=Do you want to copy the emulators pack? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:emulators_kip_configs_choice
set /p keep_emu_configs=Do you want to keep your emulators configurations files? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:emulators_profile_select_begin
echo Select the emulators profile:
goto:eof

:emulators_profile_all
echo %temp_count%: All emulators.
goto:eof

:emulators_profile_choice
echo 0: Open emulators profiles management.
echo All other choices: Don't copy any emulators.
echo.
set /p emu_profile=Make your choice: 
goto:eof

:retroarch_update_choice
set /p update_retroarch=Do you want to update Retroarch before it copy on the SD ^(must be done at least one time to copy it^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:homebrews_profile_choice_begin
echo Select the optionnals homebrews profile:
goto:eof

:homebrews_profile_all
echo %temp_count%: All optionnals homebrews.
goto:eof

:homebrews_profile_choice
echo 0: Open the homebrews profiles management.
echo All other choices: Don't copy any homebrews.
echo.
set /p mixed_profile=Make your choice: 
goto:eof

:overlays_profile_choice_begin
echo Select the overlays profile:
goto:eof

:overlays_profile_all
echo %temp_count%: All overlays.
goto:eof

:overlays_profile_choice
echo 0: Open the overlays profiles management.
echo All other choices: Don't copy any overlays.
echo.
set /p overlays_profile=Make your choice: 
goto:eof

:salty-nx_profile_choice_begin
echo Select the Salty-nx modules profile:
goto:eof

:salty-nx_profile_all
echo %temp_count%: All Salty-nx modules.
goto:eof

:salty-nx_profile_choice
echo 0: Open the Salty-nx modules profiles management.
echo All other choices: Don't copy any Salty-nx module.
echo.
set /p salty-nx_profile=Make your choice: 
goto:eof

:cheats_profile_choice_begin
echo Select the cheats profile:
goto:eof

:cheats_profile_choice
echo 0: Open the cheats profiles management.
echo All other choices: Copy all cheats of the database.
echo.
set /p cheats_profile=Make your choice: 
goto:eof

:define_sd_folder_structure_to_copy_choice
set /p sd_folder_structure_to_copy_choice=Do you want to copy the content of a chosen folder on the SD root? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:define_sd_folder_structure_to_copy_path
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Select the folder  to copy the structure into it on the SD root"
goto:eof

:sd_folder_structure_to_copy_path_dir_not_exist_error
echo The folder doesn't exist, please try again.
goto:eof

:del_files_dest_copy_choice
echo SD datas removing:
echo 1: Reset all CFWs datas on the SD ^(will remove the themes, personals configurations, games mods  cause the  "titles" folders ^)or the "contents" folder for Atmosphere^) will be reset... so save your personals datas  if you want to keep them^)?
echo 2: Remove all files on the SD?
echo 0: Only update the files on the SD?
echo.
set /p del_files_dest_copy=Make your choice: 
goto:eof

:bad_choice
echo This choice doesn't exist.
goto:eof

:canceled
echo Operation canceled.
goto:eof

:confirm_script_settings
set /p confirm_copy=Do you confirm this? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:modules_profile_choice_begin
echo Select the optionals modules profiles for the CFW %~2:
goto:eof

:modules_profile_all
echo %temp_count%: All modules ^(not recommanded^).
goto:eof

:modules_profile_choice
echo 0: Open the modules profiles management.
echo All other choices: Don't copy any module.
echo.
set /p modules_profile=Make your choice: 
goto:eof

:atmosphere_manual_config_intro
echo Manual configuration of Atmosphere:
goto:eof

:atmosphere_manual_config_upload_param_choice
set /p atmo_upload_enabled=Enable the upload infos on nintendo's servers ^(not recommanded^): ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_usb3_param_choice
set /p atmo_usb30_force_enabled=Enable USB 3  ^(can cause problems^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_nro-restrict_param_choice
set /p atmo_ease_nro_restriction=Enable  NRO restrictions ^(not recommanded^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_fatal-reboot_interval_param_choice
set /p atmo_fatal_auto_reboot_interval=Time when the console will automaticaly reboot in case of crash ^(0 to wait an user button press to reboot^) ^(time in miliseconds^): 
goto:eof

:bad_value
echo Bad value.
goto:eof

:atmosphere_manual_config_fatal-reboot-interval_param_too_low_error
echo This value couldn't be lower than 10.
goto:eof

:atmosphere_manual_config_reboot-method_param_choice
echo How the console should reboot with the console's reboot menu function?
echo 1: Reboot the payload "atmosphere/reboot_to_payload.bin" on the SD ^(recommanded^).
echo 2: Reboot to RCM.
echo 3: Reboot normaly.
echo.
set /p atmo_power_menu_reboot_function=Make your choice: 
goto:eof

:empty_value_error
echo This value couldn't be empty.
goto:eof

:atmosphere_manual_config_cheats-default-state_param_choice
set /p atmo_dmnt_cheats_enabled_by_default=Cheats state enabled by default ^(if disabled, the cheats must be manualy enabled via   EdiZon for example^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_cheats-save-state_param_choice
set /p atmo_dmnt_always_save_cheat_toggles=Enable the automatic save of the cheats state ^(if disabled, the cheats state will be saved only if a cheats state file exist^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_hbl_bis_write
set /p atmo_enable_hbl_bis_write=Enable the bis partition write ^(not recommanded^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_hbl_cal_read
set /p atmo_enable_hbl_cal_read=Enable the CAL0 partition read ^(not recommanded^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_gamesave-on-sd_param_choice
set /p atmo_fsmitm_redirect_saves_to_sd=Enable the game save SD  redirection ^(experimental so not recommanded^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_am_debug_mode_param_choice
set /p atmo_enable_am_debug_mode=Enable the debug mode ^(not recommanded except if you are a developer^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_dns_mitm_param_choice
set /p atmo_enable_dns_mitm=Enable the service DNS_mitm ^(recommanded, enabled by default^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_add_defaults_to_dns_hosts_param_choice
set /p atmo_add_defaults_to_dns_hosts=Enable the default redirections with the config files of the service DNS_mitm ^(recommanded, enabled by default^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_dns_mitm_debug_log_param_choice
set /p atmo_enable_dns_mitm_debug_log=Enable the debug mode for DNS_mitm ^(not recommanded except if you are a developer^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_htc_param_choice
set /p atmo_enable_htc=Enable the HTC service? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_log_manager_param_choice
set /p atmo_enable_log_manager=Enable the Log Manager service? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_sd_card_logging_param_choice
set /p atmo_enable_sd_card_logging=Enable the SD card logging? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_sd_card_log_output_directory_param_choice
set /p atmo_sd_card_log_output_directory=SD card logging path ^(leave empty to set "atmosphere/binlogs" path^): 
goto:eof

:atmosphere_manual_config_applet-heap-size_param_choice
set /p atmo_applet_heap_size=Size reserved for the Homebrew Loader  in applet mode, set to 0 to use the maximum size is  recommanded ^(value set to 0 if empty^): 
goto:eof

:atmosphere_manual_config_applet-heap-reservation-size_param_choice
set /p atmo_applet_heap_reservation_size=Size reserved for the homebrews used  in applet mode, set this value to 8000000 is recommandd ^(value set to 8000000 if empty^): 
goto:eof

:atmosphere_manual_config_buttons_functions_activation_infos
echo Buttons configurations, buttons to maintain or not to enable some functionnality when launching a game:
echo.
echo You must enter the button to enable it and add a "!" in front of it for telling that this button disable the functionnality associed.
echo Here is the possible buttons list:
echo A, B, X, Y, L, R, ZL, ZR, LS, RS, SL, SR, +, -, DLEFT, DUP, DRIGHT, DDOWN
goto:eof

:atmosphere_manual_config_hbl_button_param_choice
set /p "atmo_hbl_override_key=Button for Homebrew Menu launching via the album: "
goto:eof

:atmosphere_manual_config_hbl_adress_space_param_choice
set /p atmo_override_address_space=Adress space for homebrew menu via the album in bit (39, 36 or 32, 39 if empty): 
goto:eof

:atmosphere_manual_config_hbl_app_button_param_choice
set /p "atmo_hbl_override_any_app_key=Button for Homebrew Menu launching in application mode: "
goto:eof

:atmosphere_manual_config_hbl_any_app_adress_space_param_choice
set /p atmo_override_any_app_address_space=Adress space for homebrew menu in application mode in bit (39, 36 or 32, 39 if empty): 
goto:eof

:value_not_accepted_error
echo This value couldn't be used.
goto:eof

:atmosphere_manual_config_cheats_button_param_choice
set /p atmo_cheats_override_key=Button for cheats enabling: 
goto:eof

:atmosphere_manual_config_layeredfs_button_param_choice
set /p atmo_layeredfs_override_key=button for Layeredfs enabling ^(games mods  for example^): 
goto:eof

:emummc_profile_choice_begin
echo Select emummc profile for the emummc configuration file of the CFW %~2:
goto:eof

:emummc_profile_partition_sxos_and_atmosphere
echo %temp_count%: Shared emummc with SX OS partition emunand.
goto:eof

:emummc_profile_choice
echo 0: Open emummc profiles management.
echo All other choices: Don't copy emummc configuration file.
echo.
set /p emummc_profile=Make your choice: 
goto:eof