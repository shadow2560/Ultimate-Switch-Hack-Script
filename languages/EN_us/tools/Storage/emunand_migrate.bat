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
title Migrate emunand %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This script allow to migrate an emunand from SXOS to Atmosphere.
goto:eof

:no_disk_found_error
echo No compatible disk found, please insert your drive.
echo.
set /p disk_not_finded_choice=Do you want to try to reload the disks list ^(if not, the script will end^)? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:disk_list_begin
echo Disk list:
goto:eof

:disk_list_choice
echo 0: Go back to principal action of this script.
echo.
echo.
set /p volume_letter=Enter the volume letter that you want to use: 
goto:eof

:disk_choice_empty_error
echo The volue letter couldn't be empty.
goto:eof

:disk_choice_char_error
echo Unauthorised char in volume letter.
goto:eof

:disk_choice_not_exist_error
echo This volume doesn't exist.
goto:eof

:disk_choice_letter_not_exist_error
echo This volume letter isn't in the list.
goto:eof

