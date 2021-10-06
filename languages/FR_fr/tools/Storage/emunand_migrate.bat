goto:%~1

:display_title
title Migration d'emunand %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de migrer une emunand, seul les configurations basiques sont supportées.
goto:eof

:no_disk_found_error
echo Aucun disque compatible trouvé. Veuillez insérer votre carte SD.
	echo.
set /p disk_not_finded_choice=Souhaitez-vous tenter de recharger la liste de disques ^(si non, le script se terminera^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:disk_list_begin
echo Liste des disques: 
goto:eof

:disk_list_choice
echo 0: Revenir à la sélection de l'action principale de ce script.
echo.
echo.
set /p volume_letter=Entrez la lettre du volume de la carte SD que vous souhaitez utiliser: 
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

:disk_choice_letter_not_exist_error
echo Cette lettre de volume n'est pas dans la liste. Recommencez. 
goto:eof

:emunands_sumary
echo Résumé sur les emunands trouvées:
echo.
IF "%sxos_emunand_files_exist%"=="1" (
	echo Emunand via fichiers pour SXOS trouvée.
)
IF "%sxos_emunand_partition_exist%"=="1" (
	echo Emunand via partition pour SXOS trouvée.
)
IF "%atmo_emunand_exist%"=="1" (
	IF "%atmo_emunand_type%"=="files" (
		echo Emunand via fichiers pour Atmosphere.
	) else IF "%atmo_emunand_type%"=="partition" (
		echo Emunand via partition pour Atmosphere.
	) else IF "%atmo_emunand_type%"=="sxos_partition" (
		echo Emunand via partition pour Atmosphere compatible avec SXOS.
	)
	echo Informations sur les paramètres de l'emunand d'Atmosphere:
	IF NOT "%atmo_emunand_enabled%"=="" (
		IF "%atmo_emunand_enabled%"=="1" (
			echo Emunand activée.
		) else (
			echo Emunand désactivée.
		)
	)
	IF NOT "%atmo_emunand_id%"=="" (
		echo ID de l'emunand: %atmo_emunand_id%
	)
	IF NOT "%atmo_emunand_sector%"=="" (
		echo Secteur de début de l'emunand: %atmo_emunand_sector%
	)
	IF NOT "%atmo_emunand_path%"=="" (
		echo Chemin du dossier "eMMC" contenant les fichiers de l'emunand: %atmo_emunand_path%
	)
	IF NOT "%atmo_emunand_nintendo_path%"=="" (
		echo Chemin d'émulation du dossier nintendo associé à l'emunand: %atmo_emunand_nintendo_path%
	)
)
goto:eof

:set_action_choice
echo Que souhaitez-vous faire:
echo 1: Rendre l'emunand via partition de SXOS également compatible avec Atmosphere?
echo 2: Migrer l'emunand via fichiers de SXOS verrs une emunand via fichiers pourr Atmosphere?
echo 3: Migrer l'emunand via fichiers de Atmosphere verrs une emunand via fichiers pourr SXOS?
echo Tout autre choix: Revenir au menu précédent.
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:sxos_partition_emunand_not_exist
echo Aucune emunand SXOS via partition trouvée.
goto:eof

:atmo_emunand_already_exists
echo Une emunand pour Atmosphere existe déjà.
goto:eof

:succesful_migration
echo Migration effectuée avec succès.
goto:eof

:sxos_files_emunand_not_exist
echo Aucune emunand SXOS via fichiers trouvée.
goto:eof

:atmo_emunand_not_files_type
echo L'emunand d'Atmosphere n'est pas une emunand via fichiers.
goto:eof

:sxos_emunand_files_already_exists
echo Une emunand via fichiers pour SXOS existe déjà.
goto:eof