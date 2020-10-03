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
title Save conversion BOTW %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will convert a Zelda Breath Of The Wild Wii U gamesave to Switch and Switch to Wii U.
echo You will need to select the folder containing the folders of the gamesave ^(the one containing the file ""option.sav""^), press "y" to launch the conversion, press "enter" at the end of the conversion and copy the folder to the Checkpoint or EdiZon folder to install the gamesave on Switch. On Wii U, you will need to to copy it to the Savemi Mod folder or restaure it with Saviine.
echo The converted save will be in the "BOTW_save" folder on script's root folder.
goto:eof

:select_save_folder
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"  "Select BOTW save folder"
goto:eof

:no_folder_selected_error
echo No folder selected, the script couldn't continue.
goto:eof

:error_with_save_file
echo It seems that the selected folder doesn't contain a Zelda Breath OF The Wild save, the script will stop.
goto:eof

:intro_copying_files
echo Copying files...
goto:eof

:end_copying_files
echo Copy success.
goto:eof

:converting_success
echo Save conversion success.
goto:eof