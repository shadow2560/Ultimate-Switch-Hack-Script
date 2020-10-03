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
title Emulators profiles management %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:main_action_choice
echo Emulators profiles management
echo.
echo What do you want to do?
echo.
echo 1: Create a profile?
echo 2: Modify a profile?
echo 3: Remove a profile?
echo 0: List emulators on a profile?
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
echo Emulators in the profile:
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

:delete_profile_finded_in_general_profile
echo This profile is used in the following general profiles:
goto:eof

:delete_profile_finded_in_general_profile2
set /p define_del_profile=Remove this profile will remove the associed general profiles, do you want to countinue? ^(%lng_yes_choice%/%lng_no_choice%^): 
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

:no_emulators_in_profile_error
echo No emulators in this profile.
goto:eof

:intro_emulators_one_page
echo Select an emulator to add or remove it in the profile "%temp_profile:~0,-4%"
goto:eof

:intro_emulators_multi_page
echo Select an emulator to add or remove it in the profile "%temp_profile:~0,-4%", page %selected_page%/%page_number%
goto:eof

:add_remove_emulators_info
echo The emulators prefixed by an "*" are the emulators present in the profile.
goto:eof

:change_page_info
echo P: Change page, the "P" must be followed by a valid page number.
goto:eof

:add_remove_emulators_choice_ending
echo All other choices: Stop the emulators list modification of the profile.
echo.
set /p homebrew_choice=Choose an emulator to add/remove it or select an other page: 
goto:eof

:page_not_exist_error
echo This page doesn't exist.
goto:eof

:no_emulators_in_emulators_folder
echo Error, no emulators in the "tools\sd_switch\emulators\pack" folder of the script, the process couldn't continue.
goto:eof

:canceled
echo Operation canceled.
goto:eof