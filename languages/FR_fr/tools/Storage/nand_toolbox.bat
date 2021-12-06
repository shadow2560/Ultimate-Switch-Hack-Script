goto:%~1

:display_title
title Boîte à outil pour la Nand %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Bienvenue dans la boîte à outils pour la nand.
echo.
echo Ici, vous pouvez effectuer un grand nombre d'actions sur la nand de la Switch ou sur un fichier de nand déjà dumpé.
echo Si vous n'avez pas lancé l'Ultimate Switch Hack Script en tant qu'administrateur ^(Windows 8 et versions supérieurs^), toutes les fonctionnalités permettant d'intervenir sur un disque physique seront inutilisables.
::echo.
echo Note: Pour sélectionner un dump splittés, il suffit de sélectionner le premier fichier de celui-ci.
echo.
echo Attention: Les opérations effectuées par ces fonctions peuvent intervenir sur la nand de votre console, vous êtes seul responsable de se que vous faites.
goto:eof

:first_action_choice
echo Boîte à outils de la nand
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: obtenir des infos sur un fichier de dump ou sur une partie de la nand de la console?
echo 2: Dumper la nand ou une partition de la nand de la console, copier un fichier ou extraire une partition d'un fichier de dump?
echo 3: Restaurer la nand ou une partition de la nand de la console sur la console ou dans un fichier de dump?
echo 4: Créer une emunand sur une SD?
echo 5: Activer/désactiver l'auto-RCM d'une partition BOOT0 ^(ne pas utiliser sur les consoles Erista patchées ou Mariko^)?
echo 6: Installer  le driver EXFAT d'un firmware spécifique?
echo 7: Supprimer les informations d'identification de la console dans PRODINFO ^(fonction identique à Incognito^) ^(ne pas utiliser sur les consoles Mariko^)?
echo 8: Joindre un dump de la rawnand fait en plusieurs parties, par exemple un dump fait via Hekate sur une SD formatée en FAT32?
echo 9: Spliter un dump de la rawnand?
echo 10: Créer un fichier à partir d'un dump complet de la nand qui pourra ensuite être utilisé pour la création d'une Emunand via une partition dédiée de la SD?
echo 11: Extraire les fichiers d'un dump de nand à partir d'un fichier de la partition de l'emunand?
echo 12: Déchiffrer un dump ou une partition d'une rawnand?
echo 13: Chiffrer un dump ou une partition d'une rawnand?
echo 14: Utiliser Ninfs pour monter un fichier de dump de la rawnand?
echo 15: Changer la taille de la partition USER d'une RAWNAND ou d'une FULL NAND?
echo 16: Créer un fichier BOOT0 pour réparrer une erreurs sur les keyblobs ^(ne pas utiliser sur les consoles Mariko^)?
echo 17: Brute forcer les bis_keys?
echo 18: Fonctions de débrickage de la RAWNAND?
echo 0: Charger une partie de la nand d'une console via USB avec Memloader?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:unbrick_menu_choice
echo Menu de débrickage de la RAWNAND
echo.
echo Vous devez installer le driver Dokan avant d'effectuer les actions de ce menu, ceci ne sera à faire qu'une seule fois.
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Charger la rawnand d'une console via USB avec Memloader?
echo 2: Forcer le passage de l'écran de la première configuration de la console?
echo 3: Supprimer le contrôle parental?
echo 4: Réinitialiser la RAWNAND?
echo 5: Créer un firmware type ChoiDuJour ou EmmcHaccGen?
echo 6: Flasher un firmware créé par ChoiDuJour ou EmmcHaccGen sur une RAWNAND?
echo 0: Installer le driver Dokan?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:nand_infos_begin
echo Sur quelle nand souhaitez-vous avoir des infos?
goto:eof

:nand_choice
echo 0: Fichier de dump?
echo Aucune valeur: Revenir au menu précédent?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:dump_not_exist_error
echo Le fichier de dump n'a pas été indiqué ou le numéro de disque n'existe pas.
goto:eof

