goto:%~1

:display_title
title Préparation d'une SD %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va vous permettre de préparer une carte SD pour le hack Switch en y installant les outils importants.
echo Pendant le script, les droits administrateur seront peut-être demandé.
echo.
echo ATTENTION: Si vous décidez de formater votre carte SD, toutes les données de celle-ci seront perdues. Sauvegardez les données importante avant de formater.
echo ATTENTION: Choisissez bien la lettre du volume qui correspond à votre carte SD car aucune vérification ne pourra être faites à ce niveau là.
echo.
echo Je ne pourrais être tenu pour responsable de quelque domage que se soit lié à l'utilisation de ce script ou des outils qu'il contient.
echo.
echo Vous pourrez trouver, à la racine de ce script, un dossier "sd_user".
echo Le contenu de ce dossier sera copié à la racine de votre SD et sera toujours copié en dernier, vous pouvez donc mettre vos fichiers de configurations personnelles comme votre licence SX OS, des paramètres spécifiques pour Hekate... bref se que vous voulez.
echo Par exemple, pour utiliser un fichier personnel pour Hekate, vous devrez créer un dossier "bootloader" et y mettre votre fichier "hekate_ipl.ini" pour que celui-ci soit pris en compte.
echo Aucun support ne sera donné si vous utilisez cette fonctionnalité, ne l'utilisez que si vous comprenez se que vous faites.
goto:eof

:no_disk_found_error
echo Aucun disque compatible trouvé. Que souhaitez-vous faire:
echo.
echo r: Recharger la liste de disques?
echo d: Sélectionner un dossier vers lequel copier le pack.
echo Tout autre choix: Terminer le script.
echo.
set /p disk_not_finded_choice=Faites votre choix: 
goto:eof

:disk_list_begin
echo Liste des disques:
goto:eof

:disk_choice
set /p volume_letter=Entrez la lettre du volume de la SD que vous souhaitez utiliser, entrez "1" pour copier dans un dossier  ou entrez "0" pour quitter le script: 
goto:eof

:select_folder_choice
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier vers lequel copier les fichiers"
goto:eof

:disk_choice_empty_error
echo La lettre de lecteur ne peut être vide. Réessayez.
goto:eof

:disk_choice_char_error
echo Un caractère non autorisé a été saisie dans la lettre du lecteur. Recommencez.
goto:eof

:disk_choice_not_exist_error
echo Ce volume n'existe pas. Recommencez.
goto:eof

:disk_choice_not_in_list_error
echo Cette lettre de volume n'est pas dans la liste. Recommencez.
goto:eof

