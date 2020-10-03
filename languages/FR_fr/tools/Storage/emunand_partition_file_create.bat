goto:%~1

:display_title
title Création de partition emunand %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de créer un fichier qui pourra ensuite être injecté dans une partition de la SD pour booter en emunand.
echo Au préalable, vous devez avoir un dossier contenant les fichiers "BOOT0", "BOOT1" et, selon le moyen de dump utilisé, le ou les fichiers de la rawnand ^("rawnand.bin" ou "rawnand.bin.XX" pour Hekate et "full.XX.bin" pour SX OS ^(XX est pour les dumps splittés et représente le numéro de la partie^)^).
echo Notez que pour l'instant, les dumps splittés de Hekate supportés ne sont que les dumps en 15 ou 30 parties, le support d'autres types de dump sera ajouté plus tard.
echo Une fois le dump terminé, il sera nommé "emunand_partition.bin" et se trouvera dans le répertoire indiqué lors du script.
goto:eof

:cfw_dump_choice
echo Quel moyen avez-vous utilisé pour faire votre dump?
echo 1: Hekate.
echo 2: SX OS.
echo N'importe quel autre choix: Retourne au menu précédent.
echo.
set /p cfw_used=Faites votre choix: 
goto:eof

:dump_folder_choice
echo Vous allez devoir sélectionner le répertoire dans lequel se trouve vos fichiers de dump.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier du dump de la nand"
goto:eof

:no_folder_selected_error
echo Aucun dossier sélectionné, le script va s'arrêter.
goto:eof

:boot0_not_finded_error
echo Fichier "BOOT0" introuvable, le script va donc s'arrêter.
goto:eof

:boot1_not_finded_error
echo Fichier "BOOT1" introuvable, le script va donc s'arrêter.
goto:eof

:missing_files_in_dump_error
echo Il semble que des fichiers du dump soient manquants, la copie ne peut donc pas avoir lieu et ce script va s'arrêter.
goto:eof

:output_folder_choice
echo Vous allez maintenant devoir sélectionner le répertoire vers lequel sera copié le fichier "emunand_partition.bin" du dump joint. Attention, le dossier devra se trouver sur une partition supportant les fichiers de plus de 4 GO ^(EXFAT, NTFS^).
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier de sortie"
goto:eof

:no_output_folder_error
echo Aucun dossier sélectionné, le script va s'arrêter.
goto:eof

:erase_emunand_file_exist_in_output_folder_choice
set /p erase_existing_dump=Un fichier "emunand_partition.bin" a été trouvé à l'emplacement de copie du nouveau dump, souhaitez-vous écraser le dump précédent ^(la suppression du dump sera faite tout de suite après ce choix donc soyez prudent^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:canceled
echo Opération annulée.
goto:eof

:not_enough_disk_free_space_error
echo Il n'y a pas assez d'espace libre à l'emplacement sur lequel vous souhaitez copier le fichier, le script va s'arrêter.
goto:eof

:copying_begin
echo Copie en cours...
goto:eof

:copying_error
echo Il semble qu'une erreur se soit produite pendant la copie, le fichier créé va être supprimé s'il existe.
echo Vérifiez que la partition sur laquelle vous copiez le fichier est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel le fichier est copié puis réessayez.
echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier le fichier.
goto:eof

:copying_success
echo Copie terminée.
goto:eof

:output_file_size_error
echo Il semble que la taille du fichier créé ne corresponde pas à la taille que devrait faire le fichier de l'emunand via partition, le fichier créé va donc être supprimé.
echo Il est donc conseillé de refaire le dump de la nand puis de réessayer d'exécuter ce script.
echo Si le dump est correct, vérifiez l'espace disque sur la partition sur laquelle vous essayez de copier le dump et vérifiez aussi que cette même partition ai un système de fichier supportant les fichiers de plus de 4 GO.
goto:eof