:biskeys_file_selection_empty_authorised
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous indiquer un fichier de Bis keys pour avoir plus d'infos sur la nand? ^(%lng_yes_choice%/%lng_no_choice%^): "
IF %errorlevel% EQU 2 goto:eof
IF %errorlevel% EQU 1 (
	%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier contenant les Bis keys" "templogs\tempvar.txt"
	set /p biskeys_file_path=<"templogs\tempvar.txt"
	IF "!biskeys_file_path!"=="" (
		echo Fichier Bis keys non indiqué, vous n'obtiendrez donc pas plus d'infos sur la nand.
		pause
	) else (
		set biskeys_param=-keyset "!biskeys_file_path!"
	)
)
goto:eof

:dump_input_begin
echo Choisissez le support depuis lequel faire le dump:
goto:eof

:dump_output_folder_choice
echo Vous allez devoir sélectionner le dossier vers lequel extraire le dump.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier de sortie"
goto:eof

:dump_output_folder_empty_error
echo Le répertoire pour extraire le dump ne peut être vide, la fonction va être annulée.
goto:eof

:zip_param_choice
set /p zip_param=Souhaitez-vous compresser le fichier en sortie dans un fichier zip? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:dump_erase_existing_file_choice
set /p erase_output_file=Ce dossier contient déjà un fichier de ce type de dump, souhaitez-vous vraiment continuer en écrasant le fichier existant ^(si oui, le fichier sera supprimé juste après ce choix^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:canceled
echo Opération annulée par l'utilisateur.
goto:eof

:exfat_driver_begin
echo Cette fonction permet de mettre en place le driver EXFAT d'un firmware spécifique sur un dump de nand.
echo Durant le processus, les clés de la console seront requises.
goto:eof

:firmware_preparation_error
echo Aucun firmware choisi ou une erreur s'est produite durant la création du firmware.
goto:eof

:exfat_restaure_output_begin
echo Choisissez le support vers lequel restaurer le driver EXFAT:
goto:eof

:restaure_input_file_begin
echo Vous allez devoir sélectionner le fichier depuis lequel restaurer, quitter la sélection de fichier sans rien sélectionner pour revenir au menu précédent.
goto:eof

:restaure_input_empty_error
echo Le fichier de dump n'a pas été indiqué, retour au menu précédent.
goto:eof

:restaure_output_begin
echo Choisissez le support vers lequel restaurer le dump:
goto:eof

:restaure_input_dump_invalid_error
echo Le dump en entrée semble être corrompu ou n'est pas un dump valide, par mesure de sécurité le script va s'arrêter.
goto:eof

:restaure_output_dump_invalid_error
echo Le dump en sortie semble être corrompu ou n'est pas un dump valide, par mesure de sécurité le script va s'arrêter.
goto:eof

:restaure_try_partition_on_other_than_rawnand_error
echo Impossible de restaurer une partition spécifique si le type de nand en sortie n'est pas "RAWNAND", l'opération est annulée.
goto:eof

:restaure_partitions_not_match_error
echo Le type de partition ne semble pas correspondre avec le fichier choisi pour restaurer. Par mesure de sécurité, l'opération est annulée.
goto:eof

:restaure_input_and_output_type_not_match_error
echo Le type de la nand en entrée ne correspond pas avec le type de la nand en sortie, il n'est pas possible de continuer.
goto:eof

:emunand_create_input_begin
echo Ce script permet de créer une emunand sur une carte SD à partir de fichiers de dump de la nand.
echo.
echo Choisissez la RAWNAND ou la FULLNAND à utiliser:
goto:eof

:emunand_create_nand_type_error
echo Le type de la nand doit être RAWNAND ou FULLNAND.
goto:eof

:select_boot0_file
echo Vous allez devoir sélectionner le fichier BOOT0 associé à votre RAWNAND.
goto:eof

:emunand_create_boot1_dump_not_exist_error
echo Le fichier BOOT0 doit être renseigné.
goto:eof

:select_boot0_file_invalid_error
echo Le fichier doit être un fichier BOOT0 valide.
goto:eof

:select_boot1_file
echo Vous allez devoir sélectionner le fichier BOOT1 associé à votre RAWNAND.
goto:eof

:emunand_create_boot1_dump_not_exist_error
echo Le fichier BOOT1 doit être renseigné.
goto:eof

:select_boot1_file_invalid_error
echo Le fichier doit être un fichier BOOT1 valide.
goto:eof

:emunand_create_type_choice
echo Quel type d'emunand souhaitez-vous créer?
echo 1: Emunand via partition ^(compatible Atmosphere et SX OS^) ^(toutes les données de la SD seront supprimées^)?
echo 2: Emunand via fichiers compatible Atmosphere?
echo 3: Emunand via fichiers compatible SX OS?
echo.
set /p emunand_type=Faites votre choix: 
goto:eof

:select_emunand_type_invalid_error
echo Choix du type d'emunand incorrect.
goto:eof

:no_disk_found_error
echo Aucun disque compatible trouvé.
	echo.
set /p disk_not_finded_choice=Souhaitez-vous tenter de recharger la liste de disques ^(si non, le script se terminera^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:emunand_output_choice_intro
echo Sélectionner le disque sur lequel créé l'emunand:
goto:eof

:emunand_output_choice
echo 0: Recharger la liste des périphériques?
echo Aucune valeur: Revenir au menu précédent?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:disk_not_exist_error
echo Erreur de sélection du disque.
goto:eof

:emunand_create_action_error
echo Une erreur s'est produite durant la création de l'emunand.
goto:eof

:emunand_create_action_success
echo Création de l'emunand effectuée avec succès.
goto:eof

:autorcm_dump_choice_begin
echo Sur quelle partition BOOT0 souhaitez-vous travailler?
goto:eof

:autorcm_choice
echo Que souhaitez-vous faire:
echo 1: Activer l'auto-RCM?
echo 2: Désactiver l'auto-RCM?
echo Tout autre choix: Annuler le processus.
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:autorcm_nand_type_must_be_boot0_error
echo Le type de la nand doit être BOOT0, le processus ne peut continuer.
goto:eof

:autorcm_nand_soc_must_be_erista_error
echo Le type de SoC doit être Erista, le processus ne peut continuer.
goto:eof

:autorcm_action_error
	echo Une erreur inconnue semble s'être produite pendant la tentative d'activation/désactivation de l'auto-RCM.
	echo Vérifiez que le script a bien été exécuté en tant qu'administrateur et que le fichier ou le périphérique est bien accessible. Dans le cas d'un fichier, vérifiez également qu'il n'est pas en lecture seul.
goto:eof

:autorcm_enabled_success
echo Auto-RCM activé.
goto:eof

:autorcm_disabled_success
echo Auto-RCM désactivé.
goto:eof

:decrypt_input_begin
echo Sélection de la nand à déchiffrer.
goto:eof

:decrypt_rawnand_not_selected_error
echo Vous devez sélectionner un fichier de rawnand pour pouvoir le déchiffrer.
goto:eof

:biskeys_file_not_selected_error
echo Aucun fichier de Bis keys sélectionné, impossible de continuer.
goto:eof

:decrypt_biskeys_not_valid_error
echo Une erreur s'est produite pendant le test de déchiffrement de la nand, certaines Bis keys sont peut-être incorrectes. De fait, le script ne peut continuer.
goto:eof

:decrypt_verif_encrypted_or_not_error
echo La nand ou la partition sélectionnée semble déjà déchiffrée, impossible de continuer.
goto:eof

:encrypt_input_begin
echo Sélection du fichier de la nand à chiffrer, quitter la sélection de fichier sans rien sélectionner pour revenir au menu précédent.
goto:eof

:encrypt_input_empty_error
echo Aucun fichier à chiffrer sélectionné, retour au menu précédent.
goto:eof

:encrypt_rawnand_not_selected_error
echo Vous devez sélectionner un fichier de rawnand pour pouvoir le chiffrer.
goto:eof

:encrypt_verif_encrypted_or_not_error
echo La nand ou la partition sélectionnée semble déjà chiffrée, impossible de continuer.
goto:eof

:incognito_input_begin
echo Sélection de la rawnand ou de la partition PRODINFO sur laquelle travailler pour appliquer Incognito
goto:eof

:incognito_nand_type_error
echo L'application de Incognito sur le type de nand sélectionner est impossible, le script ne peut donc pas continuer.
goto:eof

:incognito_biskeys_not_valid_error
echo Erreur lors de la vérification du fichier des Bis keys, Incognito ne peut donc être appliqué.
goto:eof

:incognito_action_error
echo Une erreur inconnue s'est produite durant la tentative d'application d'Incognito sur le fichier souhaité.
goto:eof

:incognito_action_success
echo Incognito a été appliqué avec succès sur le fichier sélectionné.
goto:eof

:incognito_prodinfo_backup_moved
IF %temp_count% EQU 0 (
	echo La sauvegarde de la partition PRODINFO a été déplacée dans le dossier "%base_folder_path_of_a_file_path%" et nommée "PRODINFO.backup".
) else (
	echo La sauvegarde de la partition PRODINFO a été déplacée dans le dossier "%base_folder_path_of_a_file_path%" et nommée "PRODINFO.backup%temp_count%".
)
goto:eof

:resize_user_part_input_begin
echo Choisir une RAWNAND ou une FULL NAND à partir de laquelle redimensionner la partition USER
goto:eof

:resize_user_part_bad_input_choice
echo La partition USER de ce type de nand ne peut être modifié.
goto:eof

:resize_user_part_value_choice
set /p resize_user_partition_value=Définir la nouvelle taille de la partition en MB ou laisser vide pour annuler ^(la valeur ne peut être inférieur à 2000 et doit être un nombre entier^): 
goto:eof

:brute_force_input_begin
echo Cette fonction ne sert en réalité à rien car le traitement prend beaucoup trop de temps, c'est juste une fonction développée pour m'amuser. De plus les FULL DUMP ne sont pas supportées.
pause
echo.
echo Choisissez le support sur lequel utiliser le brute force:
goto:eof

:brute_force_output_folder_choice
echo Vous allez devoir sélectionner le dossier vers lequel extraire la clé.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier"
goto:eof

:brute_force_output_folder_empty_error
echo Le répertoire pour extraire la clé ne peut être vide, la fonction va être annulée.
goto:eof

:brute_force_erase_existing_file_choice
set /p erase_output_file=Ce dossier contient déjà un fichier de ce type de clé, souhaitez-vous vraiment continuer en écrasant le fichier existant ^(si oui, le fichier sera supprimé juste après ce choix^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:pass_first_config_screen__begin
echo Cette fonction permet de forcer le passage de la première configuration de la Switch, surtout utile pour ceux ayant un problème pour connecter les joycons à la console.
goto:eof

:partition_should_be_system_error
echo La nand doit inclure la partition SYSTEM.
goto:eof

:mounting_partition_error
echo Le montage de la partition a échoué, l'action va être annulée.
echo Ceci peut être dû au driver Dokan non installé sur le système.
echo Si le problème persiste, essayez de redémarrer l'ordinateur puis réexécuter cette action.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous installer le driver Dokan? ^(%lng_yes_choice%/%lng_no_choice%^): "
IF %errorlevel% EQU 1 (
	tools\NxNandManager\NxNandManager.exe --install_dokan
)
goto:eof

:pass_first_config_screen_save_modif_error
echo Une erreur s'est produite durant la modification du fichier permettant de passer le premier écran de configuration, l'action va être annulée.
goto:eof

:unmounting_partition_error
echo Une erreur s'est produite durant le démontage de la partition.
goto:eof

:pass_first_config_screen_save_modif_sucess
echo Le passage du premier écran de configuration a été effectué avec succès.
goto:eof

:del_parental_control_begin
echo Cette fonction permet de supprimer le contrôle parental.
goto:eof

:del_parental_control_error
echo Une erreur s'est produite durant la modification du fichier permettant de supprimer le contrôle parental, l'action va être annulée.
goto:eof

:del_parental_control_sucess
echo La suppression du contrôle parental a été effectué avec succès.
goto:eof

:reset_rawnand_begin
echo Cette fonction permet de réinitialiser une RAWNAND.
goto:eof

:nand_type_must_be_rawnand_error
echo La nand doit être un dump de nand complet.
goto:eof

:reset_rawnand_sucess
echo La réinitialisation de la RAWNAND a été effectué avec succès.
echo.
echo Pensez également a supprimer de la SD le dossier nintendo associé à la nand ^(par exemple si emunand SXOS le dossier sera le dossier "emutendo"^).
goto:eof

:apply_fw_package_on_rawnand_begin
echo Cette fonction permet de flasher un package créé via ChoiDuJour ou EmmcHaccGen sur une RAWNAND.
goto:eof

:package_folder_choice
echo Vous allez devoir sélectionner le dossier du package créé par ChoiDuJour ou EmmcHaccGen.
pause
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier du package ChoiDuJour ou EmmcHaccGen"
goto:eof

:package_folder_empty_error
echo Le dossier du package ne peut être vide.
goto:eof

:bad_package_folder_error
echo Le dossier choisi ne semble pas être un package ChoiDuJour ou EmmcHaccGen valide.
goto:eof

:package_flash_type_choice
echo Comment souhaitez-vous flasher le package:
echo 1: Flasher le package en supprimant les données de la nand?
echo 2: Flasher le package sans supprimer les données de la nand?
echo 3: Flasher seulement les fichiers BCPKG*?
echo Tout autre choix: Revenir au menu précédent?
echo.
set /p package_flash_type=Faites votre choix: 
goto:eof

:decrypt_biskeys_not_valid_warning
echo Attention: Une erreur s'est produite pendant le test de déchiffrement de la nand, certaines Bis keys sont peut-être incorrectes ou la nand a un problème. De fait, il n'est pas recommandé de flasher cette RAWNAND sur la console avant d'avoir résolu ce problème.
goto:eof

:apply_fw_package_on_rawnand_sucess
echo Le flash de la RAWNAND a été effectué avec succès.
echo.
IF "%package_type%"=="CDJ" (
	echo Attention: Pour le premier lancement du firmware, il sera probablement nécessaire d'appliquer le patch nocmac via Hekate. Si le logo Nintendo Switch n'apparait pas, appliquer ce patch peut régler le problème.
	echo.
)
IF "%package_flash_type%"=="1" (
	echo Pensez également a supprimer de la SD le dossier nintendo associé à la nand ^(par exemple si emunand SXOS le dossier sera le dossier "emutendo"^).
	echo.
)
echo Notez également que si vous avez flashé un firmware différent de celui de la RAWNAND, vous devrez flasher manuellement les partitions BOOT0 et BOOT1 associés à cette RAWNAND à l'aide des fichiers BOOT0.bin et BOOT1.bin contenu dans votre package ChoiDuJour ou EmmcHaccGen, par exemple en utilisant la fonction de restauration de nand dans le menu principal de la Nand Toolbox.
goto:eof

:bad_char_error
echo Un caractère non autorisé a été saisie.
goto:eof

:resize_user_part_define_greater_size_error
echo La taille de la nouvelle partition ne peut être inférieur à 2000.
goto:eof

:resize_user_partition_format_choice
set /p resize_user_partition_format=Souhaitez-vous formater la nouvelle partition USER? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:nand_file_select_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier de dump" "templogs\tempvar.txt"
goto:eof

:nand_choice_char_error
echo Un caractère non-autorisé a été saisie.
goto:eof

:biskeys_file_select_choice
echo Sélectionnez le fichier contenant les Bis keys à utiliser.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier contenant les Bis keys" "templogs\tempvar.txt"
goto:eof

:partition_choice_begin
echo Sur quelle partition travailler?
IF NOT "%except_all%"=="Y" (
	echo 0: Toute la rawnand.
)
goto:eof

:partition_choice
echo Aucun choix: Annuler l'opération.
echo.
set /p choose_partition=Faites votre choix: 
goto:eof

:bad_value
echo Choix inexistant.
goto:eof

:force_param_choice
set /p force_option=Souhaitez-vous que le programme ne pose aucune question durant le traitement ^(mode FORCE^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:skipmd5_param_choice
set /p skip_md5=Souhaitez-vous passer la vérification MD5? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:debug_param_choice
set /p debug_option=Souhaitez-vous activer les informations de débogage? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:passthrough_0_option_choice
set /p passthrough_0_option=Souhaitez-vous que les clusters non assignés de la nand soit remplis par des zéros ^(permet une meilleur compression de la nand^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:nnm_split_option_choice
set /p nnm_split_option=Souhaitez-vous diviser le fichier en sortie en plusieurs parties ^(aucune vérification ne sera faite si des fichiers de parties existent, ils seront écrasés^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:nnm_split_size_option_choice
set /p nnm_split_size_option=Quelle taille  en MB chaque partie du fichier divisé devra faire ^(300 minimum^)? ^(4096 MB si laissée vide, entrer 0 pour revenir au choix précédent^): 
goto:eof

:nnm_split_size_option_to_small_error
echo La taille minimum doit être de 300 MB.
goto:eof

:display_infos_nand
IF /i "%nand_type%"=="RAWNAND - splitted dump" (
	echo Type de la nand: RAWNAND - dump splitté
) else IF /i "%nand_type%"=="FULL NAND" (
	echo Type de la nand: dump complet
) else IF /i "%nand_type%"=="UNKNOWN" (
	echo Type de la nand inconnu.
) else (
	echo Type de la nand: %nand_type%
)
IF "%nand_sectors_interval%"=="" (
	IF /i "%nand_file_or_disk%"=="File" (
		echo Support: fichier
	) else IF /i "%nand_file_or_disk%"=="Disk" (
		echo Support: Disque physique
	)
) else (
	IF /i "%nand_file_or_disk%"=="File" (
		echo Support: fichier [%nand_sectors_interval%]
	) else IF /i "%nand_file_or_disk%"=="Disk" (
		echo Support: Disque physique [%nand_sectors_interval%]
	)
)
IF /i "%nand_encrypted%"=="Yes" (
	IF "%nand_decrypt_OK%"=="1" (
		echo Nand chiffrée.
	) else (
		echo Nand chiffrée - échec du déchiffrage.
	)
) else (
	echo Nand non chiffrée.
)
echo Taille: %nand_size%
IF /i "%nand_type%"=="BOOT0" (
	IF /i "%nand_autorcm%"=="ENABLED" (
		echo Auto-RCM activé.
	) else (
		echo Auto-RCM désactivé.
	)
	IF NOT "%nand_soc_rev%"=="" (
		echo Version du SoC: %nand_soc_rev%
	)
	IF NOT "%nand_bootloader_ver%"=="" (
		echo Version du bootloader: %nand_bootloader_ver%
	)
	IF NOT "%nand_firmware_ver%"=="" (
		echo Version du firmware: %nand_firmware_ver%
	)
)
IF /i "%nand_type%"=="RAWNAND" (
	IF NOT "%nand_serial_number%"=="" (
		echo Numéro de série de la console associée: %nand_serial_number%
	)
	IF NOT "%nand_device_id%"=="" (
		echo ID  de la console associée: %nand_device_id%
	)
	IF NOT "%nand_mac_address%"=="" (
		echo Adresse MAC de la console associée: %nand_mac_address%
	)
	IF NOT "!nand_firmware_ver!"=="" (
		set temp_count=
		echo !nand_firmware_ver!|tools\gnuwin32\bin\grep.exe -c "higher" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			echo Version du firmware: !nand_firmware_ver:~0,5! ou un peu plus élevé
		) else (
			echo Version du firmware: !nand_firmware_ver!
		)
	)
	IF NOT "%nand_exfat_driver%"=="" (
		IF /i "%nand_exfat_driver%"=="UNDETECTED" (
			echo Driver EXFAT non détecté.
		) else (
			echo Driver EXFAT détecté.
		)
	)
	IF NOT "%nand_last_boot%"=="" (
		echo Dernier démarrage: %nand_last_boot%
	)
	set /a temp_count=%begin_partition_line% + 1
	set /a temp_last_line=%begin_partition_line% + 12
	set /a temp_last_line=%begin_partition_line% + 11
	echo.
	echo Informations sur les partitions:
	FOR /l %%i IN (!temp_count!,1,!temp_last_line!) DO (
		tools\gnuwin32\bin\sed.exe -n %%ip <templogs\infos_nand.txt > templogs\tempvar.txt
		set /p temp_partition_line_content=<templogs\tempvar.txt
		set temp_partition_line_content=!temp_partition_line_content:, free space =, espace libre !
		echo !temp_partition_line_content!|tools\gnuwin32\bin\grep.exe -c "encrypted" >templogs\tempvar.txt
		set /p temp_partition_is_encrypted=<templogs\tempvar.txt
		IF "!temp_partition_is_encrypted!"=="1" (
			set temp_partition_line_content=!temp_partition_line_content:encrypted=chiffrée!
			set temp_partition_line_content=!temp_partition_line_content:DECRYPTION FAILED=échec du déchiffrage!
			echo !temp_partition_line_content!
		) else (
			echo !temp_partition_line_content!
		)
	)
	IF "%nand_backup_gpt%"=="0" (
		echo Sauvegarde de la table de partitions GPT non trouvé.
	) else (
		echo Sauvegarde de la table de partitions GPT trouvée: %nand_backup_gpt%
	)
)
IF /i "%nand_type%"=="RAWNAND - splitted dump" (
	IF NOT "%nand_serial_number%"=="" (
		echo Numéro de série de la console associée: %nand_serial_number%
	)
	IF NOT "%nand_device_id%"=="" (
		echo ID  de la console associée: %nand_device_id%
	)
	IF NOT "%nand_mac_address%"=="" (
		echo Adresse MAC de la console associée: %nand_mac_address%
	)
	IF NOT "!nand_firmware_ver!"=="" (
		set temp_count=
		echo !nand_firmware_ver!|tools\gnuwin32\bin\grep.exe -c "higher" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			echo Version du firmware: !nand_firmware_ver:~0,5! ou un peu plus élevé
		) else (
			echo Version du firmware: !nand_firmware_ver!
		)
	)
	IF NOT "%nand_exfat_driver%"=="" (
		IF /i "%nand_exfat_driver%"=="UNDETECTED" (
			echo Driver EXFAT non détecté.
		) else (
			echo Driver EXFAT détecté.
		)
	)
	IF NOT "%nand_last_boot%"=="" (
		echo Dernier démarrage: %nand_last_boot%
	)
	set /a temp_count=%begin_partition_line% + 1
	set /a temp_last_line=%begin_partition_line% + 11
	echo.
	echo Informations sur les partitions:
	FOR /l %%i IN (!temp_count!,1,!temp_last_line!) DO (
		tools\gnuwin32\bin\sed.exe -n %%ip <templogs\infos_nand.txt > templogs\tempvar.txt
		set /p temp_partition_line_content=<templogs\tempvar.txt
		set temp_partition_line_content=!temp_partition_line_content:, free space =, espace libre !
		echo !temp_partition_line_content!|tools\gnuwin32\bin\grep.exe -c "encrypted" >templogs\tempvar.txt
		set /p temp_partition_is_encrypted=<templogs\tempvar.txt
		IF "!temp_partition_is_encrypted!"=="1" (
			set temp_partition_line_content=!temp_partition_line_content:encrypted=chiffrée!
			set temp_partition_line_content=!temp_partition_line_content:DECRYPTION FAILED=échec du déchiffrage!
			echo !temp_partition_line_content!
		) else (
			echo !temp_partition_line_content!
		)
	)
	IF "%nand_backup_gpt%"=="0" (
		echo Sauvegarde de la table de partitions GPT non trouvé.
	) else (
		echo Sauvegarde de la table de partitions GPT trouvée: %nand_backup_gpt%
	)
)
IF /i "%nand_type%"=="FULL NAND" (
	IF /i "%nand_autorcm%"=="ENABLED" (
		echo Auto-RCM activé.
	) else (
		echo Auto-RCM désactivé.
	)
	IF NOT "%nand_soc_rev%"=="" (
		echo Version du SoC: %nand_soc_rev%
	)
	IF NOT "%nand_bootloader_ver%"=="" (
		echo Version du bootloader: %nand_bootloader_ver%
	)
	IF NOT "%nand_serial_number%"=="" (
		echo Numéro de série de la console associée: %nand_serial_number%
	)
	IF NOT "%nand_device_id%"=="" (
		echo ID  de la console associée: %nand_device_id%
	)
	IF NOT "%nand_mac_address%"=="" (
		echo Adresse MAC de la console associée: %nand_mac_address%
	)
	IF NOT "!nand_firmware_ver!"=="" (
		set temp_count=
		echo !nand_firmware_ver!|tools\gnuwin32\bin\grep.exe -c "higher" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			echo Version du firmware: !nand_firmware_ver:~0,5! ou un peu plus élevé
		) else (
			echo Version du firmware: !nand_firmware_ver!
		)
	)
	IF NOT "%nand_exfat_driver%"=="" (
		IF /i "%nand_exfat_driver%"=="UNDETECTED" (
			echo Driver EXFAT non détecté.
		) else (
			echo Driver EXFAT détecté.
		)
	)
	IF NOT "%nand_last_boot%"=="" (
		echo Dernier démarrage: %nand_last_boot%
	)
	set /a temp_count=%begin_partition_line% + 1
	set /a temp_last_line=%begin_partition_line% + 13
	echo.
	echo Informations sur les partitions:
	FOR /l %%i IN (!temp_count!,1,!temp_last_line!) DO (
		tools\gnuwin32\bin\sed.exe -n %%ip <templogs\infos_nand.txt > templogs\tempvar.txt
		set /p temp_partition_line_content=<templogs\tempvar.txt
		set temp_partition_line_content=!temp_partition_line_content:, free space =, espace libre !
		echo !temp_partition_line_content!|tools\gnuwin32\bin\grep.exe -c "encrypted" >templogs\tempvar.txt
		set /p temp_partition_is_encrypted=<templogs\tempvar.txt
		IF "!temp_partition_is_encrypted!"=="1" (
			set temp_partition_line_content=!temp_partition_line_content:encrypted=chiffrée!
			set temp_partition_line_content=!temp_partition_line_content:DECRYPTION FAILED=échec du déchiffrage!
			echo !temp_partition_line_content!
		) else (
			echo !temp_partition_line_content!
		)
	)
	IF "%nand_backup_gpt%"=="0" (
		echo Sauvegarde de la table de partitions GPT non trouvé.
	) else (
		echo Sauvegarde de la table de partitions GPT trouvée: %nand_backup_gpt%
	)
)
IF /i "%nand_type%"=="PRODINFO" (
	IF NOT "%nand_serial_number%"=="" (
		echo Numéro de série de la console associée: %nand_serial_number%
	)
	IF NOT "%nand_device_id%"=="" (
		echo ID  de la console associée: %nand_device_id%
	)
	IF NOT "%nand_mac_address%"=="" (
		echo Adresse MAC de la console associée: %nand_mac_address%
	)
)
IF /i "%nand_type%"=="SYSTEM" (
	IF NOT "!nand_firmware_ver!"=="" (
		set temp_count=
		echo !nand_firmware_ver!|tools\gnuwin32\bin\grep.exe -c "higher" >templogs\tempvar.txt
		set /p temp_count=<templogs\tempvar.txt
		IF "!temp_count!"=="1" (
			echo Version du firmware: !nand_firmware_ver:~0,5! ou un peu plus élevé
		) else (
			echo Version du firmware: !nand_firmware_ver!
		)
	)
	IF NOT "%nand_exfat_driver%"=="" (
		IF /i "%nand_exfat_driver%"=="UNDETECTED" (
			echo Driver EXFAT non détecté.
		) else (
			echo Driver EXFAT détecté.
		)
	)
	IF NOT "%nand_last_boot%"=="" (
		echo Dernier démarrage: %nand_last_boot%
	)
)
goto:eof