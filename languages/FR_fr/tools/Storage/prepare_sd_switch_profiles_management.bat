goto:%~1

:display_title
title Gestion de profiles généraux pour la préparation d'une SD %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:main_action_choice
echo Gestions de profiles généraux des éléments à copier durant la préparation d'une SD.
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Créer un profile?
echo 2: Modifier un profile?
echo 3: Supprimer un profile?
echo 0: Obtenir les infos sur la configuration effectuée  dans un profile?
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

:values_saved_success
echo Valeurs enregistrées avec succès pour le profile %profile_selected:~0,-4%.
goto:eof