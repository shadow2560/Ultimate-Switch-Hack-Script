goto:%~1

:display_title
title Réunification d'un jeu découpé %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de joindre les parties d'un fichier XCI ou NSP découpé en un seul fichier XCI ou NSP.
goto:eof

:game_type_choice
echo Quel est le type de fichier à joindre?
echo 1: NSP via fichiers.
echo 2: XCI via fichiers.
echo 3: NSP via dossier.
echo 4: XCI via dossier.
echo N'importe quel autre choix: Retourne au menu précédent.
echo.
set /p game_type=Faites votre choix: 
goto:eof

:game_choice
echo Vous allez devoir sélectionner le premier fichier du jeu splitté.
pause
IF "%game_type%"=="1" (
	%windir%\system32\wscript.exe //Nologo tools\Storage\functions\open_file.vbs "" "Premier fichier d'un jeu NSP splitté ^(*.ns0^)|*.ns0|" "Sélection du premier fichier du contenu" "templogs\tempvar.txt"
) else IF "%game_type%"=="2" (
	%windir%\system32\wscript.exe //Nologo tools\Storage\functions\open_file.vbs "" "Premier fichier d'un jeu XCI splitté ^(*.xc0^)|*.xc0|" "Sélection du premier fichier du contenu" "templogs\tempvar.txt"
) else (
	%windir%\system32\wscript.exe //Nologo tools\Storage\functions\open_file.vbs "" "Premier fichier d'un jeu NSP ou XCI splitté via dossier ^(00^)|00|" "Sélection du premier fichier du contenu" "templogs\tempvar.txt"
)
goto:eof

:no_file_selected_error
echo Aucun fichier sélectionné, le script va s'arrêter.
goto:eof

:output_folder_choice
echo Vous allez devoir sélectionner le répertoire vers lequel créé le fichier réunifié.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Sélection du dossier de sortie"
goto:eof

:no_output_folder_selected_error
echo Aucun dossier sélectionné, le script va s'arrêter.
goto:eof

:output_filename_choice
set /p filename=Entrez le nom du fichier que vous souhaitez en sortie sans l'extension, laissez vide pour annuler: 
goto:eof

:output_filename_char_error
echo Un caractère non autorisé a été saisie dans le nom du jeu.
goto:eof

:output_file_exist_choice
set /p erase_file=Le fichier existe déjà à l'emplacement indiqué, souhaitez-vous l'écraser? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:canceled
echo Action annulée par l'utilisateur.
goto:eof

:input_parts_error
echo Erreur, il semble qu'un fichier soit manquant dans le nombre des parties de celui-ci, le script ne peut continuer.
goto:eof

:merge_end
echo Assemblage du fichier terminé.
goto:eof