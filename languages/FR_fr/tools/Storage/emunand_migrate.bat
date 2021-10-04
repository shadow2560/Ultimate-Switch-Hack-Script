goto:%~1

:display_title
title Migration d'emunand %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de migrer une emunand de SXOS vers Atmosphere.
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

