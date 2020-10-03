goto:%~1

:display_title
title Diminuer la version du firmware nécessaire pour un jeu %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va permettre de rendre un NSP compatible avec le firmware de la Switch le plus bas possible.
echo Attention: Il est préférable de ne pas exécuter ce script sur une partition formatée en FAT32 à cause de la limite de création de fichiers de plus de  4 GO de ce système de fichiers.
goto:eof

:define_new_keys_file_choice
set /p define_new_keys_file=Souhaitez-vous définir un nouveau fichier de clés par défaut? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:keys_file_not_finded_error
echo Fichiers clés non trouvé, veuillez suivre les instructions.
goto:eof

:keys_file_choice
IF /i NOT "%define_new_keys_file%"=="o" (
	echo Veuillez renseigner le fichier de clés dans la fenêtre suivante.
	pause
)
%windir%\system32\wscript.exe //Nologo "..\Storage\functions\open_file.vbs" "" "Fichier de liste de clés Switch^(*.*^)|*.*|" "Sélection du fichier de clés pour Hactool" "..\..\templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo Aucun fichier clés renseigné, le script va s'arrêter.
goto:eof

:input_file_choice
echo Vous allez devoir sélectionner le fichier NSP à convertir.
pause
%windir%\system32\wscript.exe //Nologo ..\Storage\functions\open_file.vbs "" "Fichier de jeu Switch ^(*.nsp^)|*.nsp|" "Sélection du jeu à convertir" "..\..\templogs\tempvar.txt"
goto:eof

:no_input_file_selected_error
echo Aucun jeu sélectionné, la conversion est annulée.
goto:eof

:output_folder_choice
echo Vous allez devoir sélectionner le dossier vers lequel le NSP converti sera extrait.
pause
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "..\..\templogs\tempvar.txt" "Sélection du dossier de sortie"
goto:eof

:no_output_folder_selected_error
echo Aucun dossier de sortie sélectionné, la conversion est annulée.
goto:eof

:converting_error
echo Erreur pendant la tentative de conversion.
goto:eof

:converting_success
echo Conversion terminée avec succès.
goto:eof