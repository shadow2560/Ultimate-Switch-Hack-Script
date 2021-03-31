goto:%~1

:display_title
title Menu des fonctions basiques %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo Menu des fonctions basiques
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Lancer un payload via le mode RCM?
echo.
echo 2: Lancer un payload via PegaScape/PegaSwitch et/ou préparer le nécessaire sur la SD pour que cela fonctionne?
echo.
echo 3: Installer les drivers pour la Switch?
echo.
echo 4: Préparer une carte SD pour le hack Switch?
echo.
echo 5: Vérifier si des numéros de série de consoles sont patchées ou non?
echo.
echo 6: Vérifier un fichier de clés?
echo.
echo 7: Monter la nand, la partition boot0, la partition boot1 ou la carte SD comme un disque dur sur votre système d'exploitation?
echo.
echo 8: Lancer Ns-usbloader pour installer du contenu sur la Switch via NSA-Installer ou Goldleaf?
echo.
echo 9: Gestion des puces?
echo.
echo 10: Créer les sig_patches pour Atmosphere?
echo.
echo 11: Spoof de la licence de SXOS?
echo.
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
goto:eof