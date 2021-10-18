set lng_label_exist=0
"%ushs_base_path%tools\gnuwin32\bin\grep.exe" -c -E "^:%~1$" <"%~0" >"%ushs_base_path%temp_lng_var.txt"
set /p lng_label_exist=<"%ushs_base_path%temp_lng_var.txt"
del /q "%ushs_base_path%temp_lng_var.txt"
IF "%lng_label_exist%"=="0" (
	call "!associed_language_script:%language_path%=languages\FR_fr!" "%~1"
	goto:eof
) else (
	goto:%~1
)

:display_title
title Save important files of the script %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:filename_choice
set /p filename=Enter save name: 
goto:eof

:filename_empty_error
echo The save name couldn't be empty.
goto:eof

:filename_char_error
echo Unauthorized char in save name.
goto:eof

:output_folder_choice
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Select save output folder"
goto:eof

:copy_firmwares_choice
set /p copy_firmwares=Do you want to copy all the firmwares already downloaded into the save ^(could be a realy biggest save file if you want it^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:save_begin
echo Creating save file...
goto:eof

:save_create_error
echo Error during the creation of the save file, there is probably not enough space on the disk.
goto:eof

:save_end
echo Save file created.
goto:eof