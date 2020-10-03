goto:%~1

:display_title
title Installation drivers %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va permettre d'installer les drivers nécessaires au bon fonctionnement de la Switch avec le PC.
echo Pour plus d'informations sur les différentes méthodes, choisissez d'ouvrir la documentation lorsque cela sera proposé.
goto:eof

:install_choice
echo Installation de drivers
echo.
echo Choisissez comment installer les drivers:
echo.
echo 1: Installation automatique pour le mode RCM et le mode Homebrew ^(installation recommandée pour ces modes^)?
echo 2: Installation via Zadig?
echo 3: Installation via le gestionaire de périphériques?
echo 4: Maximiser la vitesse de copie de la fonction de stockage de masse USB de Hekate ^(à n'exécuter qu'une seule fois^)?
echo 0: Lancer la documentation?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p install_choice=Quelle méthode souhaitez-vous utiliser? 
goto:eof

:test_payload_choice
set /p test_payload=Souhaitez-vous lancer un payload? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:zadig_launch_instructions
echo Zadig va être lancé, veuillez accepter la demande d'élévation des privilèges qui va suivre pour faire fonctionner ce programme.
goto:eof

:manual_install_instructions
echo Le gestionnaire de périphérique va être lancé.
echo Le dossier à sélectionner pour installer les drivers est le dossier "tools\drivers\manual_installation_usb_driver" de ce script.
goto:eof