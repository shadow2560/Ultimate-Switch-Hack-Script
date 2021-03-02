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
title Prepare SD infos %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_infos
IF "%profile_selected%"=="" (
	echo Sumary of what will be copied on the SD, volume "%volume_letter%:":
) else (
	echo Sumary for the profile %profile_selected:~0,-4%:
)
echo.
echo CFWs and packs:
IF /i "%copy_atmosphere_pack%"=="o" (
	IF /i "%atmosphere_enable_nogc_patch%"=="o" (
		echo Pack Atmosphere and Kosmos with  NOGC patch.
	) else (
			echo Pack Atmosphere and Kosmos
	)
	IF NOT "%atmosphere_pass_copy_modules_pack%"=="Y" (
		Echo Optionals modules  for Atmosphere:
		tools\gnuwin32\bin\sort.exe -n "%atmosphere_modules_profile_path%"
	) else (
		echo No optional module.
	)
	echo.
	IF /i NOT "%atmosphere_manual_config%"=="o" (
		echo Default configuration of the CFW.
	) else (
		echo Manual configuration of the CFW with following settings:
		IF /i "%atmo_upload_enabled%"=="o" (
			echo Upload infos to Nintendo servers enabled.
		) else (
			echo Upload infos to Nintendo servers disabled.
		)
		IF /i "%atmo_usb30_force_enabled%"=="o" (
			echo USB3 enabled.
		) else (
			echo USB3 disabled.
		)
		IF /i "%atmo_ease_nro_restriction%"=="o" (
			echo NRO restrictions enabled.
		) else (
			echo NRO restrictions disabled.
		)
		IF /i "%atmo_dmnt_cheats_enabled_by_default%"=="o" (
			echo Cheats state by defaults: enabled.
		) else (
			echo Cheats state by defaults: disabled.
		)
		IF /i "%atmo_dmnt_always_save_cheat_toggles%"=="o" (
			echo Automatic save of cheats state: always.
		) else (
			echo Automatic save of cheats state: Only if a file state exist for the game.
		)
						IF /i "%atmo_enable_hbl_bis_write%"=="o" (
			echo Bis partition write: enabled.
		) else (
			echo Bis partition write: disabled.
		)
						IF /i "%atmo_enable_hbl_cal_read%"=="o" (
			echo Cal0 partition read: enabled.
		) else (
			echo Cal0 partition read: disabled.
		)
		IF /i "%atmo_fsmitm_redirect_saves_to_sd%"=="o" (
			echo Game save redirecting to SD enabled.
		) else (
			echo Game save redirecting to SD disabled.
		)
						IF /i "%atmo_enable_am_debug_mode%"=="o" (
			echo Debug mode: enabled.
		) else (
			echo Debug mode: disabled.
		)
						IF /i "%atmo_enable_dns_mitm%"=="o" (
			echo DNS_mitm redirection: enabled.
		) else (
			echo DNS_mitm redirection: disabled.
		)
						IF /i "%atmo_add_defaults_to_dns_hosts%"=="o" (
			echo DNS_mitm default redirection used with the config files of the service: enabled.
		) else (
			echo DNS_mitm default redirection used with the config files of the service: disabled ^(not recommanded^).
		)
						IF /i "%atmo_enable_dns_mitm_debug_log%"=="o" (
			echo DNS_mitm debug mode: enabled.
		) else (
			echo DNS_mitm debug mode: disabled.
		)
						::IF /i "%atmo_enable_htc%"=="o" (
			::echo HTC service: enabled.
		::) else (
			::echo HTC service: disabled.
		::)
		IF "%atmo_fatal_auto_reboot_interval%"=="0" (
			echo Time before reboot if a crash occure: if the user press a button
		) else (
			echo Time before reboot if a crash occure: %atmo_fatal_auto_reboot_interval% MS
		)
		IF "%atmo_power_menu_reboot_function%"=="1" (
			echo Reboot menu action: reboot with the payload "/atmosphere/reboot_to_payload.bin" on the SD.
		) else IF "%atmo_power_menu_reboot_function%"=="2" (
			echo Reboot menu action: RCM reboot.
		) else IF "%atmo_power_menu_reboot_function%"=="3" (
			echo Reboot menu action: normal reboot.
		)
		IF "%atmo_applet_heap_size%"=="" (
			echo All memory size could be used by the Homebrew Loader in applet mode.
		) else IF "%atmo_applet_heap_size%"=="0" (
			echo All memory size could be used by the Homebrew Loader in applet mode.
		) else (
			echo Size of the memory that could be used by the Homebrew Loader in applet mode: %atmo_applet_heap_size%.
		)
			IF "%atmo_applet_heap_size%"=="0" echo Size reserved for homebrews in applet mode: %atmo_applet_heap_reservation_size%.
		IF "%inverted_atmo_hbl_override_key%"=="Y" (
			echo Homebrew Menu button activation via the album: all except %atmo_hbl_override_key%
		) else (
			echo Homebrew Menu button activation via the album: %atmo_hbl_override_key%
		)
		echo Adress space for the Homebrew Menu via the album: %atmo_override_address_space%_bit
						IF "%inverted_atmo_hbl_override_any_app_key%"=="Y" (
			echo Homebrew Menu button activation in application mode: toutes sauf %atmo_hbl_override_any_app_key%
		) else (
			echo Homebrew Menu button activation in application mode: %atmo_hbl_override_any_app_key%
		)
		echo Adress space for the Homebrew Menu in application mode: %atmo_override_any_app_address_space%_bit
		IF "%inverted_atmo_cheats_override_key%"=="Y" (
			echo Cheats enabling button activation: all except %atmo_cheats_override_key%
		) else (
			echo Cheats enabling button activation: %atmo_cheats_override_key%
		)
		IF "%inverted_atmo_layeredfs_override_key%"=="Y" (
			echo Layeredfs button activation: all except %atmo_layeredfs_override_key%
		) else (
			echo Layeredfs button activation: %atmo_layeredfs_override_key%
		)
	)
	echo.
	IF NOT "%atmosphere_pass_copy_emummc_pack%"=="Y" (
		Setlocal enabledelayedexpansion
		set temp_profile_path=%atmosphere_emummc_profile_path%
		set emunand_enable=
		set emummc_id=
		set emummc_title=
		set emummc_sector=
		set emummc_path=
		set emummc_nintendo_path=
		tools\gnuwin32\bin\grep.exe -E "^^enabled =" <"!temp_profile_path!" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
		set /p emunand_enable=<templogs\tempvar.txt
		del /q templogs\tempvar.txt
		IF NOT "!emunand_enable!"=="" set emunand_enable=!emunand_enable:~1!
		IF "!emunand_enable!"=="1" (
			set emunand_enable=o
		) else (
			set emunand_enable=n
		)
		tools\gnuwin32\bin\grep.exe -E "^^id =" <"!temp_profile_path!" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
		set /p emummc_id=<templogs\tempvar.txt
		del /q templogs\tempvar.txt
		IF NOT "!emummc_id!"=="" set emummc_id=!emummc_id:~1!
		tools\gnuwin32\bin\grep.exe -E "^^title =" <"!temp_profile_path!" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
		set /p emummc_title=<templogs\tempvar.txt
		del /q templogs\tempvar.txt
		IF NOT "!emummc_title!"=="" set emummc_title=!emummc_title:~1!
		tools\gnuwin32\bin\grep.exe -E "^^sector =" <"!temp_profile_path!" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
		set /p emummc_sector=<templogs\tempvar.txt
		del /q templogs\tempvar.txt
		IF NOT "!emummc_sector!"=="" set emummc_sector=!emummc_sector:~1!
		tools\gnuwin32\bin\grep.exe -E "^^path =" <"!temp_profile_path!" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
		set /p emummc_path=<templogs\tempvar.txt
		del /q templogs\tempvar.txt
		IF NOT "!emummc_path!"=="" set emummc_path=!emummc_path:~1!
		tools\gnuwin32\bin\grep.exe -E "^^nintendo_path =" <"!temp_profile_path!" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
		set /p emummc_nintendo_path=<templogs\tempvar.txt
		del /q templogs\tempvar.txt
		IF NOT "!emummc_nintendo_path!"=="" set emummc_nintendo_path=!emummc_nintendo_path:~1!
		IF /i "!emunand_enable!"=="o" (
			echo Emunand enabled with following settings:
			IF "!emummc_id!"=="" (
				echo Default emunand ID.
			) else (
				echo Emunand ID: !emummc_id!
			)
			IF "!emummc_title!"=="" (
				echo Default emunand title.
			) else (
				echo Emunand title: !emummc_title!
			)
			IF "!emummc_sector!"=="" (
				echo No emunand booting sector configured.
			) else (
				echo Emunand booting sector: !emummc_sector!
			)
			IF "!emummc_path!"=="" (
				echo No path to emunand dump files configured.
			) else (
				echo Path to emunand dump files: !emummc_path!
			)
			IF "!emummc_nintendo_path!"=="" (
				echo Default emunand nintendo path.
			) else (
				echo Emunand nintendo path: !emummc_nintendo_path!
			)
		) else (
			echo Emunand disabled.
		)
		endlocal
	) else (
		echo No emunand file configuration to copy.
	)
	echo.
)
IF /i "%copy_reinx_pack%"=="o" (
	IF /i "%reinx_enable_nogc_patch%"=="o" (
		echo Pack ReiNX with nogc patch
	) else (
	echo Pack ReiNX
	)
	IF NOT "%reinx_pass_copy_modules_pack%"=="Y" (
		Echo Optionals modules for ReiNX:
		tools\gnuwin32\bin\sort.exe -n "%reinx_modules_profile_path%"
	) else (
		echo No optional module to copy.
	)
	echo.
)
IF /i "%copy_sxos_pack%"=="o" (
	IF /i "%copy_payloads%"=="o" (
		echo Pack SX OS with payloads copy on SD root, these payloads could be launched with SX Loader
	) else (
		echo Pack SX OS
	)
	IF /i "%remove_sx_autoloader%"=="o" (
		echo The SX-Autoloader module will be removed.
	) else (
		echo The SX-Autoloader module will be used.
	)
	IF NOT "%sxos_pass_copy_modules_pack%"=="Y" (
		Echo Optionals modules  for SX OS:
		tools\gnuwin32\bin\sort.exe -n "%sxos_modules_profile_path%"
	) else (
		echo No optional module.
	)
	echo.
)
IF /i "%copy_memloader%"=="o" (
	echo Pack Memloader
	echo.
)
IF /i "%copy_emu%"=="o" (
	IF /i "%keep_emu_configs%"=="o" (
		echo Emulators Pack  with kiping their configuration files
	) else (
		echo Emulators Pack  with not kiping their configuration files
	)
	echo.
)
echo.
echo Optionals Homebrews:
IF "%pass_copy_mixed_pack%"=="Y" (
	echo No optional homebrew will be copied.
) else (
	tools\gnuwin32\bin\sort.exe -n "%mixed_profile_path%"
		tools\gnuwin32\bin\grep.exe -c "Tinfoil" <"%mixed_profile_path%" >templogs\tempvar.txt
	set /p temp_count=<templogs\tempvar.txt
)
IF NOT "%pass_copy_mixed_pack%"=="Y" (
	IF "%temp_count%"=="1" (
		echo Tinfoil will be copied, if you don't have a valid pay version of SX OS for the console it won't be possible to launch Tinfoil via Hekate and launching Atmosphere via Hekate's configurations might be impossible ^(Tinfoil removes the folder "atmosphere\kips" and the file "bootloader\patch.ini"^), to launch Atmosphere you will have to go through the payload Fusee-primary.
	)
)
echo.
IF /i "%copy_emu%"=="o" (
	echo Emulators:
	IF "%pass_copy_emu_pack%"=="Y" (
		echo No emulators will be copied.
	) else (
		tools\gnuwin32\bin\sort.exe -n "%emu_profile_path%"
	)
		IF /i "%update_retroarch%"=="o" (
		echo RetroArch will be updated.
	) else (
		echo RetroArch will not be updated.
	)
	echo.
)
echo Overlays:
IF "%pass_copy_overlays_pack%"=="Y" (
	echo No overlay will be copied.
) else (
	tools\gnuwin32\bin\sort.exe -n "%overlays_profile_path%"
)
	echo.
