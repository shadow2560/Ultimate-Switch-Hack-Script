goto:%~1

:display_title
title Lancer HID-mitm_compagnon %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
ECHO ////////////////////// hid_mitm ^(script de démarrage par Krank, modifié par Shadow256^) //////////////////////
ECHO.
ECHO Répertoire de travail: %cd%
goto:eof

:ip_choice
set /p IP_Adress=Entrez l'adresse IP de votre Switch ou laissez vide pour revenir au menu précédent: 
goto:eof