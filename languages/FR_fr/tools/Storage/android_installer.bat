goto:%~1

:display_title
title Android Installation APK via ADB %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va servir à installer des applications sur un appareil Android via le mode débogage USB.
echo Si vous ne savez pas comment activer ce mode pour vottre appareil, je vous invite à faire une recherche pour trouver cette information.
echo Notez également que les drivers de votre appareil doivent être installés pour que ceci fonctionne correctement.
echo Enfin, une connexion à Internet peut être requise si vous souhaitez mettre à jour les outils utilisés durant ce script ou bien si c'est la première fois que vous exécutez celui-ci.
goto:eof

:action_choice
echo Choisir une application à installer. 
echo.
TOOLS\gnuwin32\bin\tail.exe -q -n+0 templogs\apps_list.txt
echo f: Choisir un fichier d'application Android.
echo d: Choisir un dossier contenant des applications Android ^(les sous-dossiers de celui-ci ne seront pas scannés^).
echo u: Mettre à jour les outils permettant d'installer les applications ^(ADB...^).
echo N'importe quel autre choix: Revenir au menu principal. 
echo.
set /p app_choice=Faites votre choix: 
goto:eof

:select_app_file
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichier d\'application android ^(*.apk^)|*.apk|" "Sélection de l\'application à installer" "templogs\tempvar.txt"
goto:eof

:select_app_folder
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier contenant les applications Android"
goto:eof

:adb_not_finded
echo Les outils nécessaires au bon fonctionnement de ce script ne sont pas installés, ceux-ci vont donc être téléchargés sur le site de Google.
goto:eof

:adb_no_internet_connection
echo Les outils pour installer une application android ne sont pas installés ou n'ont pas pu être installés, le script ne peut continuer.
goto:eof

:no_file_selected_error
echo Aucune application sélectionnée, retour à la sélection d'applications.
goto:eof

:no_folder_selected_error
echo Aucun dossier d'applications sélectionné, retour à la sélection d'applications.
goto:eof

:adb_install_error
echo Une erreur s'est produite pendant l'installation de l'application. Vérifiez que le mode développeur est bien actif sur l'appareil Android et que le débogage USB est activé.
goto:eof

:adb_install_success
echo *********************************************
echo ***            Application installée            ***
echo *********************************************
goto:eof

:update_tools_begin_message
echo Mise à jour des outils en cours...
goto:eof

:update_tools_no_internet_connection
echo Aucune connexion à internet disponible, le script ne peux télécharger la mise à jour des outils.
goto:eof

:update_tools_download_error
echo Erreur pendant le téléchargement du fichier de mise à jour des outils.
goto:eof

:update_tools_extract_error
echo Erreur durant l'extraction du fichier téléchargé.
goto:eof

:update_tools_success
echo Mise à jour des outils effectuée.
goto:eof