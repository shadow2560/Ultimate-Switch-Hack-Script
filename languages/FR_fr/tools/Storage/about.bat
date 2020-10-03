goto:%~1

:display_title
title A propos %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:action_choice
echo A propos:
echo.
echo Version actuelle du script: %ushs_version%
echo Version actuelle des packs du script: %ushs_packs_version%
echo.
echo Licence GPL V3 pour mon travail ^(shadow256 sur les forums et shadow2560 sur Github^), le reste est sous la licence des auteurs de celui-ci. Notez que les packs de langues sont aussi sous GPL V3.
echo.
echo Informations sur la langue utilisé:
echo Nom: %language_name%
echo Auteur^(s^): %language_authors%
echo.
echo Note: Vous devrez  faire deux fois l'action de mise à jour souhaitée si une mise à jour du gestionnaire de mises à jour est trouvée durant la procédure.
echo.
echo Que souhaitez-vous faire?
echo 1: Afficher le changelog du script le plus récent?
echo 2: Afficher le changelog des packs le plus récent?
echo 3: Afficher la dernière version de la page des crédits.
echo 4: Mettre à jour tous les éléments du script pouvant être mis à jour ^(méthode recommandé^) ^(le script se fermera après la mise à jour et devra être redémarré^)?
echo 5: Mettre à jour l'ensemble du script ^(dernier recours^)  ^(le script se fermera après la mise à jour et devra être redémarré^)?
echo 6: Me faire une donation?
echo N'importe quel autre choix: Revenir au menu principal.
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:no_internet_connection
echo Aucune connexion à internet disponible, impossible d'afficher cette information.
goto:eof