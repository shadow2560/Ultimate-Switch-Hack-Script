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
title SXOS licence spoof %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script allows to create a "boot.dat" file with a spoof for a license.
echo.
echo You must have the "boot.dat" file of SXOS 3.1.0 and the fingerprint and license of a console.
echo.
echo To find the console fingerprint, start SXOS and go to "album" to display the SXOS menu, then press "R" once and you will find the "console fingerprint" under the license number.
goto:eof

:boot_file_selection
	echo Select the "boot.dat" file to modify.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Fichier dat^(*.dat^)|*.dat|" "Sélection du fichier du boot.dat à modifier" "templogs\tempvar.txt"
goto:eof

:no_boot_file_selected_error
echo No SXOS file selected, the script will stop.
goto:eof

:fingerprint_set
set /p fingerprint=Enter the fingerprint of the console to spoof ^(32 hexadecimal characters^) ^(leave empty to exit the script^): 
goto:eof

:fingerprint_error_number_chars
echo The number of characters entered must be 32.
goto:eof

:fingerprint_error_char_not_authorized
echo A character entered is incorrect.
goto:eof

:boot_creation_success
echo File successfully modified.
goto:eof

:boot_creation_error
echo Error while modifying the file.
goto:eof