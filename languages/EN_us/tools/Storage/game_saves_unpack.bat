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
title Extract gamesaves %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script allows you to extract the contents of a gamesave file or gamesave files contained in a folder.
echo To be able to use this script, you will first have to retrieve the gamesaves to be extracted in the "save" folder of the RAWNAND "USER" partition or where these files are located if you have configured it otherwise in your CFW, using HacDiskMount for RAWNAND; this action will not be covered by this script.
echo Once the gamesave is extracted, you will have to identify by yourself the game to which it is linked (you can use Checkpoint or EdiZon to help you by extracting the backup from the games) and then replace the files of the backup extracted by Checkpoint or EdiZon with the files extracted by this script and then you can restore this modified backup via Checkpoint or EdiZon.
goto:eof

:main_action_choice
echo What do you want to do:
echo 1: Extract a gamesave file?
echo 2: Extract all gamesaves contained in a folder ^(the sub-folders will not be analysed^)?
echo All other choice: Back to previous menu?
echo.
set /p action_choice=Make your choice: 
goto:eof

:input_file_choice
echo You will have to select the gamesave file.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "All files ^(*.*^)|*.*|" "Gamesave file selection" "templogs\tempvar.txt"
goto:eof

:no_input_file_error
echo No input file selected, back to the beginning of the script.
goto:eof

:extract_begin
echo Extracting...
goto:eof

:extract_end
echo End of the extraction.
goto:eof

:input_folder_choice
echo You will have to select the folder containing the gamesaves to extract.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Input folder selection"
goto:eof

:no_input_folder_error
echo No input folder selected, back to the beginning of the script.
goto:eof

:output_folder_choice
echo Now you will have to select the output folder.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Output folder selection"
goto:eof

:no_output_folder_error
echo No output folder selected, back to the beginning of the script.
goto:eof