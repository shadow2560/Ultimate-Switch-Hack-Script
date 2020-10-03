goto:%~1

:display_title
title Réparation keyblobs BOOT0 %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de reconstruire un fichier BOOT0 en cas d'erreurs sur la récupération des key_blob_XX avec Lockpick-RCM.
echo.
echo Attention, avant de procéder à un flash d'un tel fichier, veuillez d'abord faire un dump de votre fichier BOOT0 actuel et tenter de restaurer la console grâce à un package créé via ChoiDuJour.
echo Notez également qu'en firmware 6.1.0 ou inférieur, le démarrage de manière officielle ne fonctionnera pas et la console restera sur un écran noir, le démarrage ne sera possible qu'en CFW. Cependant, en firmware supérieur au 6.1.0, le démarrage de manière officielle sera de nouveau possible.
echo.
echo Vous aurez besoin du fichier de clés de la console dumpé via Lockpick-RCM ainsi que d'un fichier BOOT0 du même firmware qui est actuellement installé sur votre console ^(fichier BOOT0 créé via ChoiDuJour ou dumpé à partir de votre console^).
goto:eof

:boot0_input_file_select_choice
echo Sélectionnez le fichier BOOT0 qui sera utilisé comme base de reconstruction.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tout les fichiers ^(*.*^)|*.*|" "Sélection du fichier BOOT0" "templogs\tempvar.txt"
goto:eof

:boot0_input_file_empty_error
echo Le fichier BOOT0 servant de base ne peut être vide, le script va s'arrêter.
goto:eof

:nand_type_must_be_boot0_error
echo Le type de dump doit être BOOT0, le processus ne peut continuer.
goto:eof

:nand_soc_must_be_erista_error
echo Le type de SoC doit être Erista, le processus ne peut continuer.
goto:eof

:prod_keys_file_select_choice
echo Sélectionnez le fichier contenant les clés dumpée sur la console via Lockpick-RCM.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tout les fichiers ^(*.*^)|*.*|" "Sélection du fichier clés de la console" "templogs\tempvar.txt"
goto:eof

:prod_keys_file_empty_error
echo Le fichier de clés ne peut être vide, le script va s'arrêter.
goto:eof

:output_folder_choice
echo Vous allez devoir sélectionner le dossier vers lequel créer le fichier BOOT0 reconstruit.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier"
goto:eof

:output_folder_empty_error
echo Le répertoire pour créé le fichier BOOT0 reconstruit ne peut être vide, la fonction va être annulée.
goto:eof

:erase_existing_file_choice
set /p erase_output_file=Ce dossier contient déjà un fichier "%boot0_output_file%", souhaitez-vous vraiment continuer en écrasant le fichier existant ^(si oui, le fichier sera supprimé juste après ce choix^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:create_boot0_error
echo Une erreur s'est produite durant la création du fichier BOOT0 à reconstruire.
echo.
echo Cette erreur peut signifier qu'il manque certaines clés  dans votre fichier de clés, veuillez donc le vérifier avant de réessayer cette procédure de débrickage.
echo.
echo Clés communes nécessaires, trouvable assez facilement sur internet:
echo keyblob_00 à keyblob_05, keyblob_key_source_00 à keyblob_key_source_05, keyblob_mac_key_source
echo.
echo Clés uniques à la console nécessaires:
echo secure_boot_key, tsec_key, 
echo.
echo Clés uniques à la console optionnelles, au moins un des deux groupes nécessaires mais les deux seraient évidemment mieux:
echo keyblob_key_00 à keyblob_key_05, keyblob_mac_key_00 à keyblob_mac_key_05
echo.
goto:eof

:create_boot0_success
echo Création du fichier BOOT0 à reconstuire effectuée avec succès.
goto:eof