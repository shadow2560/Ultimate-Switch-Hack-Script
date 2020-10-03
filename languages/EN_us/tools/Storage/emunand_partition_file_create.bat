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
title Emunand partition file create %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will create a file witch could be injected to a SD card to boot on Emunand.
echo You should have a folder containing BOOT0, BOOT1 and rawnand files dumped via Hekate or SX OS
echo When the script will finish, an file named "emunand_partition.bin" will be created on the output folder indicated during the script.
goto:eof

:cfw_dump_choice
echo How did you have done the dump?
echo 1: Hekate.
echo 2: SX OS.
echo All other choices: Go back to previous menu.
echo.
set /p cfw_used=Make your choice: 
goto:eof

:dump_folder_choice
echo You will have to select the folder where the input files are.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Select nand folder dump"
goto:eof

:no_folder_selected_error
echo No input folder selected, the script couldn't continue.
goto:eof

:boot0_not_finded_error
echo "BOOT0" file not finded, the script couldn't continue.
goto:eof

:boot1_not_finded_error
echo "BOOT1" file not finded, the script couldn't continue.
goto:eof

:missing_files_in_dump_error
echo It seems that dump files are missing, the script couldn't continue.
goto:eof

:output_folder_choice
echo Now, you will have to select the folder where the "emunand_partition.bin" file will be copied, be sure to select a folder on a partition supporting the copy of more than 4 GO files ^(EXFAT, NTFS^).
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Select output folder"
goto:eof

:no_output_folder_error
echo No output folder selected, the script couldn't continue.
goto:eof

:erase_emunand_file_exist_in_output_folder_choice
set /p erase_existing_dump=A "emunand_partition.bin" file exist in the folder where you want to create your emunand file, do you  want to erase the existing file? ^(the file will be removed  just after this choice^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:canceled
echo Operation canceled.
goto:eof

:not_enough_disk_free_space_error
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

:copying_success
echo Copy success.
goto:eof

:output_file_size_error
echo It seems that the file created has not the expected size, the created file will be removed.
echo Maybe you could try to make the dump again and retry.
echo If you are sure that the dump is correct, check if the partition where you want to copy the file support the more than 4 GO file size and check if you have at least 30 GO of free space on the partition and retry.
goto:eof