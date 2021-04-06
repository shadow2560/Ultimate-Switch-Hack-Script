goto:%~1

:display_title
title Spoof de la licence de SXOS %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de créer un fichier "boot.dat" avec un spoof pour une licence.
echo.
echo Vous devez avoir le fichier "boot.dat" de SXOS 3.1.0 ainsi que le fingerprint et la licence d'une console.
echo.
echo Pour trouver le fingerprint de la console, lancer SXOS et aller dans "album" pour afficher le menu de SXOS, ensuite appuyer une fois sur "R" et vous trouverez le "console fingerprint" sous le numéro de la licence.
goto:eof

:boot_file_selection
	echo Veuillez renseigner le fichier "boot.dat" à modifier.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Fichier dat^(*.dat^)|*.dat|" "Sélection du fichier du boot.dat à modifier" "templogs\tempvar.txt"
goto:eof

:no_boot_file_selected_error
echo Aucun fichier SXOS renseigné, le script va s'arrêter.
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

:boot_creation_success
echo Fichier modifié avec succès.
goto:eof

:boot_creation_error
echo Erreur durant la modification du fichier.
goto:eof