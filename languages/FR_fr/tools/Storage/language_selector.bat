goto:%~1

:display_title
title Changement de langue %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:language_list_downloading
echo Téléchargement de la liste de langues disponibles...
goto:eof

:language_choice_begin
echo Choix de la langue
goto:eof

:language_choice
set /p temp_language_number=Choisir la langue souhaitée: 
goto:eof

:language_choice_empty_error
echo Le choix de la langue ne peut être vide.
goto:eof

:language_choice_char_error
echo Un caractère non autorisé a été saisi dans le choix de la langue.
goto:eof

:language_choice_bad_value_error
echo Valeur non autorisé pour le choix de la langue.
goto:eof

:init_language_error
echo Une erreur s'est produite lors de l'initialisation de la langue, la valeur ne sera donc pas changée.
goto:eof

:language_change_success
echo Langue modifiée avec succès.
echo Pour appliquer les changements, le script va redémarrer.
goto:eof

:no_internet_connection_error
echo Aucune connexion internet disponible, impossible de continuer.
goto:eof