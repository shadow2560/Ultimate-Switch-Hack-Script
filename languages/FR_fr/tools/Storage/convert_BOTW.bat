goto:%~1

:display_title
title Convertion sauvegarde BOTW %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va vous permettre de convertir une sauvegarde de Zelda Breath Of The Wild Wii U vers Switch ou inversement.
echo Vous devrez donc choisir le dossier contenant l'ensemble des dossiers de la sauvegarde ^(celui qui contient le fichier "option.sav"^), appuyez sur "y" pour lancer la conversion, appuyez sur "Entrer" à la fin de celle-ci et une fois terminée, copier la nouvelle sauvegarde dans le dossier adéquat du homebrew EdiZon ou Checkpoint pour la restaurer sur la Switch. Pour la Wii U, il faudra la copier dans le dossier de Savemi Mod ou la restaurer via Saviine.
echo La sauvegarde convertie se trouvera dans le dossier "BOTW_save" à la racine du script.
goto:eof

:select_save_folder
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"  "Sélection du dossier de la sauvegarde de BOTW"
goto:eof

:no_folder_selected_error
echo Aucun dossier sélectionné, le script va s'arrêter.
goto:eof

:error_with_save_file
echo Il semblerai que le dossier sélectionné ne contienne pas une sauvegarde de Zelda Breath OF The Wild, le script va s'arrêter.
goto:eof

:intro_copying_files
echo Copie des fichiers en cours...
goto:eof

:end_copying_files
echo Copie terminée.
goto:eof

:converting_success
echo Conversion de la sauvegarde terminée.
goto:eof