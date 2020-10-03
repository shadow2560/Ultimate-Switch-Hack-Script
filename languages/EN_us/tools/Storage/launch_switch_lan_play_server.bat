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
title Launch Switch-Lan-Play Server %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:start_launch
echo Preparing and launching server...
goto:eof

:end_launch
echo The Switch-Lan-Play server should be launched. To close it, use the shortcut "ctrl+c" on the server's window or simply close the server's window.
echo This script will end and go back to the previous menu if you press a key but the server will remain active.
goto:eof