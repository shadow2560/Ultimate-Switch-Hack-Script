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
title payload conversion to boot.dat %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script allows to convert a payload file in a "boot.dat" file, this can be usful for those who use hardware attached to SXOS.
goto:eof

:begin_payload_choice
echo Select the payload file to convert:
goto:eof

:end_payload_choice
echo 0: Choose a payload file.
echo All other choices: Go back to main menu.
echo.
set /p payload_number=Make your choice: 
goto:eof

:payload_input_file_select_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Bin files ^(*.bin^)|*.bin|" "payload file select" "templogs\tempvar.txt"
goto:eof

:payload_input_file_empty_error
echo The payload file cannot be empty, the script will stop.
goto:eof

:output_folder_choice
echo You will need to select the folder where to create the "boot.dat" file.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Folder select"
goto:eof

:output_folder_empty_error
echo The directory where to create the "boot.dat" file cannot be empty, the function will be cancelled.
goto:eof

:erase_existing_file_choice
set /p erase_output_file=This folder already contains a "%payload_output_file%", file, do you really want to continue overwriting the existing file ^(if so, the file will be deleted just after this choice^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:create_payload_error
echo An error occurred during the creation of the "boot.dat" file.
goto:eof

:create_payload_success
echo Creation of the "boot.dat" file successfully completed.
goto:eof