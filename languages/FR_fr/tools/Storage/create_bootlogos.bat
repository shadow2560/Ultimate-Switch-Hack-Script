goto:%~1

:display_title
title Création de bootlogos %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de créer des bootlogos pour Atmosphere.
echo.
echo Vous devez refaire le logo  pour Atmosphere à chaque fois que vous mettez à jour Atmosphere en vous basant sur le fichier "fusee-secondary.bin" ou "package3" de celui-ci. La taille du logo est de 1280X720, il pourra être redimensionné s'il n'est pas à la bonne taille mais il est recommandé d'utilisé un logo déjà correctement dimensionné.
echo.
echo Pour le logo Nintendo Switch, il devra être refait si vous changez de firmware. La taille du logo est de 308X350, il pourra être redimensionné s'il n'est pas à la bonne taille mais il est recommandé d'utilisé un logo déjà correctement dimensionné.
echo.
echo Notez que les logos seront créés en respectant l'arborescence nécessaire pour qu'ils soient utilisés sur la SD, je conseille donc d'utiliser la racine de la SD comme dossier de sortie.
goto:eof

:action_choice
echo Que souhaitez-vous faire:
echo 1: Créer un logo pour remplacer le logo d'Atmosphere ^(lancement via fusee.bin^)?
echo 2: Créer un logo pour remplacer le logo Nintendo Switch?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:logo_file_selection
echo Veuillez renseigner le fichier  de l'image à utiliser pour le nouveau logo dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Fichiers image^(*.jpg;*.png;*.bmp^)|*.jpg;*.png;*.bmp|" "Sélection du fichier du logo" "templogs\tempvar.txt"
goto:eof

:no_logo_file_selected_error
echo Aucun fichier image renseigné, le script va s'arrêter.
goto:eof

:fusee_file_selection
echo Veuillez renseigner le fichier "fusee-secondary.bin" ou "package3" de la version d'Atmosphere que vous utilisez dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Tous les fichiers^(*.*^)|*.*|" "Sélection du fichier fusee-secondary.bin ou package3" "templogs\tempvar.txt"
goto:eof

:no_fusee_file_selected_error
echo Aucun fichier "fusee-secondary.bin" ou "package3" renseigné, le script va s'arrêter.
goto:eof

:resize_image_choice
set /p resize_image=Souhaitez-vous redimensionner l'image à la bonne taille? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:image_conversion_error
echo L'image n'a pas pu être convertie, le script va s'arrêter.
goto:eof

:outdir_folder_select
echo Vous allez devoir sélectionner le répertoire dans lequel créer le logo ^(racine de votre SD recommandé^).
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier de sortie des patches"
goto:eof

:no_outdir_source_selected_error
echo Aucun répertoire de sortie  renseigné, le script va s'arrêter.
goto:eof

:logo_creation_error
echo Une erreur s'est produite durant la création du logo.
goto:eof

:logo_creation_success
echo Logo créé avec succès.
goto:eof