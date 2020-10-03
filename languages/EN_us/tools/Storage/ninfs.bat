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
title Ninfs %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will use Ninfs to mount a rawnand dump file on your system.
echo For unmounting, on the Window where Ninfs is launched, use the shorcut ctrl+c or close the window.
goto:eof

:first_action_choice
echo Ninfs
echo.
echo What do you want to do?
echo.
echo 1: Use Ninfs to mount a rawnand dump file?
echo 2: Install Winfsp ^(to do only one time^)?
echo All other choices: Go back to previous menu?
echo.
set /p action_choice=Make your choice: 
goto:eof

:dump_not_exist_error
echo No dump file selected.
goto:eof

:ninfs_input_begin
echo You will have to select the rawnand dump file to use with Ninfs, quit the file selection without selecting anything to go back to main action choice of this script.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "All files ^(*.*^)|*.*|" "Select rawnand dump file" "templogs\tempvar.txt"
goto:eof

:ninfs_nand_type_error
echo You couldn't use Ninfs on the nand selected, the script couldn't continue.
goto:eof

:ninfs_biskeys_not_valid_error
echo Error during the test of Bis keys, the script couldn't continue.
goto:eof

:biskeys_file_select_choice
echo You will have to select the file containing the Bis keys to use.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "all files ^(*.*^)|*.*|" "Select the file containing the Bis keys" "templogs\tempvar.txt"
goto:eof

:biskeys_file_not_selected_error
echo No file containing Bis keys selected, the script couldn't continue.
goto:eof