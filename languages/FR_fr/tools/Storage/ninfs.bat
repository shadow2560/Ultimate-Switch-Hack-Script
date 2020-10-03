goto:%~1

:display_title
title Ninfs %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet d'utiliser Ninfs pour monter un fichier de dump de la rawnand sur votre système.
echo Pour démonter le lecteur, appuyez sur ctrl+c ou fermez la fenêtre exécutant Ninfs.
goto:eof

:first_action_choice
echo Ninfs
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Utiliser Ninfs pour monter un fichier de la rawnand?
echo 2: Installer Winfsp ^(à ne faire qu'une seule fois^)?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:dump_not_exist_error
echo Le fichier de dump n'a pas été indiqué.
goto:eof

:ninfs_input_begin
echo Vous allez devoir sélectioner un fichier de la rawnand   à utiliser avec Ninfs. Pour revenir au menu précédent, ne sélectionnez aucun fichier.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tout les fichiers ^(*.*^)|*.*|" "Sélection du fichier de dump de la rawnand" "templogs\tempvar.txt"
goto:eof

:ninfs_nand_type_error
echo Ninfs ne peut être utilisé sur le type de nand sélectionner, le script ne peut donc pas continuer.
goto:eof

:ninfs_biskeys_not_valid_error
echo Erreur lors de la vérification du fichier des Bis keys, le script ne peut donc pas continuer.
goto:eof

:biskeys_file_select_choice
echo Sélectionnez le fichier contenant les Bis keys à utiliser.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tout les fichiers ^(*.*^)|*.*|" "Sélection du fichier contenant les Bis keys" "templogs\tempvar.txt"
goto:eof

:biskeys_file_not_selected_error
echo Aucun fichier de Bis keys sélectionné, impossible de continuer.
goto:eof