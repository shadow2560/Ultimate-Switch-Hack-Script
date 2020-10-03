goto:%~1

:display_title
title Lancement d'un payload %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:begin_payload_choice
echo Choisir un payload. 
goto:eof

:end_payload_choice
echo 0: Choisir un fichier de payload 
echo N'importe quel autre choix: Revenir au menu principal. 
echo.
set /p payload_number=Entrez le numéro du payload à lancer: 
goto:eof

:payload_file_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichier de payload Switch ^(*.bin^)|*.bin|" "Sélection du payload" "templogs\tempvar.txt"
goto:eof

:no_payload_file_selected_error
echo Aucun payload sélectionné, retour à la sélection de payloads. 
goto:eof

:rcm_instructions
echo ********************************************* 
echo ***    CONNECTEZ LA SWITCH EN MODE RCM    *** 
echo ********************************************* 
echo 1^) Connecter la Switch en USB et l'éteindre 
echo 2^) Appliquer le JoyCon Haxx : PIN1 + PIN10 ou PIN9 + PIN10 
echo 3^) Faire un appui long sur VOLUME UP + appui court sur POWER 
echo En attente d'une Switch en mode RCM... 
goto:eof

:launch_payload_error
echo Une erreur s'est produite pendant l'injection du payload. Vérifiez que le mode RCM de la Switch est lancé, que votre cable USB est bien relié à l'ordinateur et que les drivers ont été installés puis recommencez. 
goto:eof

:launch_payload_success
echo ********************************************* 
echo ***            Payload injecté            *** 
echo ********************************************* 
goto:eof