goto:%~1

:display_title
title Shadow256 Ultimate Switch Hack Script Update Manager Updater%this_script_version% - 
goto:eof

:begin_update
echo :::::::::::::::::::::::::::::::::::::
echo ::Shadow256 Ultimate Switch Hack Script Update Manager Updater::
echo.
echo Mise à jour du gestionnaire de mises à jour du script en cours...
goto:eof

:no_internet_connection_error
echo Aucune connexion internet vérifiable, mise à jour impossible et le script va se fermer.
goto:eof

:update_file_error
echo Erreur lors de la mise à jour du fichier "%temp_file_path%", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
goto:eof

:update_file.version_error
echo Erreur lors de la mise à jour du fichier "%temp_file_path%.version", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
goto:eof

:update_language_file_error
echo Erreur lors de la mise à jour du fichier "%language_path%\%temp_file_path%", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
goto:eof

:update_language_file.version_error
echo Erreur lors de la mise à jour du fichier "%language_path%\%temp_file_path%.version", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
goto:eof

:update_success
echo Mise à jour du gestionnaire de mises à jour du script terminée, le script va se fermer.
goto:eof