goto:%~1

:display_title
title Vérifier des NSP %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de vérifier les fichiers NSP contenus dans un dossier et ses sous-dossiers.
echo Une fois terminé, les fichiers listants les NSP ayant un problème se trouveront à la racine du script.
echo Si aucun fichier n'a été créé, cela signifie que les NSPs vérifiés n'ont aucun problèmes.
goto:eof

:define_new_keys_file_choice
set /p define_new_keys_file=Souhaitez-vous définir un nouveau fichier de clés par défaut? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:keys_file_not_finded_error
echo Fichiers clés non trouvé, veuillez suivre les instructions.
goto:eof

:keys_file_choice
IF /i NOT "%define_new_keys_file%"=="o" (
	echo Veuillez renseigner le fichier de clés dans la fenêtre suivante.
	pause
)
%windir%\system32\wscript.exe //Nologo "..\Storage\functions\open_file.vbs" "" "Fichier de liste de clés Switch^(*.*^)|*.*|" "Sélection du fichier de clés pour Hactool" "..\..\templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo Aucun fichier clés renseigné, le script va s'arrêter.
goto:eof

:input_folder_choice
echo Vous allez devoir sélectionner le dossier contenant vos fichiers NSP. Notez que les sous-dossiers seront également scanés.
pause
%windir%\system32\wscript.exe //Nologo ..\Storage\functions\select_dir.vbs "..\..\templogs\tempvar.txt" "Sélection du dossier des NSPs"
goto:eof

:no_input_folder_selected_error
echo Aucun dossier sélectionné, la vérification est annulée.
goto:eof

:verifying_error
echo Une erreur inconnue s'est produite.
goto:eof

:no_error_in_nsp_files
echo Tout les NSPs vérifiés semblent n'avoir aucune erreur selon NSPVerify.
goto:eof

:no_error_during_exec
echo Aucun problème ne semble avoir été rencontré pendant l'exécution de NSPVerify.
goto:eof

:verify_end
echo Vérification des fichiers terminée.
goto:eof