echo Salty-nx modules:
IF "%pass_copy_salty-nx_pack%"=="Y" (
	echo No Salty-nx module will be copied.
) else (
	tools\gnuwin32\bin\sort.exe -n "%salty-nx_profile_path%"
)
	echo.
IF "%copy_cheats%"=="Y" (
	echo Cheats:
	IF "%copy_all_cheats_pack%"=="Y" (
		echo All cheats database will be copied.
	) else (
		echo cheats profile chosen: %cheats_profile_name%
	)
	IF /i "%atmosphere_enable_cheats%"=="o" (
		echo The cheats for Atmosphere will be copied.
	) else (
		echo The cheats for Atmosphere will not be copied.
	)
	IF /i "%sxos_enable_cheats%"=="o" (
		echo The cheats for SX OS will be copied.
	) else (
		echo The cheats for SX OS will not be copied.
	)
	echo.
)
IF /i NOT "%sd_folder_structure_to_copy_choice%"=="o" (
	echo No custom folder will be copied.
) else IF NOT EXIST "%sd_folder_structure_to_copy_path%\*.*" (
	echo The "%sd_folder_structure_to_copy_path%" folder doesn't exist, it will not be copied.
) else (
	echo The content of the "%sd_folder_structure_to_copy_path%" folder will be copied on SD root.
)
IF /i "%del_files_dest_copy%"=="1" echo Be careful: All CFWs folder will be cleaned, included the "titles" folder of them.
IF /i "%del_files_dest_copy%"=="2" echo Be careful: All files on the SD will be removed.
IF /i "%del_files_dest_copy%"=="0" echo The files on  the SD will be kept and  only the updated files will be copied.
goto:eof