:disk_format_choice
set /p format_choice=Souhaitez-vous formater la SD ^(volume "%volume_letter%"^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:disk_format_type_choice
echo Quel type de formatage souhaitez-vous effectuer:
echo 1: EXFAT ^(la Switch doit avoir le support pour ce format d'installé^)?
echo 2: FAT32 ^(limité au fichier de moins de 4 GO^)?
echo Tout autre choix: Annule le formatage.
echo.
set /p format_type=Choisissez le type de formatage à effectuer: 
goto:eof

:disk_formating_begin
echo Formatage en cours...
goto:eof

:disk_formating_error
echo Un problème s'est produit pendant la tentative de formatage, le script va maintenant s'arrêter.
goto:eof

:disk_formating_success
echo Formatage effectué avec succès.
goto:eof

:disk_formating_fat32_not_admin_error
echo La demande d'élévation n'a pas été acceptée, le formatage est annulé.
goto:eof

:disk_formating_fat32_disk_used_error
echo Le formatage n'a pas été effectué.
echo Essayez d'éjecter proprement votre clé USB, réinsérez-là et relancez immédiatement ce script.
echo Vous pouvez également essayer de fermer toutes les fenêtres de l'explorateur Windows avant le formatage, parfois cela règle le bug.
echo.
echo Le script va maintenant s'arrêter.
goto:eof

:disk_formating_fat32_disk_not_exist_error
echo Le volume à formater n'existe pas. Vous avez peut-être débranché ou éjecté la carte SD durant ce script.
echo.
echo Le script va maintenant s'arrêter.
goto:eof

:disk_formating_fat32_unknown_error
echo Une erreur inconue s'est produite pendant le formatage.
echo.
echo Le script va maintenant s'arrêter.
goto:eof

:disk_formating_fat32_canceled_info
echo Le formatage a été annulé par l'utilisateur.
goto:eof

:sx_core_lite_chip_choice
set /p sx_core_lite_chip=La console est-elle équipée d'une puce SX Core/Lite? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:hwfly_copy_choice
set /p hwfly_copy=Souhaitez-vous copier le firmware de Spacecraft pour le mettre à jour sur la puce SX Core/Lite via le payload hwfly_toolbox? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:mariko_console_choice
set /p mariko_console=La console est-elle un modèle Mariko ^(numéro de série ne commençant pas par "XA"^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:sx_gear_force_copy
set /p sx_gear_copy=Souhaitez-vous copier les fichiers du SX Gear pour lancer Hekate au lieu de SXOS au démarrage de la console ^(SXOS ne sera plus utilisable^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:sx_chip_clean_up_warning
echo Attention: Sur une console Erista équipée d'une puce SX Core utilisant SXOS, si vous souhaitez lancer un payload veuillez avant tout maintenir le bouton "vol+" de la console durant le démarrage de celle-ci jusqu'à l'apparition du menu de SXOS puis allez dans "Options", "SX Core", "Clean up" et confirmer l'action puis lancez le payload souhaité ^(Hekate recommandé pour ensuite lancer d'autres payloads^).
echo Cette procédure est à refaire à chaque fois que la console a été éteinte et que la puce démarre celle-ci.
goto:eof

:sx_launcher_use_choice
set /p sx_launcher_use=Utilisez-vous un dongle ou une puce autre qu'un SX Core/Lite lançant directement SXOS? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:firmware_copy_choice
set /p firmware_copy=Souhaitez-vous copier un firmware sur la SD? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:firmware_preparation_error
echo Aucun firmware sélectionné ou une erreur s'est produite durant la préparation du firmware.
goto:eof

:general_profile_select_begin
echo Sélection du profile général:
goto:eof

:general_profile_select_atmosphere_and_sxos_recommanded_profile_display
echo !count_default_profile!: Profile Atmosphere + SXOS + Memloader recommandé, ne contient pas le patch NOGC et met juste à jour les fichiers existant de la SD donc ce profile n'est pas toujours adapté.
goto:eof

:general_profile_select_atmosphere_recommanded_profile_display
echo !count_default_profile!: Profile Atmosphere recommandé, ne contient pas le patch NOGC et met juste à jour les fichiers existant de la SD donc ce profile n'est pas toujours adapté.
goto:eof

:general_profile_select_sxos_recommanded_profile_display
echo !count_default_profile!: Profile  SXOS recommandé,  met juste à jour les fichiers existant de la SD donc ce profile n'est pas toujours adapté.
goto:eof

:general_profile_choice
echo 0: Accéder à la gestion des profiles généraux.
echo E: Terminer le script sans préparer la SD.
echo Tout autre choix: Préparer la SD manuellement.
echo.
set /p general_profile=Choisissez un profile: 
goto:eof

:confirm_copy_choice
set /p confirm_copy=Souhaitez-vous confirmer ceci? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:canceled
echo Opération annulée.
goto:eof

:bad_choice
echo Choix inexistant.
goto:eof

:before_copy_error
echo Préparation de la SD annulée car une erreur inconnue est survenue, vérifiez que vous n'avez pas supprimer de profiles utilisés dans ce profile général.
echo Si le problème persiste, veuillez refaire ce profile.
goto:eof

:erase_fastcfwswitch_config_choice
set /p erase_fastcfwswitch_config=Souhaitez-vous remplacer votre fichier de configuration de l'overlay FastCFWswitch par celui du script? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:copying_begin
echo Copie en cours...
goto:eof

:copying_end
echo Copie terminée.
echo.
set /p prepare_another_sd=Souhaitez-vous relancer la préparation d'une SD depuis le début? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:homebrew_should_be_associed_with_at_least_one_cfw_error
echo Le homebrew !temp_homebrew! ne peut être copié si aucun CFW n'y est associé pendant la préparation de la SD car il contient des éléments liés aux différents CFW. Pour copier correctement ce homebrew, vous devez sélectionner un ou plusieurs CFW durant la préparation de la SD ou la SD doit contenir le répertoire "contents" ou "titles" associé aux CFWs installés sur la SD.
goto:eof

:config_nes_classic_choice
echo Attention, il semble qu'aucune configuration de l'émulateur Nes Classic Edition n'ait eu lieu précédemment, celui-ci sera donc inutilisable en l'état.
echo Vous pouvez configurer l'émulateur via les "autres fonctions" du script puis refaire la préparation de la SD ou choisir de le configurer immédiatement.
set /p config_nes_classic=Souhaitez-vous lancer le script de configuration de l'émulateur? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:config_nes_classic_error
echo Il semble que la configuration de l'émulateur Nes Classic Edition ait échouée, il ne sera donc pas copié.
goto:eof

:config_snes_classic_choice
echo Attention, il semble qu'aucune configuration de l'émulateur Snes Classic Edition n'ait eu lieu précédemment, celui-ci sera donc inutilisable en l'état.
echo Vous pouvez configurer l'émulateur via les "autres fonctions" du script puis refaire la préparation de la SD ou choisir de le configurer immédiatement.
set /p config_snes_classic=Souhaitez-vous lancer le script de configuration de l'émulateur? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:config_snes_classic_error
echo Il semble que la configuration de l'émulateur Snes Classic Edition ait échouée, il ne sera donc pas copié.
goto:eof

:retroarch_not_exist_error
echo RetroArch ne peut être installé car il est introuvable, utilisez le gestionnaire de mises à jour lorsque demandé lors de la préparation de la SD pour le mettre en place.
goto:eof

:sxos_force_disable_stealth_mode_for_uLaunch
rem echo Pour utiliser le module uLaunch avec SX OS, le Stealth Mode de SX OS a été désactivé donc veuillez ne pas vous connecter à internet sans une protection comme Incognito et/ou 90dns de configuré.
echo Le module uLaunch n'est pour l'instant pas utilisable officiellement avec SX OS donc il ne sera pas copié pour ce CFW.
goto:eof

:choidujournx_alert_message
echo Attention, veuillez ne pas utiliser ChoiDuJour-NX avec une console Mariko sous peine de brick.
goto:eof

:miiport_alert_message
echo N'oubliez pas de remplacer le texte du fichier "%volume_letter%\MiiPort\qrkey.txt" par la clé "Mii QR key".
goto:eof

:module_not_exist_warning
echo Module "!temp_module!" non copié et supprimé du profile.
goto:eof

:homebrew_not_exist_warning
echo Homebrew "!temp_homebrew!" non copié et supprimé du profile.
goto:eof

:overlay_not_exist_warning
echo Overlay "!temp_overlay!" non copié et supprimé du profile.
goto:eof

:salty-nx_not_exist_warning
echo Module Salty-NX "!temp_salty-nx!" non copié et supprimé du profile.
goto:eof

:emulator_not_exist_warning
echo Emulateur "!temp_emulator!" non copié et supprimé du profile.
goto:eof

:cheat_not_exist_warning
echo Cheat "!temp_cheat!" non copié et supprimé du profile.
goto:eof