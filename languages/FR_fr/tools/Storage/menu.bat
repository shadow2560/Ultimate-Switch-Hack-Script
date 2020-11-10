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
echo 1: Lancer un payload via le mode RCM?
echo.
echo 2: Lancer un payload via PegaScape/PegaSwitch et/ou préparer le nécessaire sur la SD pour que cela fonctionne?
echo.
echo 3: Monter la nand, la partition boot0, la partition boot1 ou la carte SD comme un disque dur sur votre système d'exploitation?
echo.
echo 4: Préparer une carte SD pour le hack Switch?
echo.
echo 5: Mises à jour ou débrickage de la Switch?
echo.
echo 6: Nand toolbox?
echo.
echo 7: Lancer NSC_Builder qui permet d'avoir des infos, de convertir et de nettoyer des NSPs et XCIs, voir la documentation pour plus d'infos?
echo.
echo 8: Lancer ou configurer la boîte à outils?
echo.
echo 9: Lancer Ns-usbloader pour installer du contenu sur la Switch via NSA-Installer ou Goldleaf?
echo.
echo 10: Autres fonctions?
echo.
echo 11: Fonctions à utiliser occasionnellement?
echo.
echo 12: Sauvegarde/restauration et paramètres du script?
echo.
echo 13: Lancer ou configurer le client pour pouvoir jouer en réseau ^(serveur Switch-Lan-Play^)?
echo.
echo 14: Lancer un serveur pour le jeu en réseau ^(serveur Switch-Lan-Play^)?
echo.
echo 15: Changer de langue?
echo.
echo 16: A propos du script?
echo.
echo 17: Me faire une donation?
echo.
echo 0: Lancer la documentation ^(recommandé^)?
echo.
echo N'importe quel autre choix: Quitter sans rien faire?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
goto:eof