goto:%~1

:display_title
title Lancer Ns-usbloader %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet juste de lancer Ns-usbloader, un logiciel permettant d'installer du contenu sur la Switch via NSA-Installer, Awoo-Installer, Tinleaf ou Goldleaf.
echo.
echo En utilisant ce programme, vous acceptez la licence d'utilisation de Java pour un usage personnel et non commercial du produit.
echo.
echo 0: Voir la licence d'utilisation de Java?
echo 1: Refuser la licence d'utilisation de Java et revenir au menu?
echo Tout autre choix: Accepter la licence d'utilisation de Java et utiliser Ns-usbloader?
echo.
set /p action_choice=Faites votre choix: 
goto:eof