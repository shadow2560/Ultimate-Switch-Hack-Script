set lng_label_exist=0
%ushs_base_path%tools\gnuwin32\bin\grep.exe -c -E "^:%~1$" <"%~0" >"%ushs_base_path%temp_lng_var.txt"
set /p lng_label_exist=<"%ushs_base_path%temp_lng_var.txt"
del /q "%ushs_base_path%temp_lng_var.txt"
IF "%lng_label_exist%"=="0" (
	call "!associed_language_script:%language_path%=languages\FR_fr!" "%~1"
	goto:eof
) else (
	goto:%~1
)

:display_title
title Restaure a configuration of the script %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:restaure_file_select
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers ushs ^(*.ushs^)|*.ushs|" "Select restaure file" "templogs\tempvar.txt"
goto:eof

:restaure_success
echo Restaure success.
goto:eof

:restaure_cancel
echo Restaure canceled.
goto:eof