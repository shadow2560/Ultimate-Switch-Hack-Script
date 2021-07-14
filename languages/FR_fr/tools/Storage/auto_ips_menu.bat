goto:%~1

:display_title
title Création de sig_patches  %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:no_internet_connection_error
echo Aucune connexion à internet disponible, le script va s'arrêter.
goto:eof

:intro
echo Ce script permet de créer les sig_patches pour Atmosphere.
echo.
echo Vous devez créer les loaders patches à chaque fois que vous mettez à jour Atmosphere en vous basant sur le fichier "fusee-secondary.bin" de celui-ci.
echo.
echo Pour les FS_patches et ES_patches, vous devrez les mettres à jour si vous mettez à jour le firmware de la console en utilisant les dernières clés  récupérable via Lockpick-RCM ainsi que via un dossier contenant les fichiers du firmware.
echo.
echo Notez que les patches seront créés en respectant l'arborescence nécessaire pour qu'ils soient utilisés sur la SD, je conseille donc d'utiliser la racine de la SD comme dossier de sortie.
goto:eof

:action_choice
echo Que souhaitez-vous faire:
echo 1: Créer les loader_patches?
echo 2: Créer les FS_patches et les ES_patches?
echo 3: Créer les FS_patches?
echo 4: Créer les ES_patches?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:keys_file_selection
echo Veuillez renseigner le fichier de clés lié à la console dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Fichier de liste de clés Switch^(*.*^)|*.*|" "Sélection du fichier de clés pour Hactool" "templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo Aucun fichier clés renseigné, le script va s'arrêter.
goto:eof

:fusee_file_selection
echo Veuillez renseigner le fichier "fusee-secondary.bin" de la version d'Atmosphere que vous utilisez dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Fichier bin^(*.bin^)|*.bin|" "Sélection du fichier fusee-secondary.bin" "templogs\tempvar.txt"
goto:eof

:no_fusee_file_selected_error
echo Aucun fichier "fusee-secondary.bin" renseigné, le script va s'arrêter.
goto:eof

:package_folder_select
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier contenant la mise à jour extraite"
goto:eof

:bad_choice_error
echo Ce choix n'est pas supporté.
goto:eof

:no_firmware_source_selected_error
echo Aucun répertoire de mise à jour  renseigné, le script va s'arrêter.
goto:eof

:outdir_folder_select
echo Vous allez devoir sélectionner le répertoire dans lequel créer les patches ^(racine de votre SD recommandé^).
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier de sortie des patches"
goto:eof

:no_outdir_source_selected_error
echo Aucun répertoire de sortie  renseigné, le script va s'arrêter.
goto:eof

:loader_patches_creation_success
echo Loader_patches créés avec succès.
goto:eof

:loader_patches_creation_error
echo Erreur durant la création des loader_patches, vérifiez que vous avez bien indiqué le fichier "fusee-secondary.bin" de la version d'Atmosphere que vous utilisez.
goto:eof

:FS_patches_creation_success
echo FS_patches créés avec succès.
goto:eof

:FS_patches_creation_error
echo Erreur durant la création des FS_patches, vérifiez que vous avez bien dumpé et indiqué les dernières clés de votre console et vérifiez le dossier du firmware source.
goto:eof

:ES_patches_creation_success
echo ES_patches créés avec succès.
goto:eof

:ES_patches_creation_error
echo Erreur durant la création des ES_patches, vérifiez que vous avez bien dumpé et indiqué les dernières clés de votre console et vérifiez le dossier du firmware source.
goto:eof

:firmware_choice_begin
echo Choisissez le firmware que vous souhaitez préparer?
echo.
echo Liste des firmwares:
goto:eof

:firmware_choice_end
echo F: Ouvrir le dossier contenant les firmwares déjà téléchargé?
echo C: Choisir un dossier de firmware?
echo N'importe quel autre choix: Revenir au choix de l'action principale de ce script.
echo.
set /p firmware_choice=Entrez le firmware souhaité ou une action à faire: 
goto:eof

:firmware_downloading_begin
echo Téléchargement du firmware %firmware_choice%...
goto:eof

:firmware_downloading_md5_error
echo Le md5 du firmware ne semble pas être correct. Veuillez vérifier votre connexion internet ainsi que l'espace disponible sur votre disque dur puis relancer le script. 
goto:eof

:firmware_downloading_md5_retry
echo Le md5 du firmware ne semble pas être correct, le téléchargement va être réessayé.
goto:eof

:firmware_exist_but_bad_md5_tested_error
echo Le fichier du firmware semble exister mais son MD5 est incorrect, il va donc être retéléchargé.
goto:eof

:firmware_downloading_end
echo Téléchargement du firmware %firmware_choice% terminé.
goto:eof

:extract_firmware_begin
echo Extraction du firmware pour la suite des traitements...
goto:eof

:daybreak_convert_begin
echo Conversion et vérification du firmware...
goto:eof

:daybreak_convert_keys_warning
echo Attention: Des clés semblent être manquantes dans votre fichiers de clés, la conversion ne peut être ni vérifiée ni effectuée.
echo Pour que cela fonctionne, veuillez dumper les dernières clés grâce à la dernière version du payload Lockpick-RCM et indiquez ensuite le fichier dumpé comme fichier de clés.
goto:eof