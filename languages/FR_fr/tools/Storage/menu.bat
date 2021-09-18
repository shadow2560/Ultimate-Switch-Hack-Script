goto:%~1

:display_title
title Menu principal %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo ::Shadow256 Ultimate Switch Hack Script %ushs_version%::
echo :::::::::::::::::::::::::::::::::::::
echo.
echo Menu principal
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Menu des fonctions basiques ^(lancer un payload, préparer la SD, vérifier des infos, etc...^)?
echo.
echo 2: Mises à jour ou débrickage de la Switch?
echo.
echo 3: Nand toolbox?
echo.
echo 4: Lancer NSC_Builder qui permet d'avoir des infos, de convertir et de nettoyer des NSPs et XCIs, voir la documentation pour plus d'infos?
echo.
echo 5: Lancer ou configurer la boîte à outils?
echo.
echo 6: Autres fonctions?
echo.
echo 7: Fonctions à utiliser occasionnellement?
echo.
echo 8: Sauvegarde/restauration et paramètres du script?
echo.
echo 9: Lancer ou configurer le client pour pouvoir jouer en réseau ^(serveur Switch-Lan-Play^)?
echo.
echo 10: Lancer un serveur pour le jeu en réseau ^(serveur Switch-Lan-Play^)?
echo.
echo 11: Permettre le contrôle à distance de cet ordinateur via NVDA et Nvdaremote?
echo.
echo 12: Changer de langue?
echo.
echo 13: A propos du script?
echo.
echo 14: Me faire une donation?
echo.
echo 0: Lancer la documentation ^(recommandé^)?
echo.
echo N'importe quel autre choix: Quitter sans rien faire?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
goto:eof