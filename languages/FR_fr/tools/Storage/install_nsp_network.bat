goto:%~1

:display_title
title Installation NSP via le réseau %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va vous permettre d'installer un fichier NSP ou un dossier contenant des fichiers NSP sur une Switch connectée sur le réseau.
echo Il faut que Tinfoil soit lancé en mode réseau sur la console et que la console soit relié au même réseau que le PC sur lequel est exécuté ce script.
echo Attention: Accepter la demande d'autorisation de votre pare-feu si elle s'affiche car sinon l'installation ne fonctionnera pas.
echo Attention: Il est conseillé de désactiver la mise en veille de la Switch pendant le processus pour éviter que les jeux ne soient pas complètements installés si la console se met en veille durant l'installation.
goto:eof

:ip_choice
set /p custom_ip=Entrez l'adresse IP de votre Switch: 
goto:eof

:install_type_choice
echo.
echo Que souhaitez-vous faire:
echo 1: Installer un fichier NSP?
echo 2: Installer plusieurs NSP en sélectionnant un dossier sans la prise en compte des sous-dossiers?
echo 3: Installer plusieurs NSP en sélectionnant un dossier avec la prise en compte des sous-dossiers?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p install_type=Choisissez la méthode d'installation: 
goto:eof

:file_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers NSP ^(*.nsp^)|*.nsp|" "Sélection du fichier NSP à installer" "templogs\tempvar.txt"
goto:eof

:folder_choice
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier des NSPs"
goto:eof

:canceled
echo Installation annulée.
goto:eof

:install_error
echo Une erreur s'est produite pendant l'installation.
goto:eof

:multi_install_error
echo Erreur d'installation pour le fichier %filepath%\%~2
goto:eof

:no_file_to_install_error
echo Il n'y a aucun fichier NSP à installer dans ce dossier ou ses sous-dossiers.
goto:eof

:multi_recursive_install_error
echo Erreur d'installation pour le fichier %filepath%\!temp_nsp!
goto:eof

:install_end
echo Installation terminée.
goto:eof