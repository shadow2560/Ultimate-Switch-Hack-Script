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

:patched_console_choice
set /p patched_console=Souhaitez-vous créer  un package pour une console patchée? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:mariko_console_param_choice
set /p mariko_console=Souhaitez-vous créer un package pour une console Mariko ^(numéro de série ne commençant pas par "XA"^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:autorcm_param_choice
set /p autorcm=Souhaitez-vous désactiver l'auto-RCM? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:package_creation_success
echo Firmware créé avec succès.
goto:eof

:package_creation_error
echo Un problème est survenu pendant la création du firmware.
echo Vérifiez que vous avez bien toutes les clés requises.
goto:eof

:emmchaccgen_package_creation_first_error
echo Un problème est survenu pendant la création du firmware.
echo Vérifiez que vous avez bien toutes les clés requises.
echo.
echo Cependant, il est aussi possible que .net Framework 3 ne soit pas installé sur votre système.
echo.
choice /c %lng_yes_choice%%lng_no_choice% /n /m "Souhaitez-vous installer .net Framework 3 sur votre système? ^(%lng_yes_choice%/%lng_no_choice%^): "
goto:eof

:netfx3_install_error
echo Erreur durant l'installation de .net Framework 3.
goto:eof

:emmchaccgen_package_creation_second_error
echo Un problème est survenu pendant la création du firmware.
echo Vérifiez que vous avez bien toutes les clés requises.
echo.
echo Cependant, il est aussi possible que votre système nécessite un redémarrage.
echo Vous pouvez essayer de quitter le script, redémarrer votre système et retenter la procédure.
goto:eof