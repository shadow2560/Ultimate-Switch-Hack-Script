goto:%~1

:display_title
title SNES Injector %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va vous permettre de préparer l'émulateur Snes Classic Edition avec vos jeux et vos images.
echo Une fois le travail terminé, l'émulateur ainsi configuré pourra être copié via la fonction de préparation d'une SD si le homebrew est inclu pendant la préparation.
echo Attention, les jeux et les images de l'émulateur seront toujours remis à zéro, la configuration précédente ne sera pas gardée à partir du moment où un dossier de jeux est indiqué.
goto:eof

:no_game_in_source_folder_error
echo Aucun jeu dans le dossier "%source_roms%", le script ne peut donc rien faire.
goto:eof

:operations_success
echo Opérations effectuées.
goto:eof

:no_image_for_the_game_warning
echo Aucune image trouvée pour le jeu "%space%, une image par défaut sera donc copiée.
goto:eof

:images_folder_choice
echo Vous allez devoir sélectionner le répertoire contenant les images correspondant à vos jeux. Attention, le nom des images doit correspondre au nom du jeu auquel il est associé.
echo Si la source est laissée vide, l'image par défaut sera utilisée pour tous les jeux.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier des images"
goto:eof

:no_images_folder_defined_warning
echo Aucune source d'images, le script utilisera donc l'image par défaut pour tous les jeux.
goto:eof

:roms_folder_choice
echo Vous allez devoir sélectionner le répertoire contenant vos jeux.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier de jeux"
goto:eof

:no_roms_folder_defined_error
echo La source des jeux ne peut être vide.
goto:eof