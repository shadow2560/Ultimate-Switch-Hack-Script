goto:%~1

:display_title
title Changement de thème %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:theme_list_downloading
echo Téléchargement de la liste de thèmes disponibles...
goto:eof

:theme_choice_begin
echo Choix du thème:
goto:eof

:theme_choice
set /p temp_theme_number=Choisir le thème souhaité: 
goto:eof

:theme_choice_empty_error
echo Le choix du thème ne peut être vide.
goto:eof

:theme_choice_char_error
echo Un caractère non autorisé a été saisi dans le choix du thème.
goto:eof

:theme_choice_bad_value_error
echo Valeur non autorisé pour le choix du thème.
goto:eof

:init_theme_error
echo Une erreur s'est produite lors de l'initialisation du thème, la valeur ne sera donc pas changée.
goto:eof

:theme_change_success
echo Thème modifiée avec succès.
goto:eof

:no_internet_connection_error
echo Aucune connexion internet disponible, impossible de continuer.
goto:eof