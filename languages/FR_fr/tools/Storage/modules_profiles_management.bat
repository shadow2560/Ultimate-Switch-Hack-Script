goto:%~1

:display_title
title Gestion de profiles de modules %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:main_action_choice
echo Gestion des profiles de modules
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Créer un profile?
echo 2: Modifier un profile?
echo 3: Supprimer un profile?
echo 0: Obtenir la liste des modules d'un profile?
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
echo modules présents dans le profile:
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

:no_modules_in_profile_error
echo Aucun module configuré pour ce profile.
goto:eof

:intro_modules_one_page
echo Sélection d'un module à ajouter ou à supprimer pour le profile "%temp_profile:~0,-4%"
goto:eof

:intro_modules_multi_page
echo Sélection d'un module à ajouter ou à supprimer pour le profile "%temp_profile:~0,-4%", page %selected_page%/%page_number%
goto:eof

:add_remove_modules_info
echo Les modules dont le nom est préfixé d'un "*" sont les modules présent dans le profile.
goto:eof

:change_page_info
echo P: Changer de page, faire suivre le P d'un numéro de page valide.
goto:eof

:add_remove_modules_choice_ending
echo N'importe quel autre choix: Arrêter la modification de la liste des modules du profile.
echo.
set /p module_choice=Choisir un module pour l'ajouter ou le supprimer ou changer de page: 
goto:eof

:page_not_exist_error
echo Cette page n'existe pas.
goto:eof

:no_modules_in_modules_folder
echo Erreur, il ne semble y avoir aucun module dans le dossier "tools\sd_switch\modules\pack" du script, le processus ne peut continuer.
goto:eof

:canceled
echo Opération annulée.
goto:eof