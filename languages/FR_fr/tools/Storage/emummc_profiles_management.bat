goto:%~1

:display_title
title Gestion de profiles d'emummc %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:main_action_choice
echo Gestion des profiles d'emummc pour Atmosphere
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Créer un profile?
echo 2: Modifier un profile?
echo 3: Supprimer un profile?
echo 0: Obtenir les infos de configuration de l'emunand d'un profile?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:intro_info_profile
echo Information sur un profile
goto:eof

:info_no_profile_exist_error
echo Aucun profile existant, veuillez en créer un pour obtenir des infos.
goto:eof

:info_profile
echo Nom du profile: %profile_selected:~0,-4%
goto:eof

:intro_create_profile
echo Création d'un profile
echo.
set /p new_profile_name=Entrez le nom du profile, laisser vide pour annuler l'opération: 
goto:eof

:char_error_in_profile_name
echo Un caractère non autorisé a été saisie dans le nom du profile.
goto:eof

:create_profile_success
echo Profile "%new_profile_name%" créé avec succès.
goto:eof

:intro_modify_profile
echo Modification d'un profile
goto:eof

:modify_no_profile_exist_error
echo Aucun profile à modifier, veuillez en créer un.
goto:eof

:intro_delete_profile
echo Suppression d'un profile
goto:eof

:delete_no_profile_exist_error
echo Aucun profile à supprimer, veuillez en créer un.
goto:eof

:delete_profile_finded_in_general_profile
echo Ce profile est utilisé dans les profiles généraux suivant:
goto:eof

:delete_profile_finded_in_general_profile2
set /p define_del_profile=Supprimer ce profile supprimera les profiles généraux auxquels il est lié, souhaitez-vous continuer? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:delete_profile_success
echo Profile "%profile_selected:~0,-4%" supprimé avec succès.
goto:eof

:intro_select_profile
echo Sélectionner un profile:
goto:eof

:select_profile_choice
echo N'importe quel autre choix: Revenir à l'action précédente.
echo.
set /p profile_choice=Choisir un profile: 
goto:eof

:display_emummc_config_parsed
IF /i "%emunand_enable%"=="o" (
	echo Emunand activée avec les paramètres suivants:
	IF "%emummc_id%"=="" (
		echo ID de l'emunand par défaut.
	) else (
		echo ID de l'emunand: %emummc_id%
	)
	IF "%emummc_title%"=="" (
		echo Titre de l'emunand par défaut.
	) else (
		echo Titre de l'emunand: %emummc_title%
	)
	IF "%emummc_sector%"=="" (
		echo Aucun secteur de démarrage configuré.
	) else (
		echo Secteur de démarrage de l'emunand: %emummc_sector%
	)
	IF "%emummc_path%"=="" (
		echo Aucun chemin vers les fichiers de dump de la nand défini.
	) else (
		echo Chemin vers les fichiers de dump de la nand: %emummc_path%
	)
	IF "%emummc_nintendo_path%"=="" (
		echo Chemin du dossier Nintendo de l'emunand par défaut.
	) else (
		echo Chemin du dossier Nintendo de l'emunand: %emummc_nintendo_path%
	)
) else (
	echo Emunand désactivée.
)
goto:eof

:emummc_config_enable_choice
echo Configuration de l'emunand
echo.
set /p "emunand_enable=Souhaitez-vous activer l'emunand? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:canceled
echo Opération annulée.
goto:eof

:emummc_id_choice
set /p emummc_id=Définir l'ID de l'emunand ^(laisser vide pour utiliser l'ID par défaut^) ^(ne pas noter le 0x de début^) ^(4 caractères maximum^): 
goto:eof

:emummc_id_size_error
echo L'ID de l'emunand doit comprendre 4 caractères hexadécimaux au maximum.
goto:eof

:emummc_id_char_error
echo Un caractère non autorisé a été saisie dans l'ID de l'emunand.
goto:eof

:emummc_title_choice
set /p emummc_title=Définir le titre de l'emunand ^(laisser vide pour garder le titre par défaut^): 
goto:eof

:emummc_sector_choice
set /p emummc_sector=Définir le secteur de la partition démarrant l'emunand ^(si emunand via fichiers, laisser cette valeur vide^) ^(ne pas noter le 0x de début^): 
goto:eof

:emummc_sector_char_error
echo Un caractère non autorisé a été saisie dans le secteur de démarrage de l'emunand.
goto:eof

:emummc_path_choice
set /p emummc_path=Définir le chemin vers le dossier contenant les fichiers permettant de booter l'emunand ^(si laisser vide, l'emunand sera désactivée^): 
goto:eof

:emummc_no_sector_or_path_error
echo Aucun secteur de démarrage ni chemin de dossier vers des fichiers d'un dump de nand défini, l'emunand va donc être désactivée.
goto:eof

:emummc_nintendo_path_choice
set /p emummc_nintendo_path=Définir le chemin du dossier nintendo de l'emunand ^(laisser vide pour garder le chemin par défaut^): 
goto:eof

:emummc_config_success
echo Configuration du fichier d'emummc sauvegardée avec succès dans le profile "%profile_selected:~0,-4%".
goto:eof