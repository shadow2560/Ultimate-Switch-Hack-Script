goto:%~1

:display_title
title Informations pour la préparation d'une SD %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_infos
IF "%profile_selected%"=="" (
	echo Résumé de se qui sera copié sur la SD, lecteur "%volume_letter%:":
) else (
	echo Résumé du profile %profile_selected:~0,-4%:
)
echo.
echo CFWs et packs:
IF /i "%copy_atmosphere_pack%"=="o" (
	IF /i "%atmosphere_enable_nogc_patch%"=="o" (
		echo Pack Atmosphere et Kosmos avec le patche NOGC.
	) else (
			echo Pack Atmosphere et Kosmos
	)
	IF NOT "%atmosphere_pass_copy_modules_pack%"=="Y" (
		Echo Modules optionnels pour Atmosphere:
		tools\gnuwin32\bin\sort.exe -n "%atmosphere_modules_profile_path%"
	) else (
		echo Aucun module optionnel à copier.
	)
	echo.
	IF /i NOT "%atmosphere_manual_config%"=="o" (
		echo Configuration du CFW par défaut.
	) else (
		echo Configuration manuelle du CFW avec les paramètres suivants:
		IF /i "%atmo_upload_enabled%"=="o" (
			echo Upload d'infos vers les serveurs de Nintendo activé.
		) else (
			echo Upload d'infos vers les serveurs de Nintendo désactivé.
		)
		IF /i "%atmo_usb30_force_enabled%"=="o" (
			echo USB3 activé.
		) else (
			echo USB3 désactivé.
		)
		IF /i "%atmo_ease_nro_restriction%"=="o" (
			echo Restrictions NRO activées.
		) else (
			echo Restrictions NRO désactivées.
		)
		IF /i "%atmo_dmnt_cheats_enabled_by_default%"=="o" (
			echo Etat des cheats par défaut: activé.
		) else (
			echo Etat des cheats par défaut: désactivé.
		)
		IF /i "%atmo_dmnt_always_save_cheat_toggles%"=="o" (
			echo Sauvegarde automatique de l'état des cheats: toujours.
		) else (
			echo Sauvegarde automatique de l'état des cheats: seulement si un fichier d'état existe pour le jeu.
		)
				IF /i "%atmo_enable_hbl_bis_write%"=="o" (
			echo Ecriture sur la partition bis: activée.
		) else (
			echo Ecriture sur la partition bis: désactivée.
		)
						IF /i "%atmo_enable_hbl_cal_read%"=="o" (
			echo Lecture de la partition cal0: activée.
		) else (
			echo Lecture de la partition cal0: désactivée.
		)
		IF /i "%atmo_fsmitm_redirect_saves_to_sd%"=="o" (
			echo Redirection des sauvegardes de jeu vers la SD activée.
		) else (
			echo Redirection des sauvegardes de jeu vers la SD désactivée.
		)
						IF /i "%atmo_enable_am_debug_mode%"=="o" (
			echo Mode débogage d'Atmosphere: activée.
		) else (
			echo Mode débogage d'Atmosphere: désactivée.
		)
						IF /i "%atmo_enable_dns_mitm%"=="o" (
			echo Redirrection DNS_mitm: activée.
		) else (
			echo Redirrection DNS_mitm: désactivée.
		)
						IF /i "%atmo_add_defaults_to_dns_hosts%"=="o" (
			echo Redirrection par défaut utilisé en plus des fichiers de configuration pour DNS_mitm: activée.
		) else (
			echo Redirrection par défaut utilisé en plus des fichiers de configuration pour DNS_mitm: désactivée.
		)
						IF /i "%atmo_enable_dns_mitm_debug_log%"=="o" (
			echo Mode débogage de DNS_mitm: activée.
		) else (
			echo Mode débogage de DNS_mitm: désactivée.
		)
						IF /i "%atmo_enable_htc%"=="o" (
			echo Service HTC: activée.
		) else (
			echo Service HTC: désactivée.
		)
						IF /i "%atmo_enable_log_manager%"=="o" (
			echo service de gestion du journal: activé.
		) else (
			echo service de gestion du journal: désactivé.
		)
						IF /i "%atmo_enable_sd_card_logging%"=="o" (
			echo Enregistrement du journal sur la carte SD: activé.
			echo Chemin d'enregistrement du journal sur la carte SD: %atmo_sd_card_log_output_directory%
		) else (
			echo Enregistrement du journal sur la carte SD: désactivé.
		)
		IF "%atmo_fatal_auto_reboot_interval%"=="0" (
			echo Temps avant de redémarrer en cas de crash: jusqu'à l'appui d'une touche par l'utilisateur
		) else (
			echo Temps avant de redémarrer en cas de crash: %atmo_fatal_auto_reboot_interval% MS
		)
		IF "%atmo_power_menu_reboot_function%"=="1" (
			echo Action du menu redémarrer: redémarre le payload "/atmosphere/reboot_to_payload.bin" de la SD.
		) else IF "%atmo_power_menu_reboot_function%"=="2" (
			echo Action du menu redémarrer: redémarre en RCM.
		) else IF "%atmo_power_menu_reboot_function%"=="3" (
			echo Action du menu redémarrer: redémarre normalement.
		)
		IF "%atmo_applet_heap_size%"=="" (
			echo Toute la taille de la mémoire peut être utilisée par le Homebrew Loader en mode applet.
		) else IF "%atmo_applet_heap_size%"=="0" (
			echo Toute la taille de la mémoire peut être utilisée par le Homebrew Loader en mode applet.
		) else (
			echo Taille de la mémoire utilisable par le Homebrew Loader: %atmo_applet_heap_size%.
		)
			IF "%atmo_applet_heap_size%"=="0" echo Taille réservée aux homebrews en mode applet: %atmo_applet_heap_reservation_size%.
		IF "%inverted_atmo_hbl_override_key%"=="Y" (
			echo Touche associée à l'activation du Homebrew Menu via l'album: toutes sauf %atmo_hbl_override_key%
		) else (
			echo Touche associée à l'activation du Homebrew Menu via l'album: %atmo_hbl_override_key%
		)
		echo Espace d'adresse pour le Homebrew Menu via l'album: %atmo_override_address_space%_bit
				IF "%inverted_atmo_hbl_override_any_app_key%"=="Y" (
			echo Touche associée à l'activation du Homebrew Menu en mode application: toutes sauf %atmo_hbl_override_any_app_key%
		) else (
			echo Touche associée à l'activation du Homebrew Menu en mode application: %atmo_hbl_override_any_app_key%
		)
		echo Espace d'adresse pour le Homebrew Menu en mode application: %atmo_override_any_app_address_space%_bit
		IF "%inverted_atmo_cheats_override_key%"=="Y" (
			echo Touche associée à l'activation des cheats: toutes sauf %atmo_cheats_override_key%
		) else (
			echo Touche associée à l'activation des cheats: %atmo_cheats_override_key%
		)
		IF "%inverted_atmo_layeredfs_override_key%"=="Y" (
			echo Touche associée à l'activation de Layeredfs: toutes sauf %atmo_layeredfs_override_key%
		) else (
			echo Touche associée à l'activation de Layeredfs: %atmo_layeredfs_override_key%
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
			echo Emunand activée avec les paramètres suivants:
			IF "!emummc_id!"=="" (
				echo ID de l'emunand par défaut.
			) else (
				echo ID de l'emunand: !emummc_id!
			)
			IF "!emummc_title!"=="" (
				echo Titre de l'emunand par défaut.
			) else (
				echo Titre de l'emunand: !emummc_title!
			)
			IF "!emummc_sector!"=="" (
				echo Aucun secteur de démarrage configuré.
			) else (
				echo Secteur de démarrage de l'emunand: !emummc_sector!
			)
			IF "!emummc_path!"=="" (
				echo Aucun chemin vers les fichiers de dump de la nand défini.
			) else (
				echo Chemin vers les fichiers de dump de la nand: !emummc_path!
			)
			IF "!emummc_nintendo_path!"=="" (
				echo Chemin du dossier Nintendo de l'emunand par défaut.
			) else (
				echo Chemin du dossier Nintendo de l'emunand: !emummc_nintendo_path!
			)
		) else (
			echo Emunand désactivée.
		)
		endlocal
	) else (
		echo Aucun fichier de configuration de l'emummc à copier.
	)
	echo.
)
IF /i "%copy_reinx_pack%"=="o" (
	IF /i "%reinx_enable_nogc_patch%"=="o" (
		echo Pack ReiNX avec le patche NOGC
	) else (
	echo Pack ReiNX
	)
	IF NOT "%reinx_pass_copy_modules_pack%"=="Y" (
		Echo Modules optionnels pour ReiNX:
		tools\gnuwin32\bin\sort.exe -n "%reinx_modules_profile_path%"
	) else (
		echo Aucun module optionnel à copier.
	)
	echo.
)
IF /i "%copy_sxos_pack%"=="o" (
	IF /i "%copy_payloads%"=="o" (
		echo Pack SX OS avec copie de payloads des autres CFWs sélectionnés à la racine de la SD pour être lancés via le SX Loader
	) else (
		echo Pack SX OS
	)
	IF /i "%remove_sx_autoloader%"=="o" (
		echo Le module SX-Autoloader sera supprimé.
	) else (
		echo Le module SX-Autoloader sera utilisé.
	)
	IF NOT "%sxos_pass_copy_modules_pack%"=="Y" (
		Echo Modules optionnels pour SX OS:
		tools\gnuwin32\bin\sort.exe -n "%sxos_modules_profile_path%"
	) else (
		echo Aucun module optionnel à copier.
	)
	echo.
)
IF /i "%copy_memloader%"=="o" (
	echo Pack Memloader
	echo.
)
IF /i "%copy_emu%"=="o" (
	IF /i "%keep_emu_configs%"=="o" (
		echo Pack d'émulateurs avec concervation des fichiers de configurations de ceux-ci sur la SD
	) else (
		echo Pack d'émulateurs avec suppression des fichiers de configurations de ceux-ci sur la SD
	)
	echo.
)
echo.
echo Homebrews optionnels:
IF "%pass_copy_mixed_pack%"=="Y" (
	echo Aucun homebrew optionnel ne sera copié.
) else (
	tools\gnuwin32\bin\sort.exe -n "%mixed_profile_path%"
	tools\gnuwin32\bin\grep.exe -c "Tinfoil" <"%mixed_profile_path%" >templogs\tempvar.txt
	set /p temp_count=<templogs\tempvar.txt
)
IF NOT "%pass_copy_mixed_pack%"=="Y" (
	IF "%temp_count%"=="1" (
		echo Tinfoil sera copié, si vous n'avez pas une version de SX OS payante valide pour la console il ne sera pas possible de lancer Tinfoil via Hekate et le lancement d'Atmosphere via les configurations pourrait être impossible ^(Tinfoil supprime le dossier "atmosphere\kips" et le fichier "bootloader\patch.ini"^), pour lancer Atmosphere vous devrez passer par le payload Fusee-primary.
	)
)
echo.
IF /i "%copy_emu%"=="o" (
	echo émulateurs:
	IF "%pass_copy_emu_pack%"=="Y" (
		echo Aucun émulateur ne sera copié.
	) else (
		tools\gnuwin32\bin\sort.exe -n "%emu_profile_path%"
	)
	IF /i "%update_retroarch%"=="o" (
		echo RetroArch sera mis à jour.
	) else (
		echo RetroArch ne sera pas mis à jour.
	)
	echo.
)
echo Overlays:
IF "%pass_copy_overlays_pack%"=="Y" (
	echo Aucun overlay ne sera copié.
) else (
	tools\gnuwin32\bin\sort.exe -n "%overlays_profile_path%"
)
echo.
echo Modules Salty-nx:
IF "%pass_copy_salty-nx_pack%"=="Y" (
	echo Aucun module Salty-nx ne sera copié.
) else (
	tools\gnuwin32\bin\sort.exe -n "%salty-nx_profile_path%"
)
echo.
IF "%copy_cheats%"=="Y" (
	echo Cheats:
	IF "%copy_all_cheats_pack%"=="Y" (
		echo La base de données des cheats sera entièrement copiée.
	) else (
		echo Profile de cheats choisi: %cheats_profile_name%
	)
	IF /i "%atmosphere_enable_cheats%"=="o" (
		echo Les cheats pour Atmosphere seront copiés.
	) else (
		echo Les cheats pour Atmosphere ne seront pas copiés.
	)
	IF /i "%sxos_enable_cheats%"=="o" (
		echo Les cheats pour SX OS seront copiés.
	) else (
		echo Les cheats pour SX OS ne seront pas copiés.
	)
	echo.
)
IF /i NOT "%sd_folder_structure_to_copy_choice%"=="o" (
	echo Aucun dossier personnalisé ne sera copié.
) else IF NOT EXIST "%sd_folder_structure_to_copy_path%\*.*" (
	echo Le dossier "%sd_folder_structure_to_copy_path%" n'existe pas, la copie de ce dossier ne se fera donc pas.
) else (
	echo Le contenu du dossier "%sd_folder_structure_to_copy_path%" sera copié à la racine de la SD.
)
IF "%profile_selected%"=="" (
	echo.
	IF /i "%sx_core_lite_chip%"=="o" (
		IF /i "%mariko_console%"=="o" (
			echo Puce SX Core/Lite présente sur console Mariko.
		) else (
			echo Puce SX Core/Lite présente sur console Erista.
		)
	) else (
	echo Puce SX Core/Lite non présente.
	)
	IF "%sx_gear_copy%"=="Y" (
	echo Les fichiers du SX Gear seront copiés pour lancer le payload nommé "payload.bin" situé à la racine de la SD.
	) else (
	echo Les fichiers du SX Gear ne seront pas copiés.
	)
)
echo.
IF /i "%del_files_dest_copy%"=="1" echo Attention: Les fichiers de tous les CFWs seront réinitialisé avant la copie, dossier "titles" de ceux-ci inclus.
IF /i "%del_files_dest_copy%"=="2" echo Attention: Les fichiers de la SD seront intégralement supprimés avant la copie.
IF /i "%del_files_dest_copy%"=="0" echo Les fichiers de la SD seront concervés et seul les fichiers mis à jour seront remplacés.
goto:eof