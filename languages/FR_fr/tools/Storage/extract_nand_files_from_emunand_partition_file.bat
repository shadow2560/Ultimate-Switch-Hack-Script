goto:%~1

:display_title
title Extraire Nand d'un fichier de partition emunand %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet d'extraire le fichier BOOT0, BOOT1 et rawnand.bin à partir d'un fichier utilisé par l'emunand via partition.
goto:eof

:input_file_choice
echo Vous allez devoir sélectionner le fichier de l'emunand.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers bin ^(*.bin^)|*.bin|" "Sélection du fichier de dump de l\'emunand" "templogs\tempvar.txt"
goto:eof

:no_input_file_error
echo Aucun fichier sélectionné, le script va s'arrêter.
goto:eof

:output_folder_choice
echo Vous allez maintenant devoir sélectionner le répertoire vers lequel sera copié le fichier "BOOT0", "BOOT1" et "rawnand.bin". Attention, le dossier devra se trouver sur une partition supportant les fichiers de plus de 4 GO ^(EXFAT, NTFS^).
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier de sortie"
goto:eof

:no_output_folder_error
echo Aucun dossier sélectionné, le script va s'arrêter.
goto:eof

:erase_boot0_choice
set /p erase_existing_dump_boot0=Un fichier "BOOT0" a été trouvé à l'emplacement de copie du nouveau dump, souhaitez-vous écraser le dump précédent ^(la suppression du dump sera faite tout de suite après ce choix donc soyez prudent^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:erase_boot1_choice
set /p erase_existing_dump_boot1=Un fichier "BOOT1" a été trouvé à l'emplacement de copie du nouveau dump, souhaitez-vous écraser le dump précédent ^(la suppression du dump sera faite tout de suite après ce choix donc soyez prudent^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:erase_rawnand_choice
set /p erase_existing_dump_rawnand=Un fichier "rawnand.bin" a été trouvé à l'emplacement de copie du nouveau dump, souhaitez-vous écraser le dump précédent ^(la suppression du dump sera faite tout de suite après ce choix donc soyez prudent^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:canceled
echo Opération annulée.
goto:eof

:not_enough_disk_space_error
echo Il n'y a pas assez d'espace libre à l'emplacement sur lequel vous souhaitez copier votre dump, le script va s'arrêter.
goto:eof

:copying_begin
echo Copie en cours...
goto:eof

:copying_error
echo Il semble qu'une erreur se soit produite pendant la copie, les fichiers créés vont être supprimés s'ils existent.
echo Vérifiez que la partition sur laquelle vous copiez les fichiers est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel les fichiers sont copié puis réessayez.
echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier les fichiers.
goto:eof

:copying_boot0_error
echo Erreur de copie du fichier "BOOT0".
goto:eof

:copying_boot1_error
echo Erreur de copie du fichier "BOOT1".
goto:eof

:copying_rawnand_error
echo Erreur de copie du fichier "rawnand.bin".
goto:eof

:copying_success
echo Copie terminée.
goto:eof

:launch_hacdiskmount_choice
set /p launch_hacdiskmount=Souhaitez-vous lancer HacDiskMount pour vérifier que le dump a bien été copié ^(rawnand.bin^) et qu'il fonctionne correctement ^(recommandé^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:output_rawnand_size_error
echo Il semble que la taille du fichier créé ne corresponde pas à la taille que devrait faire le dump de la rawnand, le fichier créé va donc être supprimé.
echo Il est donc conseillé de refaire le dump de l'emunand puis de réessayer d'exécuter ce script.
echo Si le dump est correct, vérifiez l'espace disque sur la partition sur laquelle vous essayez de copier le dump et vérifiez aussi que cette même partition ai un système de fichier supportant les fichiers de plus de 4 GO.
goto:eof

:output_boot0_size_error
echo Il semble que la taille du fichier créé ne corresponde pas à la taille que devrait faire le dump de la partition BOOT0, le fichier créé va donc être supprimé.
echo Il est donc conseillé de refaire le dump de l'emunand puis de réessayer d'exécuter ce script.
echo Si le dump est correct, vérifiez l'espace disque sur la partition sur laquelle vous essayez de copier le dump.
goto:eof

:output_boot1_size_error
echo Il semble que la taille du fichier créé ne corresponde pas à la taille que devrait faire le dump de la partition BOOT1, le fichier créé va donc être supprimé.
echo Il est donc conseillé de refaire le dump de l'emunand puis de réessayer d'exécuter ce script.
echo Si le dump est correct, vérifiez l'espace disque sur la partition sur laquelle vous essayez de copier le dump.
goto:eof

:input_dump_invalid_error
echo Le dump sélectionné ne semble pas être correct, le script va donc se terminer sans rien faire.
goto:eof