goto:%~1

:display_title
title Réparation PRODINFO %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de faire des opérations de réparations sur PRODINFO.
echo.
echo Attention, avant de procéder à un flash d'un tel fichier, veuillez d'abord faire un dump de votre fichier PRODINFO actuel.
echo.
echo Vous aurez besoin du fichier de clés de la console dumpé via Lockpick-RCM ainsi que d'un fichier PRODINFO de cette même console.
goto:eof

:prodinfo_input_file_select_choice
echo Sélectionnez le fichier prodinfo source.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier prodinfo" "templogs\tempvar.txt"
goto:eof

:prodinfo_input_file_empty_error
echo Le fichier prodinfo servant de base ne peut être vide, le script va s'arrêter.
goto:eof

:nand_type_must_be_prodinfo_error
echo Le type de dump doit contenir la partition prodinfo, le processus ne peut continuer.
goto:eof

:prod_keys_file_select_choice
echo Sélectionnez le fichier contenant les clés dumpée sur la console via Lockpick-RCM.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier clés de la console" "templogs\tempvar.txt"
goto:eof

:prod_keys_file_empty_error
echo Le fichier de clés ne peut être vide, le script va s'arrêter.
goto:eof

:decrypt_biskeys_not_valid_error
echo Le fichier de clés fourni ne permet pas de déchiffrer la partition PRODINFO, le script va s'arrêter.
goto:eof

:select_action_choice
echo Que souhaitez-vous faire:
echo 1: Vérifier les hashes du fichier PRODINFO?
echo 2: Recalculer et réécrire les hashes du fichiers PRODINFO?
echo 3: Obtenir les informations du PRODINFO dans un fichier texte ^(surtout utile au débogage^)?
echo Tout autre choix: Revenir au menu précédent.
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:hashes_errors_found
echo Erreurs de hashes trouvées.
goto:eof

:hashes_errors_not_found
echo Aucune erreur de hashes trouvée.
goto:eof

:output_folder_choice
echo Vous allez devoir sélectionner le dossier vers lequel créer le fichier.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier"
goto:eof

:output_folder_empty_error
echo Le répertoire de sortie  ne peut être vide, la fonction va être annulée.
goto:eof

:erase_existing_file_choice
set /p erase_output_file=Ce dossier contient déjà des fichiers générés par ce script, souhaitez-vous vraiment continuer en écrasant les fichiers existants ^(si oui, les fichiers seront supprimés juste après ce choix^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:create_prodinfo_error
echo Une erreur s'est produite durant la procédure de création du fichier.
goto:eof

:create_prodinfo_success
echo Procédure de création du fichier  effectuée avec succès.
goto:eof

:prodinfo_encrypted_usage
echo Le fichier à restaurer sur la console sera la version chiffrée ^(nom du fichier finissant par "encrypted"^).
goto:eof

:return_to_action_choice_question
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous relancer une action avec les mêmes fichiers sources? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof