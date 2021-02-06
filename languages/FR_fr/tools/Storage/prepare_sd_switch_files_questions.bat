goto:%~1

:display_title
title Questions pour la préparation d'une SD %this_script_version2% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:launch_manual_choice
echo Préparation des fichiers à copier sur la SD
echo.
set /p launch_manual=Souhaitez-vous lancer la page d'information sur se qui peut être copié ^(vivement conseillé^)? ^(%lng_yes_choice%/%lng_no_choice%^):
goto:eof

:copy_atmosphere_pack_choice
set /p copy_atmosphere_pack=Souhaitez-vous copier le pack pour lancer Atmosphere via le payload Fusee-primary d'Atmosphere ^(CFW Atmosphere complet^) ou via Hekate ^(pack Kosmos^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_nogc_patch_choice
echo Souhaitez-vous activer le patch NOGC pour Atmosphere  ^(firmware 4.0.0 et supérieur^)?
echo Ce patch est utile pour ceux ayant mis à jour avec la méthode ChoiDuJour à partir du firmware 3.0.2 et inférieur et ne voulant pas que le firmware du port cartouche soit mis à jour, permettant ainsi le downgrade en-dessous de la version 4.0.0 sans perdre l'usage du port cartouche.
echo Attention,, si un firmware supérieur au 4.0.0 est chargé une seule fois par le bootloader de Nintendo ^(démarrage classique^) ou sans ce patche, le firmware du port cartouche sera mis à jour et donc l'activation de ce patch sera inutile.
set /p atmosphere_enable_nogc_patch=Souhaitez-vous activer le patch nogc? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_choice
set /p atmosphere_manual_config=Souhaitez-vous régler manuellement les options d'Atmosphere? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_copy_cheats_choice
set /p atmosphere_enable_cheats=Souhaitez-vous copier les cheats pour Atmosphere ^(utilisable avec le homebrew EdiZon^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:reinx_warning_if_atmosphere_chosen
echo copie du pack  ReiNX?
echo Attention: Vous avez choisi la copie du pack Atmosphere, si vous êtes en firmware 7.0.0 ou supérieur et si vous choisissez de copier aussi le pack ReiNX, Atmosphere ne sera plus lançable via son payload dédié "Fusee Primary", il faudra donc le lancer via Kosmos et les configurations de Hekate pour l'utiliser.
goto:eof

:copy_reinx_pack_choice
set /p copy_reinx_pack=Souhaitez-vous copier le pack pour lancer ReiNX? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:reinx_nogc_patch_choice
	echo Souhaitez-vous activer le patch NOGC pour ReiNX ^(firmware 4.0.0 et supérieur^)?
	echo Ce patch est utile pour ceux ayant mis à jour avec la méthode ChoiDuJour à partir du firmware 3.0.2 et inférieur et ne voulant pas que le firmware du port cartouche soit mis à jour, permettant ainsi le downgrade en-dessous de la version 4.0.0 sans perdre l'usage du port cartouche.
	echo Attention,, si un firmware supérieur au 4.0.0 est chargé une seule fois par le bootloader de Nintendo ^(démarrage classique^) ou sans ce patche, le firmware du port cartouche sera mis à jour et donc l'activation de ce patch sera inutile.
	set /p reinx_enable_nogc_patch=Souhaitez-vous activer le patch nogc? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:copy_memloader_pack_choice
set /p copy_memloader=Souhaitez-vous copier les fichiers nécessaire à Memloader pour monter la SD, la partition EMMC, la partition Boot0 ou la partition Boot1 sur un PC en lançant simplement le payload de Memloader? ^(Si la copie de SXOS a été souhaité, le payload sera aussi copié à la racine de la SD pour pouvoir le lancer grâce au payload de SXOS^) ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:copy_sxos_pack_choice
set /p copy_sxos_pack=Souhaitez-vous copier le pack pour lancer SXOS? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:sxos_remove_sx_autoloader
set /p remove_sx_autoloader=Souhaitez-vous supprimer le module SX-Autoloader ^(seul le module sera supprimé, pas le cache de celui-ci s'il existe^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:sxos_copy_selected_payloads_sd_root_choice
set /p copy_payloads=Souhaitez-vous copier les fichiers de payloads des fonctions choisis précédemment à la racine de la SD pour être compatible avec le lancement de payloads du payload SX_Loader? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:sxos_cheats_copy_choice
set /p sxos_enable_cheats=Souhaitez-vous copier les cheats pour SX OS ^(utilisable avec le ROMMENU de SX OS^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:copy_emulators_pack_choice
set /p copy_emu=Souhaitez-vous copier le pack d'émulateurs? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:emulators_kip_configs_choice
set /p keep_emu_configs=Souhaitez-vous concerver vos anciens fichiers de configurations d'émulateurs? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:emulators_profile_select_begin
echo Sélection du profile pour la copie des émulateurs:
goto:eof

:emulators_profile_all
echo %temp_count%: Tous les émulateurs.
goto:eof

:emulators_profile_choice
echo 0: Accéder à la gestion des profiles d'émulateurs.
echo Tout autre choix: Ne copier aucun des émulateurs.
echo.
set /p emu_profile=Choisissez un profile d'émulateurs: 
goto:eof

:retroarch_update_choice
set /p update_retroarch=Souhaitez-vous mettre à jour Retroarch avant la copie de celui-ci sur la SD ^(doit être fait au moins une fois pour pouvoir le copier^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:homebrews_profile_choice_begin
echo Sélection du profile pour la copie des homebrews optionnels:
goto:eof

:homebrews_profile_all
echo %temp_count%: Tous les homebrews optionnels.
goto:eof

:homebrews_profile_choice
echo 0: Accéder à la gestion des profiles de homebrews.
echo Tout autre choix: Ne copier aucun des homebrews optionnels.
echo.
set /p mixed_profile=Choisissez un profile de homebrews: 
goto:eof

:overlays_profile_choice_begin
echo Sélection du profile pour la copie des overlays:
goto:eof

:overlays_profile_all
echo %temp_count%: Tous les overlays.
goto:eof

:overlays_profile_choice
echo 0: Accéder à la gestion des profiles d'overlays.
echo Tout autre choix: Ne copier aucun des overlays.
echo.
set /p overlays_profile=Choisissez un profile d'overlays: 
goto:eof

:salty-nx_profile_choice_begin
echo Sélection du profile pour la copie des modules Salty-nx:
goto:eof

:salty-nx_profile_all
echo %temp_count%: Tous les modules Salty-nx.
goto:eof

:salty-nx_profile_choice
echo 0: Accéder à la gestion des profiles de modules Salty-nx.
echo Tout autre choix: Ne copier aucun des modules Salty-nx.
echo.
set /p salty-nx_profile=Choisissez un profile de modules Salty-nx: 
goto:eof

:cheats_profile_choice_begin
echo Sélection du profile pour la copie des cheats:
goto:eof

:cheats_profile_choice
echo 0: Accéder à la gestion des profiles de cheats.
echo Tout autre choix: Copier tous les cheats de la base de données.
echo.
set /p cheats_profile=Choisissez un profile de cheats: 
goto:eof

:define_sd_folder_structure_to_copy_choice
set /p sd_folder_structure_to_copy_choice=Souhaitez-vous copier le contenu d'un dossier de votre choix à la racine de la SD? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:define_sd_folder_structure_to_copy_path
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier dont le contenu sera copié à la racine de la SD"
goto:eof

:sd_folder_structure_to_copy_path_dir_not_exist_error
echo Le répertoire n'existe pas, veuillez réessayer.
goto:eof

:del_files_dest_copy_choice
echo Suppression de données de la SD:
echo 1: Remettre les données de tous les CFWs à zéro sur la SD ^(supprimera les thèmes, configurations personnels, mods de jeux car les dossiers "titles" ^(ou "contents" pour Atmosphere^) seront remis à zéro... donc bien sauvegarder vos données personnelles si vous souhaitez les concerver^)?
echo 2: Supprimer toutes les données de la SD?
echo 0: Copier normalement les fichiers sans supprimer de données de la SD?
echo.
set /p del_files_dest_copy=Faites votre choix: 
goto:eof

:bad_choice
echo Choix inexistant.
goto:eof

:canceled
echo Opération annulée.
goto:eof

:confirm_script_settings
set /p confirm_copy=Souhaitez-vous confirmer ceci? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:modules_profile_choice_begin
echo Sélection du profile pour la copie des modules optionnels du CFW %~2:
goto:eof

:modules_profile_all
echo %temp_count%: Tous les modules ^(non recommandé^).
goto:eof

:modules_profile_choice
echo 0: Accéder à la gestion des profiles de modules.
echo Tout autre choix: Ne copier aucun des modules.
echo.
set /p modules_profile=Choisissez un profile de modules: 
goto:eof

:atmosphere_manual_config_intro
echo Configuration manuelle d'Atmosphere:
goto:eof

:atmosphere_manual_config_upload_param_choice
set /p atmo_upload_enabled=Activer l'upload d'infos vers les serveurs Nintendo ^(non recommandé^): ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_usb3_param_choice
set /p atmo_usb30_force_enabled=Activer l'USB 3 pour les homebrews ^(peut causer des problèmes^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_nro-restrict_param_choice
set /p atmo_ease_nro_restriction=Activer les restrictions NRO ^(non recommandé^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_fatal-reboot_interval_param_choice
set /p atmo_fatal_auto_reboot_interval=Temps à partir duquel la console redémarrera automatiquement en cas de crash ^(0 pour attendre indéfiniement jusqu'à l'appuie d'une touche par l'utilisateur^) ^(temps en milisecondes^): 
goto:eof

:bad_value
echo Valeur incorrecte.
goto:eof

:atmosphere_manual_config_fatal-reboot-interval_param_too_low_error
echo Cette valeur ne peut être inférieure à 10.
goto:eof

:atmosphere_manual_config_reboot-method_param_choice
echo Comment doit redémarrer la console lorsque le bouton "Redémarrer" du menu de celle-ci est utilisé?
echo 1: Redémarrer le payload "atmosphere/reboot_to_payload.bin" de la SD ^(recommandé^).
echo 2: Redémarrer en mode RCM.
echo 3: Redémarrer normalement.
echo.
set /p atmo_power_menu_reboot_function=Faites votre choix: 
goto:eof

:empty_value_error
echo Cette valeur ne peut être vide.
goto:eof

:atmosphere_manual_config_cheats-default-state_param_choice
set /p atmo_dmnt_cheats_enabled_by_default=Etat des cheats activer par défaut ^(si désactivé, ils devront être activé manuellement via EdiZon par exemple^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_cheats-save-state_param_choice
set /p atmo_dmnt_always_save_cheat_toggles=Activer la sauvegarde automatique de l'état des cheats ^(si désactivé, l'état des cheats sera sauvegardé seulement si un fichier de sauvegarde de ces étas est présent^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_hbl_bis_write
set /p atmo_enable_hbl_bis_write=Activer l'écriture sur la partition bis ^(non recommandé^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_hbl_cal_read
set /p atmo_enable_hbl_cal_read=Activer la lecture de la partition CAL0 ^(non recommandé^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_gamesave-on-sd_param_choice
set /p atmo_fsmitm_redirect_saves_to_sd=Activer la redirrection des sauvegardes vers la SD ^(expérimental donc non recommandé^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_deprecated_hid_mitm_param_choice
set /p atmo_enable_deprecated_hid_mitm=Activer l'ancienne méthode de détection des boutons pour les homebrews ^(non recommandé sauf si vous utilisez encore des vieux homebrews^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_am_debug_mode_param_choice
set /p atmo_enable_am_debug_mode=Activer le mode débogage ^(non recommandé sauf si vous êtes un développeur^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_dns_mitm_param_choice
set /p atmo_enable_dns_mitm=Activer le service DNS_mitm ^(recommandé, activé par défaut^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_add_defaults_to_dns_hosts_param_choice
set /p atmo_add_defaults_to_dns_hosts=Activer les redirections par défaut en plus des fichiers de configuration du service DNS_mitm ^(recommandé, activé par défaut^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_enable_dns_mitm_debug_log_param_choice
set /p atmo_enable_dns_mitm_debug_log=Activer le mode débogage du service DNS_mitm ^(non recommandé sauf si vous êtes un développeur^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:atmosphere_manual_config_applet-heap-size_param_choice
set /p atmo_applet_heap_size=Taille réservée au Homebrew Loader en mode applet, mettre à 0 pour utiliser la taille maximum est fortement recommandé ^(valeur réglée à 0 si laissé vide^): 
goto:eof

:atmosphere_manual_config_applet-heap-reservation-size_param_choice
set /p atmo_applet_heap_reservation_size=Taille réservée aux homebrews utilisés en mode applet, mettre cette valeur à 8000000 est fortement recommandé ^(valeur réglé à 8000000 si laissé vide^): 
goto:eof

:atmosphere_manual_config_buttons_functions_activation_infos
echo Configuration des boutons à maintenir pour activer ou non certaines fonctionnalités au lancement d'un jeu:
echo.
echo Il faudra entrer le bouton pour activer la fonction ou ajouter un "^!" devant le bouton pour que celui-ci la désactive.
echo Voici la liste des boutons possibles:
echo A, B, X, Y, L, R, ZL, ZR, LS, RS, SL, SR, +, -, DLEFT, DUP, DRIGHT, DDOWN
goto:eof

:atmosphere_manual_config_hbl_button_param_choice
set /p "atmo_hbl_override_key=Bouton de lancement du Homebrew Menu via l'album: "
goto:eof

:atmosphere_manual_config_hbl_adress_space_param_choice
set /p atmo_override_address_space=Espace d'adresse pour le homebrew menu via l'album en bit (39, 36 ou 32, 39 si laissé vide): 
goto:eof

:atmosphere_manual_config_hbl_app_button_param_choice
set /p "atmo_hbl_override_any_app_key=Bouton de lancement du Homebrew Menu en mode application: "
goto:eof

:atmosphere_manual_config_hbl_any_app_adress_space_param_choice
set /p atmo_override_any_app_address_space=Espace d'adresse pour le homebrew menu en mode application en bit (39, 36 ou 32, 39 si laissé vide): 
goto:eof

:value_not_accepted_error
echo Cette valeur ne peut être utilisée.
goto:eof

:atmosphere_manual_config_cheats_button_param_choice
set /p atmo_cheats_override_key=Bouton de lancement des cheats: 
goto:eof

:atmosphere_manual_config_layeredfs_button_param_choice
set /p atmo_layeredfs_override_key=Bouton de lancement de Layeredfs ^(mods de jeux par exemple^): 
goto:eof

:emummc_profile_choice_begin
echo Sélection du profile pour la copie de la configuration de l'emummc  du CFW %~2:
goto:eof

:emummc_profile_partition_sxos_and_atmosphere
echo %temp_count%: Emummc partagé avec l'emunand via partition de SXOS.
goto:eof

:emummc_profile_choice
echo 0: Accéder à la gestion des profiles d'emummc.
echo Tout autre choix: Ne pas copier de configuration d'emummc.
echo.
set /p emummc_profile=Choisissez un profile d'emummc: 
goto:eof