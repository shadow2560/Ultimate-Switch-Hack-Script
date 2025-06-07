goto:%~1

:display_title
title Extraire NCAs d'identification %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet d'obtenir les NCAs permettant d'identifier un firmware.
echo.
echo Ceci est utile pour, par exemple, mettre à jour plus facilement les données d'un projet comme FVI.
echo Si le fichier "titles_output.txt" existe dans le répertoire sélectionné pour l'extraction des informations il sera remplacé.
echo.
echo Vous devrez choisir le firmware sur lequel travailler ainsi qu'un répertoire dans lequel les informations seront extraites.
goto:eof

:firmware_preparation_error
echo Aucun firmware sélectionné ou une erreur s'est produite durant la préparation du firmware.
goto:eof

:keys_file_choice
echo Vous allez devoir choisir le fichier de clés à utiliser pour déchiffrer le firmware.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier de clés" "templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo Aucun fichier sélectionné, le script va s'arrêter.
goto:eof

:output_folder_choice
echo Vous allez devoir sélectionner le dossier vers lequel créer le fichier contenant les informations extraites.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier"
goto:eof

:output_folder_empty_error
echo Le répertoire contenant  les informations extraites ne peut être vide.
goto:eof

:extract_error
echo Erreur durant l'extraction des informations.
goto:eof

:extract_sucess
echo Informations extraites dans le fichier "%output_folder%%titles_output_file%".
goto:eof