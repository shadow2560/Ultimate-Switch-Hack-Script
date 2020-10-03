goto:%~1

:display_title
title Découper une nand %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de découper un dump de la rawnand en plusieurs parties, ceci peut être utile pour utiliser ensuite ce dump pour l'Emunand de Atmosphere.
goto:eof

:input_rawnand_choice
echo Vous allez devoir sélectionner le fichier de la rawnand à découper.
pause
%windir%\system32\wscript.exe //Nologo "tools\Storage\functions\open_file.vbs" "" "Fichier bin^(*.bin^)|*.bin|" "Sélection du fichier de dump de la nand" "templogs\tempvar.txt"
goto:eof

:no_input_file_selected_error
echo Aucun fichier sélectionné, le script va s'arrêter.
goto:eof

:invalid_input_file_error
echo Le fichier sélectionné n'est pas un dump de rawnand valide ou est un fichier de dump d'une rawnand déjà découpé, le script ne peut continuer.
goto:eof

:output_folder_choice
echo Vous allez maintenant devoir sélectionner le répertoire vers lequel seront copié les fichiers du dump découpé. Notez que l'archive byte sera appliquer au dossier pour rendre celui-ci compatible avec l'Emunand d'Atmosphere.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier de sortie"
goto:eof

:no_output_selected_error
echo Aucun dossier sélectionné, le script va s'arrêter.
goto:eof

:parts_number_choice
set /p parts_number=Choisissez le nombre de partie que vous souhaitez avoir ^(de 2 jusqu'à 64^): 
goto:eof

:empty_parts_number_error
echo Le nombre de parties ne peut être vide.
goto:eof

:bad_value_parts_number_error
echo Une valeur incorrecte a été saisie pour le nombre de parties.
goto:eof

:parts_number_char_error
echo Un caractère non autorisé a été saisie dans le choix du nombre de parties.
goto:eof

:parts_number_too_low_error
echo Le nombre de parties ne peut être inférieur à 2.
goto:eof

:parts_number_too_high_error
echo Le nombre de parties ne peut être supérieur à 64.
goto:eof

:output_rename_choice
set /p rename_files=Souhaitez-vous que les fichiers splittés soient renommés pour être compatible avec l'emunand de Atmosphere? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:not_enough_disk_space_error
echo Il n'y a pas assez d'espace libre à l'emplacement sur lequel vous souhaitez copier votre dump, le script va s'arrêter.
goto:eof

:copying_begin
echo Copie en cours...
goto:eof

:copying_error
	echo Il semble qu'une erreur se soit produite pendant la copie.
	echo Vérifiez que vous avez au moins 30 GO de libre sur la partition sur lequel le fichier est copié puis réessayez.
	echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier le fichier.
goto:eof

:copying_end
echo Copie terminée.
goto:eof