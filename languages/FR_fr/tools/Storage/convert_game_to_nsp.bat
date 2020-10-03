goto:%~1

:display_title
title Convertion XCI vers NSP %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va permettre de convertir un fichier XCI au format NSP, fichier installable via Tinfoil, SXOS ou encore le DevMenu.
echo Attention: Il est préférable de ne pas exécuter ce script sur une partition formatée en FAT32 à cause de la limite de création de fichiers de plus de  4 GO de ce système de fichiers.
goto:eof

:define_new_keys_file_choice
set /p define_new_keys_file=Souhaitez-vous définir un nouveau fichier de clés par défaut? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:keys_file_not_finded
echo Fichiers clés non trouvé, veuillez suivre les instructions.
goto:eof

:keys_file_selection
IF /i NOT "%define_new_keys_file%"=="o" (
	echo Veuillez renseigner le fichier de clés dans la fenêtre suivante.
	pause
)
%windir%\system32\wscript.exe //Nologo "..\Storage\functions\open_file.vbs" "" "Fichier de liste de clés Switch^(*.*^)|*.*|" "Sélection du fichier de clés pour Hactool" "..\..\templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo Aucun fichier clés renseigné, le script va s'arrêter.
goto:eof

:xci_file_selection
echo Vous allez devoir sélectionner le fichier XCI à convertir.
pause
%windir%\system32\wscript.exe //Nologo ..\Storage\functions\open_file.vbs "" "Fichier de jeu Switch ^(*.xci^)|*.xci|" "Sélection du jeu à convertir" "..\..\templogs\tempvar.txt"
goto:eof

:no_game_selected_error
echo Aucun jeu sélectionné, la conversion est annulée.
goto:eof

:output_folder_select
echo Vous allez devoir sélectionner le dossier vers lequel le NSP converti sera extrait.
pause
%windir%\system32\wscript.exe //Nologo ..\Storage\functions\select_dir.vbs "..\..\templogs\tempvar.txt" "Sélection du dossier de sortie"
goto:eof

:no_output_folder_error
echo Aucun dossier sélectionné, la conversion est annulée.
goto:eof

:rename_param_choice
set /p rename_target=Souhaitez-vous que le NSP généré soit renommé grâce au nom du jeu plutôt que grâce à l'ID de celui-ci? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:kipncaid_param_choice
set /p keepncaid=Souhaitez-vous que l'ID des NCA du NSP soit gardés ^(ne pas activer cette option est recommandé^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:converting_error
echo Erreur pendant la tentative de conversion.
goto:eof

:converting_success
echo Conversion terminée avec succès.
goto:eof