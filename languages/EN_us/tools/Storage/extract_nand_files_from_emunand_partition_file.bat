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
title Extract nand file from emunand partition file %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script will extract the BOOT0, BOOT1 and and rawnand.bin files from an emunand partition file.
goto:eof

:input_file_choice
echo You will have to select emunand partition file.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "bin files ^(*.bin^)|*.bin|" "Select emunand partition file" "templogs\tempvar.txt"
goto:eof

:no_input_file_error
echo No input file selected, the script couldn't continue.
goto:eof

:output_folder_choice
echo Now, you will have to select the folder where the "BOOT0", "BOOT1" and "rawnand.bin" files will be copied, be sure to select a folder on a partition supporting the copy of more than 4 GO files ^(EXFAT, NTFS^).
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt" "Select output folder"
goto:eof

:no_output_folder_error
echo No output folder selected, the script couldn't continue.
goto:eof

:erase_boot0_choice
set /p erase_existing_dump_boot0=a "BOOT0" file exist in the folder where you want to create your emunand file, do you  want to erase the existing file? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:erase_boot1_choice
set /p erase_existing_dump_boot1=A "BOOT1" file exist in the folder where you want to create your emunand file, do you  want to erase the existing file? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:erase_rawnand_choice
set /p erase_existing_dump_rawnand=A "rawnand.bin" file exist in the folder where you want to create your emunand file, do you  want to erase the existing file? ^(%lng_yes_choice%/%lng_no_choice%^): 
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
echo It seems that an error ocured during the copy, the files will be removed if they exist.
echo Check if the partition where you want to copy the files support the more than 4 GO file size and check if you have at least 30 GO of free space on the partition and retry.
echo You should also have the write authorisation for the folder where you want to copy the files.
goto:eof

:copying_boot0_error
echo Error during "BOOT0" file copy.
goto:eof

:copying_boot1_error
echo Error during "BOOT1" file copy.
goto:eof

:copying_rawnand_error
echo Error during "rawnand.bin" file copy.
goto:eof

:copying_success
echo Copy success.
goto:eof

:launch_hacdiskmount_choice
set /p launch_hacdiskmount=Do you want to launch HacDiskMount to verify that the rawnand.bin has been correctly copied and that it work correctly ^(recommanded^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:output_rawnand_size_error
echo It seems that the "rawnand.bin" file created has not the expected size, the created file will be removed.
echo Maybe you could try to make the emunand partition dump again and retry.
echo If you are sure that the dump is correct, check if the partition where you want to copy the file support the more than 4 GO file size and check if you have at least 30 GO of free space on the partition and retry.
goto:eof

:output_boot0_size_error
echo It seems that the "BOOT0" file created has not the expected size, the created file will be removed.
echo Maybe you could try to make the emunand partition dump again and retry.
echo If you are sure that the dump is correct, verify the disk space where you want to copy the file.
goto:eof

:output_boot1_size_error
echo It seems that the "BOOT1" file created has not the expected size, the created file will be removed.
echo Maybe you could try to make the emunand partition dump again and retry.
echo If you are sure that the dump is correct, verify the disk space where you want to copy the file.
goto:eof

:input_dump_invalid_error
echo The selected dump seems to be incorrect, the script couldn't continue.
goto:eof