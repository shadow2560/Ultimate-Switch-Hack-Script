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
title Merge splited game %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will join parts a splited XCI/NSP file in one XCI/NSP file.
goto:eof

:game_type_choice
echo What is the file type to join?
echo 1: NSP via files.
echo 2: XCI via files.
echo 3: NSP via folder.
echo 4: XCI via folder.
echo All other choices: Go back to previous menu.
echo.
set /p game_type=Make your choice: 
goto:eof

:game_choice
echo You will need to select the first file of the splited game.
pause
IF "%game_type%"=="1" (
	%windir%\system32\wscript.exe //Nologo tools\Storage\functions\open_file.vbs "" "First NSP splited file ^(*.ns0^)|*.ns0|" "Select first file of the NSP" "templogs\tempvar.txt"
) else IF "%game_type%"=="2" (
	%windir%\system32\wscript.exe //Nologo tools\Storage\functions\open_file.vbs "" "First XCI splited file ^(*.xc0^)|*.xc0|" "Select first file of the XCI" "templogs\tempvar.txt"
) else (
	%windir%\system32\wscript.exe //Nologo tools\Storage\functions\open_file.vbs "" "First XCI/NSP file of folder splited game ^(00^)|00|" "Select first file of folder splited XCI/NSP" "templogs\tempvar.txt"
)
goto:eof

:no_file_selected_error
echo No file selected, the script will stop.
goto:eof

:output_folder_choice
echo You will select the folder where the joined content will be copied.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Select output folder"
goto:eof

:no_output_folder_selected_error
echo No output folder selected, the script will stop.
goto:eof

:output_filename_choice
set /p filename=Enter output filename without the extension, leave empty to cancel: 
goto:eof

:output_filename_char_error
echo Unauthorised char in game file name.
goto:eof

:output_file_exist_choice
set /p erase_file=The file exist where you want to create it, do you want to erase the file already present? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:canceled
echo Action canceled by user.
goto:eof

:input_parts_error
echo Error, it seems that a part of the splited file is missing, the script can not continue.
goto:eof

:merge_end
echo Joining success.
goto:eof