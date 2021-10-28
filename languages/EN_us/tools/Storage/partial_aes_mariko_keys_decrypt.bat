set lng_label_exist=0
"%ushs_base_path%tools\gnuwin32\bin\grep.exe" -c -E "^:%~1$" <"%~0" >"%ushs_base_path%temp_lng_var.txt"
set /p lng_label_exist=<"%ushs_base_path%temp_lng_var.txt"
del /q "%ushs_base_path%temp_lng_var.txt"
IF "%lng_label_exist%"=="0" (
	call "!associed_language_script:%language_path%=languages\FR_fr!" "%~1"
	goto:eof
) else (
	goto:%~1
)

:display_title
title Decrypt partial Mariko console's keys %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script allows to decrypt partial keys obtained via Lockpick-RCM on Mariko consoles.
echo.
echo You will need the file "partialaes.keys" obtained via Lockpick-RCM on the concerned console and you will also have to indicate the file "prod.keys" of the console obtained also via Lockpick-RCM so  the keys thus decrypted will be added in it.
echo.
echo Note that this operation can take a long time, depending on your processor.
goto:eof

:partial_keys_input_file_select_choice
echo Select the "partialaes.keys" file to decrypt.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "All files ^(*.*^)|*.*|" "partialaes.keys file select" "templogs\tempvar.txt"
goto:eof

:partial_keys_input_file_empty_error
echo The "partialaes.keys" file can't be empty, the script will stop.
goto:eof

:prod_keys_file_select_choice
echo Select the "prod.keys" file containing the keys dumped on the console via Lockpick-RCM.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "All files ^(*.*^)|*.*|" "Console\'s keys file select" "templogs\tempvar.txt"
goto:eof

:prod_keys_file_empty_error
echo The key file cannot be empty, the script will stop.
goto:eof

:num_threads_choose
set /p num_threads=Choose the number of threads to use for decryption operations ^(1 if empty, a higher value increases processing speed but uses more resources, choose according to your processor capabilities^): 
goto:eof

:char_not_authorized
echo Char not authorized.
goto:eof

:partial_keys_file_error
echo Error during the analyse of the partial keys file.
goto:eof

:create_partial_key_begin
echo Decryption of the key "%temp_key%"...
goto:eof

:key_already_present_message
echo The "%temp_key_name%" key has been found in the "prod.keys" file, it will not be treated.
goto:eof

:create_partial_key_error
echo An error occured during decryption of the "partialaes.keys" file for the key "%temp_key_name%".
goto:eof

:create_partial_key_success
echo Decryption of the key "%temp_key%" succesful, the key has been added to the end of the "prod.keys" file.
goto:eof

:create_partial_keys_end
echo Process finished.
goto:eof