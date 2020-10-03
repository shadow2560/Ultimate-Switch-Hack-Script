goto:%~1

:display_title
title Mise à jour pour l'ancienne méthode de lancement de Linux %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:no_internet_connection_error
echo Aucune connexion internet disponible, mise à jour annulée.
goto:eof

:update_begin
echo Mise à jour en cours...
goto:eof

:download_error
echo Erreur pendant le téléchargement de Shofel2, le script ne peut continuer.
goto:eof

:extract_error
echo Erreur pendant l'extraction de Shofel2, le script ne peut continuer.
goto:eof

:update_end
echo Mise à jour effectuée.
goto:eof