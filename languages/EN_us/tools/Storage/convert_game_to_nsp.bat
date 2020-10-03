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
title Convert XCI to NSP %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will convert a XCI file to NSP, file wich could be installed via Goldleaf, Tinfoil, the SX OS menu or via the Devmenu.
echo Be careful, this script shouldn't be executed on a FAT32 partition because this file system doesn't accept files bigger than 4 GB.
goto:eof

:define_new_keys_file_choice
set /p define_new_keys_file=Do you want to define a new default keys file? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:keys_file_not_finded
echo Keys file not found, please follow the instructions.
goto:eof

:keys_file_selection
IF /i NOT "%define_new_keys_file%"=="o" (
	echo You'll need to select the keys file in the next window.
	pause
)
%windir%\system32\wscript.exe //Nologo "..\Storage\functions\open_file.vbs" "" "Switch keys list files ^(*.*^)|*.*|" "Select Hactool keys file" "..\..\templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo No keys file selected, the script will stop.
goto:eof

:xci_file_selection
echo You will select the file to convert.
pause
%windir%\system32\wscript.exe //Nologo ..\Storage\functions\open_file.vbs "" "Switch game file ^(*.xci^)|*.xci|" "Select game file to convert" "..\..\templogs\tempvar.txt"
goto:eof

:no_game_selected_error
echo No game selected, the conversion is canceled.
goto:eof

:output_folder_select
echo You will select the folder where the converted NSP will be copied.
pause
%windir%\system32\wscript.exe //Nologo ..\Storage\functions\select_dir.vbs "..\..\templogs\tempvar.txt" "Select output folder"
goto:eof

:no_output_folder_error
echo No output folder selected, the conversion is canceled.
goto:eof

:rename_param_choice
set /p rename_target=Do you want the game file to be renamed with info based on the game name ^(if not it will be renamed with the ID infos^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:kipncaid_param_choice
set /p keepncaid=Do you want the NCA's IDs of the NSP to be kept ^(deactivating this option is recommanded^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:converting_error
echo Error during conversion process.
goto:eof

:converting_success
echo Conversion success.
goto:eof