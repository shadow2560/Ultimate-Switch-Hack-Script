goto:%~1

:display_title
title NSC_Builder %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:define_new_keys_file_choice
set /p define_new_keys_file=Souhaitez-vous définir un nouveau fichier de clés par défaut? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:keys_file_not_finded
echo Fichiers clés non trouvé, veuillez suivre les instructions.
goto:eof

:keys_file_choice
IF /i NOT "%define_new_keys_file%"=="o" (
	echo Veuillez renseigner le fichier de clés dans la fenêtre suivante.
	pause
)
%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\open_file.vbs" "" "Fichier de liste de clés Switch^(*.*^)|*.*|" "Sélection du fichier de clés pour Hactool" "%calling_script_dir%\templogs\tempvar.txt"
goto:eof

:no_keys_file_selected
echo Aucun fichier clés renseigné, le script va s'arrêter.
goto:eof

:choose_nscb_language
echo Choisir la langue de NSC_Builder:
echo 1: Français?
echo Tout autre choix: Anglais?
echo.
set /p nscb_language_choice=Faites votre choix: 
goto:eof

:open_output_dir_choice
set /p open_output_dir=Souhaitez-vous ouvrir le répertoire contenant les fichiers convertis? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:output_dir_not_exist_error
echo Le répertoire n'existe pas, peut-être que NSC_Builder n'a pas été exécuté totalement, par exemple vous pourriez avoir quitté le script avant la fin de la configuration de celui-ci.
goto:eof