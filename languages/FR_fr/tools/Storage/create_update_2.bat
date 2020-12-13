goto:%~1

:display_title
title EmmcHaccGen %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:folder_script_param_error
echo Une erreur de saisie du paramètre du dossier s'est produite, le script va s'arrêter.
goto:eof

:keys_file_selection
	echo Veuillez renseigner le fichier de clés lié à la console dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\open_file.vbs" "" "Fichier de liste de clés Switch^(*.*^)|*.*|" "Sélection du fichier de clés pour Hactool" "%calling_script_dir%\templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo Aucun fichier clés renseigné, le script va s'arrêter.
goto:eof

:launch_xci_explorer_choice
echo Il est possible de lancer XCI Explorer pour extraire la partition "update" d'un fichier XCI. Notez que si vous choisissez de le lancer, le script ne pourra continuer qu'après la fermeture de XCI Explorer.
set /p launch_xci_explorer=Souhaitez-vous lancer XCI Explorer? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:package_folder_select
%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\select_dir.vbs" "%calling_script_dir%\templogs\tempvar.txt" "Sélection du dossier contenant la mise à jour extraite"
goto:eof

:bad_choice_error
echo Ce choix n'est pas supporté.
goto:eof

:no_source_selected_error
echo Aucun répertoire de mise à jour  renseigné, le script va s'arrêter.
goto:eof

:noexfat_param_choice
set /p no_exfat=Souhaitez-vous désactiver le support pour le format EXFAT des cartes SD? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:package_creation_success
echo Firmware créé avec succès dans le répertoire "update_packages" du script.
goto:eof

:package_creation_error
echo Un problème est survenu pendant la création du firmware.
echo Vérifiez que le fichier de clés fournis soit bien lié à la console et qu'il soit bien complet.
echo Vérifiez également l'espace libre sur le disque dur contenant ce script.
goto:eof