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
title General profiles management for SD prepare script %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:main_action_choice
echo General profiles management for SD prepare script.
echo.
echo What do you want to do?
echo.
echo 1: Create a profile?
echo 2: Modify a profile?
echo 3: Remove a profile?
echo 0: Obrain infos on the files copied by a profile?
echo All other choices: Go back to previous menu?
echo.
set /p action_choice=Make your choice: 
goto:eof

:intro_info_profile
echo Profile infos
goto:eof

:info_no_profile_exist_error
echo No profile created, you need to create one to obtain infos on it.
goto:eof

:info_profile
echo Profile name: %profile_selected:~0,-4%
goto:eof

:intro_create_profile
echo Creating a profile
echo.
set /p new_profile_name=Enter the profile's name, leave empty to cancel this operation: 
goto:eof

:char_error_in_profile_name
echo Unauthorised char in profile's name.
goto:eof

:create_profile_success
echo Profile "%new_profile_name%" creation success.
goto:eof

:intro_modify_profile
echo Profile modifying
goto:eof

:modify_no_profile_exist_error
echo No profile created, you need to create one to modify it.
goto:eof

:intro_delete_profile
echo Profile removing
goto:eof

:delete_no_profile_exist_error
echo No profile created, you need to create one to remove it.
goto:eof

:delete_profile_success
echo Profile "%profile_selected:~0,-4%" remove success.
goto:eof

:intro_select_profile
echo Select a profile:
goto:eof

:select_profile_choice
echo All other choices: Go back to previous action.
echo.
set /p profile_choice=Make your choice: 
goto:eof

:values_saved_success
echo Values saved with success for the profile %profile_selected:~0,-4%.
goto:eof