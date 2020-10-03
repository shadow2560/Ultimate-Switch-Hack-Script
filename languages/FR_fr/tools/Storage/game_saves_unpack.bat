goto:%~1

:display_title
title Extraction de sauvegardes de jeux %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet d'extraire le contenu d'un fichier de sauvegarde de jeu ou de fichiers de sauvegardes de jeux contenues dans un dossier.
echo Pour pouvoir utiliser ce script, vous devrez au préalable récupérer les sauvegardes à extraire dans le dossier "save" de la partition "USER" de la RAWNAND ou à l'endroit où se trouve ces fichiers si vous l'avez configuré autrement dans votre CFW, grâce à HacDiskMount pour la RAWNAND; cette action ne sera pas couverte par ce script.
echo Une fois la sauvegarde extraite, vous devrez identifier par vous-même le jeu auquel elle est liée (vous pouvez utiliser Checkpoint ou EdiZon pour vous y aider en extrayant la sauvegarde des jeux) et remplacer ensuite les fichiers de la sauvegarde extraite par Checkpoint ou EdiZon par les fichiers extraits par ce script puis vous pourrez ensuite restaurer la sauvegarde ainsi modifiée via Checkpoint ou EdiZon.
goto:eof

:main_action_choice
echo Que souhaitez-vous faire:
echo 1: Extraire un fichier de sauvegarde?
echo 2: Extraire tous les fichiers de sauvegardes d'un dossier ^(les sous-dossiers ne seront pas analysés^)?
echo Tout autre choix: Revenir au menu précédent?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:input_file_choice
echo Vous allez devoir sélectionner le fichier de la sauvegarde de jeu.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier de la sauvegarde de jeu" "templogs\tempvar.txt"
goto:eof

:no_input_file_error
echo Aucun fichier d'entrée sélectionné, retour au début du script.
goto:eof

:extract_begin
echo Extraction en cours...
goto:eof

:extract_end
echo Extraction terminée.
goto:eof

:input_folder_choice
echo Vous allez devoir sélectionner le répertoire contenant les sauvegardes de jeux à extraire.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier d'entrée"
goto:eof

:no_input_folder_error
echo Aucun dossier d'entrée sélectionné, retour au début du script.
goto:eof

:output_folder_choice
echo Vous allez maintenant devoir sélectionner le répertoire de sortie.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier de sortie"
goto:eof

:no_output_folder_error
echo Aucun dossier de sortie sélectionné, retour au début du script.
goto:eof