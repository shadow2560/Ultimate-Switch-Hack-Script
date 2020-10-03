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
title Downgrade firmware version needed for a game %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will modify a NSP to make it compatible with the lesser possible firmware.
echo Be careful: Preferably, don't use this script on a FAT32 file system because of the 4 GO pair file limit.
goto:eof

:define_new_keys_file_choice
set /p define_new_keys_file=Do you want to define a new default keys file? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:keys_file_not_finded_error
echo Keys file not found, please follow the instructions.
goto:eof

:keys_file_choice
IF /i NOT "%define_new_keys_file%"=="o" (
	echo You'll need to select the keys file in the next window.
	pause
)
%windir%\system32\wscript.exe //Nologo "..\Storage\functions\open_file.vbs" "" "Switch keys list files ^(*.*^)|*.*|" "Select Hactool keys file" "..\..\templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo No keys file selected, the script will stop.
goto:eof

:input_file_choice
echo You will need to select the NSP file to convert.
pause
%windir%\system32\wscript.exe //Nologo ..\Storage\functions\open_file.vbs "" "Switch game files ^(*.nsp^)|*.nsp|" "Select game to convert" "..\..\templogs\tempvar.txt"
goto:eof

:no_input_file_selected_error
echo No game selected, conversion canceled.
goto:eof

:output_folder_choice
echo You will need to select the output folder where the NSP converted will be copied..
pause
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "..\..\templogs\tempvar.txt" "Select output folder"
goto:eof

:no_output_folder_selected_error
echo No output folder selected, conversion canceled.
goto:eof

:converting_error
echo Error during conversion process.
goto:eof

:converting_success
echo Conversion success.
goto:eof