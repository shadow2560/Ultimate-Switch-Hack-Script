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
title Merge splited nand %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will join a splited rawnand dump made by Hekate/ReiNX or SX OS.
echo When the script will end, the file generated will be named "rawnand.bin" and will be placed on the output folder indicated.
goto:eof

:CFW_used_choice
echo How do you made the dump?
echo 1: Hekate or ReiNX.
echo 2: SX OS.
echo All other choices: Go back to previous menu.
echo.
set /p cfw_used=Make your choice: 
goto:eof

:input_folder_choice
echo You will need to select the folder containing the splited dump.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Select folder of the splited nand dump"
goto:eof

:no_input_folder_selected_error
echo No input folder selected, the script couldn't continue.
goto:eof

:input_files_missing_error
echo It seems that some files of the dump are missing, the script couldn't continue..
goto:eof

:output_folder_choice
echo You will need to select the output folder where the "rawnand.bin" file will be copied. Not that you must select a folder on a partition supporting the 4 GO file size ^(EXFAT, NTFS^).
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Select output folder"
goto:eof

:no_output_folder_selected_error
echo No output folder selected, the script couldn't continue..
goto:eof

:erase_existing_file_choice
set /p erase_existing_dump=A "rawnand.bin" file exist in the folder where you want to create your joined dump file, do you  want to erase the existing file? ^(the file will be removed  just after this choice^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:canceled
echo Operation canceled.
goto:eof

:not_enough_disk_space_error
echo Not enough space on disk where you want to copy the file, the script couldn't continue.
goto:eof

:copying_begin
echo Copying...
goto:eof

:copying_error
echo It seems that an error ocured during the copy, the file will be removed if it exist.
echo Check if the partition where you want to copy the file support the more than 4 GO file size and check if you have at least 30 GO of free space on the partition and retry.
echo You should also have the write authorisation for the folder where you want to copy the file.
goto:eof

:copying_end
echo Copy success.
echo.
set /p launch_hacdiskmount=Do you want to launch  HacDiskMount to verify that the dump is correct ^(recommandé^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:output_size_error
echo It seems that the file created has not the expected size, the created file will be removed.
echo Maybe you could try to make the dump again and retry.
echo If you are sure that the dump is correct, check if the partition where you want to copy the file support the more than 4 GO file size and check if you have at least 30 GO of free space on the partition and retry.
goto:eof