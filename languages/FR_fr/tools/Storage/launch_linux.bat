goto:%~1

:display_title
title Lancement de Linux ^(ancienne méthode^) %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:missing_files_error
echo Des fichiers sont manquants et Linux ne pourra pas être lancé.
echo Veuillez utiliser l'option de mise à jour de Shofel2 dans le menu précédent pour corriger ce problème.
goto:eof

:kernel_choice
echo Choisissez un kernel.
echo.
echo 1: Kernel officiel ^(recommandé^)
echo 2: Kernel patché ^(si vous avez des erreurs de carte SD au chargement du kernel^)
echo 0: Choisir un fichier de kernel personnel
echo Tout autre choix: Quitter le script.
echo.
set /p choose_kernel=Entrez le numéro du kernel à utiliser: 
goto:eof

:kernel_file_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichier de kernel Linux (*.gz)|*.gz|" "Sélection du kernel" "templogs\tempvar.txt"
goto:eof

:no_kernel_selected_error
echo Aucun kernel sélectionné, le lancement de Linux est annulé.
goto:eof

:rcm_instructions
echo *********************************************
echo ***    CONNECTEZ LA SWITCH EN MODE RCM    ***
echo *********************************************
echo 1^) Connecter la Switch en USB et l'éteindre
echo 2^) Appliquer le JoyCon Haxx : PIN1 + PIN10 ou PIN9 + PIN10
echo 3^) Faire un appui long sur VOLUME UP + appui court sur POWER
goto:eof

:waiting
echo Switch détectée. Attendons 5 secondes...
goto:eof

:reboot_waiting
echo *********************************************
echo ***   ATTENDEZ QUE LA SWITCH REDEMARRE    ***
echo *********************************************
goto:eof

:end_launch
echo *********************************************
echo *** LINUX DEVRAIT SE LANCER SUR LA SWITCH ***
echo *********************************************
goto:eof