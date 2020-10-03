goto:%~1

:display_title
title Découper un jeu %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de découper un NSP en plusieurs fichiers de 4 GO.
echo Il permet également de pouvoir découper un XCI avec XCI-Cutter.
goto:eof

:cut_type_choice
echo Que souhaitez-vous faire:
echo 1: Découper un NSP?
echo 2: Découper un XCI?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p cut_type=Faites votre choix: 
goto:eof

:nsp_split_type_choice
echo Comment Souhaitez-vous découper votre NSP:
echo 1: Découper le fichier et concerver le fichier original?
echo 2: Découper le fichier mais ne pas concerver le fichier original ^(plus rapide^)?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p split_type=Choisissez comment le découpage du fichier sera fait: 
goto:eof

:nsp_input_file_choice
echo Veuillez renseigner le fichier NSP dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "tools\Storage\functions\open_file.vbs" "" "Fichier NSP^(*.nsp^)|*.nsp|" "Sélection du fichier NSP" "templogs\tempvar.txt"
goto:eof

:no_nsp_input_file_selected_error
echo Aucun fichier NSP renseigné, le script va s'arrêter.
goto:eof

:nsp_output_folder_choice
echo Vous allez devoir sélectionner le dossier dans lequel le NSP découpé sera extrait.
pause
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier de sortie"
goto:eof

:no_nsp_output_folder_selected_error
echo Aucun dossier sélectionné, le script va s'arrêter.
goto:eof

:nsp_split_error
echo Une erreur inconnue s'est produite.
goto:eof

:nsp_split_success
echo Découpage du NSP terminée.
goto:eof

:launch_xcicutter_message
echo XCI Cutter va être lancé pour permettre de découper votre XCI.
goto:eof