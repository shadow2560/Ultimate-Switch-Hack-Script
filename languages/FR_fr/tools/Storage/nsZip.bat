goto:%~1

:display_title
title Compression/décompression d'un jeu %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va permettre de compresser/décompresser un fichier XCI/NSP.
echo Attention: Il est préférable de ne pas exécuter ce script sur une partition formatée en FAT32 à cause de la limite de création de fichiers de plus de  4 GO de ce système de fichiers.
goto:eof

:input_file_choice
echo Vous allez devoir sélectionner le fichier XCI/NSP à compresser/décompresser.
pause
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\open_file.vbs "" "Fichier de jeu Switch ^(*.xci;*.nsp;*.xciz;*.nspz^)|*.xci;*.nsp;*.xciz;*.nspz;" "Sélection du jeu à compresser/décompresser" "templogs\tempvar.txt"
goto:eof

:no_input_file_selected_error
echo Aucun jeu sélectionné, la conversion est annulée.
goto:eof

:output_folder_choice
echo Maintenant, sélectionner le dossier de sortie.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier de sortie"
goto:eof

:no_output_folder_selected_error
echo Aucun dossier de sortie sélectionné, le script va s'arrêter.
goto:eof

:compression_level_choice
set /p compression_level=Choisir le niveau de compression ^(1 pour le minimum, 22 pour le maximum^): 
goto:eof

:no_empty_value_error
echo Cette valeur ne peut être vide.
goto:eof

:bad_value_error
echo Valeur non autorisée.
goto:eof

:compression_level_too_low_error
echo La valeur ne peut être inférieur à 1.
goto:eof

:compression_level_too_high_error
echo La valeur ne peut être supérieur à 22.
goto:eof

:operation_error
echo Erreur pendant la tentative de compression/décompression.
goto:eof

:operation_success
echo Compression/décompression terminée avec succès.
goto:eof