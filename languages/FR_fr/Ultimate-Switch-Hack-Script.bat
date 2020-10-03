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