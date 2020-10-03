goto:%~1

:display_title
title Restauration d'une configuration du script %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:restaure_file_select
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers ushs ^(*.ushs^)|*.ushs|" "Sélection du fichier de restauration" "templogs\tempvar.txt"
goto:eof

:restaure_success
echo Restauration terminée.
goto:eof

:restaure_cancel
echo Restauration annulée.
goto:eof