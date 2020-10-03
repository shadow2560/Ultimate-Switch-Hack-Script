goto:%~1

:display_title
title Réunification d'une nand découpée %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de joindre un dump de la nand Switch effectué par Hekate/ReiNX ou SX OS qui a été découpé ^(carte formatée en FAT32 pour le dump, carte SD trop petite pour faire un dump en une fois...^).
echo Une fois le dump terminé, il sera nommé "rawnand.bin" et se trouvera dans le répertoire indiqué lors du script.
goto:eof

:CFW_used_choice
echo Quel moyen avez-vous utilisé pour faire votre dump?
echo 1: Hekate ou ReiNX.
echo 2: SX OS.
echo N'importe quel autre choix: Retour au menu précédent.
echo.
set /p cfw_used=Faites votre choix: 
goto:eof

:input_folder_choice
echo Vous allez devoir sélectionner le répertoire dans lequel se trouve vos fichiers de dump.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier du dump de la nand"
goto:eof

:no_input_folder_selected_error
echo Aucun dossier d'entrée sélectionné, le script va s'arrêter.
goto:eof

:input_files_missing_error
echo Il semble que des fichiers du dump soient manquants, la copie ne peut donc pas avoir lieu et ce script va s'arrêter.
goto:eof

:output_folder_choice
echo Vous allez maintenant devoir sélectionner le répertoire vers lequel sera copié le fichier "rawnand.bin" du dump joint. Attention, le dossier devra se trouver sur une partition supportant les fichiers de plus de 4 GO ^(EXFAT, NTFS^). Notez qu'une fois le fichier créé et son bon fonctionnement confirmé par vos soins, les fichiers découpés pouront être supprimé.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier de sortie"
goto:eof

:no_output_folder_selected_error
echo Aucun dossier de sortie sélectionné, le script va s'arrêter.
goto:eof

:erase_existing_file_choice
set /p erase_existing_dump=Un fichier "rawnand.bin" a été trouvé à l'emplacement de copie du nouveau dump, souhaitez-vous écraser le dump précédent ^(la suppression du dump sera faite tout de suite après ce choix donc soyez prudent^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
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
echo Il semble qu'une erreur se soit produite pendant la copie, le fichier créé va être supprimé s'il existe.
echo Vérifiez que la partition sur laquelle vous copiez le fichier est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel le fichier est copié puis réessayez.
echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier le fichier.
goto:eof

:copying_end
echo Copie terminée.
echo.
set /p launch_hacdiskmount=Souhaitez-vous lancer HacDiskMount pour vérifier que le dump a bien été copié et qu'il fonctionne correctement ^(recommandé^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:output_size_error
echo Il semble que la taille du fichier créé ne corresponde pas à la taille que devrait faire le dump de la nand, le fichier créé va donc être supprimé.
echo Il est donc conseillé de refaire le dump de la nand puis de réessayer d'exécuter ce script.
echo Si le dump est correct, vérifiez l'espace disque sur la partition sur laquelle vous essayez de copier le dump et vérifiez aussi que cette même partition ai un système de fichier supportant les fichiers de plus de 4 GO.
goto:eof