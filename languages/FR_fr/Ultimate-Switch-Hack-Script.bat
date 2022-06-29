goto:%~1

:display_title
title Chargement %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:admin_error
echo Le script se trouve dans un répertoire nécessitant les privilèges administrateur pour être écrit. Veuillez relancer le script avec les privilèges administrateur en faisant un clique droit dessus et en sélectionnant "Exécuter en tant qu'administrateur".
goto:eof

:display_utf8_instructions
echo Avant de continuer, vérifiez ceci car le script pourrait ne pas fonctionner si ce paramètre est mal réglé:
echo - Faire un clique droit sur la barre de titre ou le raccourci "alt+espace" et cliquer sur "Propriétés".
echo - Aller dans l'onglet "Polices", choisir la police "Lucida Console" et cliquer sur "OK".
echo.
echo Si tout est bon, le script devrait fonctionner correctement.
echo Si le script se ferme immédiatement après ceci, cela veut dire que la police que vous avez sélectionné n'est pas compatible avec l'encodage de caractères UTF-8.
goto:eof

:set_debug_flag
echo.
echo Mode de journaux d'information.
echo.
echo Pour cette session:
echo 1: Mode journal intermédiaire ^(rend le script un peu plus verbeux à l'affichage et écrit les résultats des sorties dans un fichier de journal^)
echo 2: Mode journal complet ^(affichage très verbeux et enregistrements plus grand du fichier de journal^)
echo Tout autre choix: Mode sans journal ^(recommandé^).
echo.
set /p debug_flag=Faites votre choix: 
goto:eof

:theme_choice_begin
echo Choix du thème:
goto:eof

:theme_number_set
set /p temp_theme_number=Entrez le numéro du thème: 
goto:eof

:empty_theme_number_error
echo Le thème ne peut être vide.
goto:eof

:bad_char_theme_number_error
echo Un caractère non autorisé a été saisie pour le choix du thème.
goto:eof

:bad_value_theme_number_error
echo Ce thème n'existe pas.
goto:eof