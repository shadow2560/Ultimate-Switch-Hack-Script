goto:%~1

:display_title
title Spoof de la licence de SXOS %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de créer un fichier "boot.dat" avec un spoof pour une licence.
echo.
echo Vous devez avoir le fingerprint et le fichier "license.dat" associé d'une console ou le fichier "license_request.dat" de la console ciblée. Une méthode ne nécessitant pas ces éléments est également possible et recommandée.
echo.
echo Pour trouver le fingerprint d'une console, lancer SXOS et aller dans "album" pour afficher le menu de SXOS, ensuite appuyer une fois sur "R" et vous trouverez le "console fingerprint" sous le numéro de la licence.
echo Pour générer le fichier "license_request.dat", lancer SXOS sans licence sur la console ciblée et cliquer sur "Launch CFW" et un message indiquant que le fichier a été créé devrait s'afficher.
goto:eof

:action_choice
echo Que voulez-vous faire:
echo 1: Créer les fichiers avec une license par défaut ^(recommandé, ne requière aucun fichier^)?
echo 2: Créer les fichiers avec un fichier "license_request.dat"?
echo 3: Créer un fichier "boot.dat" modifié pour être compatible avec un fingerprint et un fichier "license.dat"?
echo Tout autre choix: Revenir au menu précédent?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:license_request_file_path_selection
	echo Veuillez renseigner le fichier license_request  de la console ciblée.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Fichier dat^(*.dat^)|*.dat|" "Sélection du fichier license_request" "templogs\tempvar.txt"
goto:eof

:no_license_request_file_selected_error
echo Aucun fichier "license_request.dat" renseigné, le script va s'arrêter.
goto:eof

:fingerprint_set
set /p fingerprint=Entrez le fingerprint de la console à spoofer ^(32 caractères hexadécimaux^) ^(laissez vide pour créer une licence préconfigurée ou entrez "0" pour quitter le script^): 
goto:eof

:fingerprint_error_number_chars
echo Le nombre de caractère saisies doit être de 32.
goto:eof

:fingerprint_error_char_not_authorized
echo Un caractère saisie est incorrect.
goto:eof

:outdir_folder_select
echo Vous allez devoir sélectionner le répertoire dans lequel créer les fichiers.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier de sortie des fichiers"
goto:eof

:autoboot_parram_choice
set /p autoboot=Désactiver l'autoboot de SXOS? ^(%lng_yes_choice%/%lng_no_choice%^):
goto:eof

:emunand_sd_file_param_choice
set /p emunand_sd_file=Emunand via fichiers? ^(%lng_yes_choice%/%lng_no_choice%^):
goto:eof

:boot_creation_success
echo Fichier^(s^) créé^(s^) avec succès.
goto:eof

:boot_creation_error
echo Erreur durant le processus.
goto:eof