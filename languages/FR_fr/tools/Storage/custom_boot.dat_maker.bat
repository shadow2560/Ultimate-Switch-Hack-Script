goto:%~1

:display_title
title Convertion d'un payload en  boot.dat %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de convertir un payload en fichier "boot.dat", ceci peut être utile pour ceux utilisant du matériel lié à SXOS.
goto:eof

:payload_input_file_select_choice
echo Sélectionnez le payload à convertir.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichier bin ^(*.bin^)|*.bin|" "Sélection du payload" "templogs\tempvar.txt"
goto:eof

:payload_input_file_empty_error
echo Le choix du payload ne peut être vide, le script va s'arrêter.
goto:eof

:output_folder_choice
echo Vous allez devoir sélectionner le dossier vers lequel créer le fichier "boot.dat".
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier"
goto:eof

:output_folder_empty_error
echo Le répertoire pour créé le fichier "boot.dat" ne peut être vide, la fonction va être annulée.
goto:eof

:erase_existing_file_choice
set /p erase_output_file=Ce dossier contient déjà un fichier "%payload_output_file%", souhaitez-vous vraiment continuer en écrasant le fichier existant ^(si oui, le fichier sera supprimé juste après ce choix^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:create_payload_error
echo Une erreur s'est produite durant la création du fichier "boot.dat".
goto:eof

:create_payload_success
echo Création du fichier "boot.dat" effectuée avec succès.
goto:eof