goto:%~1

:display_title
title Gestionnaire de mises à jour %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:autoupdate_choice
echo Réglage de la mise à jour automatique:
echo.
echo La mise à jour automatique intervient lors du démarrage des différentes fonctionnalités ou grands groupes de fonctionnalités du script. Si vous tentez de mettre à jour une fonctionnalité qui n'est pas encore installée, son installation sera forcée même en cas de désactivation de la mise à jour automatique.
echo Dans les choix qui vont suivre, si vous ne faites pas un choix définitif, cette question sera donc souvent posée.
echo Si vous choisissez de toujours vérifier les mises à jour, certaines fonctionnalités mettront un peu de temps à se lancer, notemment le démarrage du menu principal ou encore la préparation d'une SD ou la Nand Toolbox car ces fonctionnalités ont beaucoup de dépendances mais vous aurez toujours les dernières versions des fonctionnalités que vous utilisez et le reste ne bougera pas tant que vous ne l'aurez pas utilisé au moins une fois.
echo Au contraire, si vous choisissez de ne jamais mettre à jour, vous ne pourrez que faire la mise à jour de tous les éléments du script d'un coup via le menu "A propos" mais le lancement des fonctionnalités sera bien plus rapide.
echo Notez que vous pouvez toujours réinitialiser cette valeur en passant par le menu des paramètres du script.
echo Notez également que même en cas de désactivation de la mise à jour automatique et si vous faites une mise à jour manuelle qui a échouée, celle-ci sera reprise automatiquement pour éviter des bugs dans le script.
echo.
echo Que souhaitez-vous faire?
echo %lng_yes_choice%: Vérifier les mises à jour cette fois-ci.
echo %lng_no_choice%: Ne pas vérifier les mises à jour cette fois-ci.
echo %lng_always_choice%: Toujours vérifier les mises à jour.
echo %lng_never_choice%: Ne jamais vérifier les mises à jour.
echo.
set /p auto_update=Souhaitez-vous activer la mise à jour automatique? ^(%lng_yes_choice%/%lng_no_choice%/%lng_always_choice%/%lng_never_choice%^): 
goto:eof

:autoupdate_bad_value_error
echo Mauvaise valeur configurée, le paramètre va être réinitialisé.
goto:eof

:autoupdate_empty_value_error
echo Cette valeur ne peut être vide.
goto:eof

:autoupdate_choice_not_permited_error
echo Choix inexistant.
goto:eof

:no_internet_connection_error
echo Aucune connexion à internet disponible, le script ne peux vérifier les mises à jour.
goto:eof

:no_internet_connection_for_new_installation_error
echo De plus, ceci était une tentative d'installation d'une nouvelle fonctionnalité, le script va donc se fermer pour plus de sécurité.
goto:eof

:update_manager_updater_update
echo Le gestionnaire de mises à jour doit se mettre à jour lui-même avant de pouvoir continuer.
echo Pour se faire, le script va lancer un autre script puis se fermer pour que la mise à jour puisse s'effectuer correctement.
echo Une fois la mise à jour effectuée, le script va redémarrer.
goto:eof

:new_installation_choice
echo Attention, il semble que vous souhaitiez utiliser une fonctionnalité non installée.
echo De fait, l'installation de celle-ci va être forcée si vous choisissez d'accepter cette installation, une connexion internet est nécessaire.
echo Si vous ne pouvez pas utiliser internet, la fonctionnalité ne se lancera pas après cette tentative d'installation et des bugs pourraienent se produire donc dans ce cas il est fortement conseillé de refuser le choix qui va suivre et le script se fermera pour plus de sécurité.
set /p new_install_choice=Souhaitez-vous lancer l'installation? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:begin_update
echo Vérifications et mises à jour en cours...
goto:eof

:script_version_not_initialized_info
echo La version du script ne semble pas avoir été initialisée, le script va devoir redémarrer pour prendre en compte cette modification.
goto:eof

:language_config_update_info
echo Le fichier de configuration de la langue a été mise à jour, le script va devoir redémarrer pour prendre en compte les changements.
goto:eof

:end_update_restart_needed
echo Vérifications et mises à jour terminées, le script va maintenant redémarrer.
goto:eof

:end_update
echo Vérifications et mises à jour terminées.
goto:eof

:update_all_begin
echo Mise à jour intégrale du script en cours...
goto:eof

:languages_update_begin
echo Mise à jour des langues...
goto:eof

:languages_update_end
echo Langues téléchargées.
goto:eof

:update_all_end
echo Mise à jour intégrale du script terminée.
goto:eof

:update_basic_elements_begin
echo Vérification et mise à jour des éléments généraux du script
goto:eof

:update_basic_elements_end
echo Mise à jour des éléments généraux terminée, le script va devoir redémarrer pour prendre en compte ces modifications.
goto:eof

:update_file_error
IF "%failed_updates_finded%"=="Y" (
	rmdir /q /s "failed_updates"
	IF EXIST "continue_update.txt" del /q "continue_update.txt"
	echo Erreur lors de la mise à jour du fichier "%temp_file_path%", le script va se fermer et ne reprendra pas automatiquement la mise à jour.
) else (
	echo Erreur lors de la mise à jour du fichier "%temp_file_path%", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
)
goto:eof

:update_file.version_error
IF "%failed_updates_finded%"=="Y" (
	rmdir /q /s "failed_updates"
	IF EXIST "continue_update.txt" del /q "continue_update.txt"
	echo Erreur lors de la mise à jour du fichier "%temp_file_path%.version", le script va se fermer et ne reprendra pas automatiquement la mise à jour.
) else (
	echo Erreur lors de la mise à jour du fichier "%temp_file_path%.version", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
)
goto:eof

:update_file_success
echo Mise à jour de "%temp_file_path%" effectuée.
goto:eof

:update_folder_error
IF "%failed_updates_finded%"=="Y" (
	rmdir /q /s "failed_updates"
	IF EXIST "continue_update.txt" del /q "continue_update.txt"
	echo Erreur lors de la mise à jour du dossier "%temp_folder_path%", le script va se fermer et ne reprendra pas automatiquement la mise à jour.
) else (
	echo Erreur lors de la mise à jour du dossier "%temp_folder_path%", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
)
goto:eof

:update_folder_success
echo Mise à jour de "%temp_folder_path%" effectuée.
goto:eof

:write_access_test_error
echo Le script se trouve dans un répertoire nécessitant les privilèges administrateur pour être écrit. Veuillez relancer le script avec les privilèges administrateur en faisant un clique droit dessus et en sélectionnant "Exécuter en tant qu'administrateur".
goto:eof

:del_hold_files_begin
echo Vérifications et suppressions d'éventuels anciens fichiers n'étant plus utilisés.
goto:eof

:del_hold_files_end
echo Vérifications et suppressions terminées.
goto:eof

:retroarch_no_internet_connection
echo Aucune connexion à internet disponible, la dernière version de Retroarch ne peut être téléchargée.
goto:eof

:retroarch_updating
echo Téléchargement de Retroarch, ceci peut prendre du temps...
goto:eof

:retroarch_end_updating
echo Téléchargement de Retroarch effectué avec succès.
goto:eof