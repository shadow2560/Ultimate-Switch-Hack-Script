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
title Split nand %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will split a rawnand dump, for example this could be useful to use it for the Atmosphere's emunand on a FAT32 formated SD card.
goto:eof

:input_rawnand_choice
echo You will have to select the rawnand file that you want to split.
pause
%windir%\system32\wscript.exe //Nologo "tools\Storage\functions\open_file.vbs" "" "bin files ^(*.bin^)|*.bin|" "Select nand dump file" "templogs\tempvar.txt"
goto:eof

:no_input_file_selected_error
echo No input file select, the script couldn't continue.
goto:eof

:invalid_input_file_error
echo The selected file is not a valid rawnand dump or is already splitted, the script couldn't continue.
goto:eof

:output_folder_choice
echo Now you will have to select the folder where the splitted dump will be copied.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Select output folder"
goto:eof

:no_output_selected_error
echo No output folder selected, the script couldn't continue.
goto:eof

:parts_number_choice
set /p parts_number=Select the parts number that you want ^(from 2 to 64^): 
goto:eof

:empty_parts_number_error
echo The parts number couldn't be empty.
goto:eof

:bad_value_parts_number_error
echo Bad value for parts number.
goto:eof

:parts_number_char_error
echo Unauthorised char for parts value.
goto:eof

:parts_number_too_low_error
echo Parts number can't be lesser than 2.
goto:eof

:parts_number_too_high_error
echo Parts number can't be greater than 64.
goto:eof

:output_rename_choice
set /p rename_files=Do you want to rename  the files of the splitted dump to be compatible with Atmosphere emunand? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:not_enough_disk_space_error
echo Not enough space on disk where you want to copy the file, the script couldn't continue.
goto:eof

:copying_begin
echo Copying...
goto:eof

:copying_error
echo It seems that an error ocured during the copy, the file will be removed if it exist.
echo Check if you have at least 30 GO of free space on the partition where you want to copy the dump and retry.
echo You should also have the write authorisation for the folder where you want to copy the file.
goto:eof

:copying_end
echo Copy success.
goto:eof